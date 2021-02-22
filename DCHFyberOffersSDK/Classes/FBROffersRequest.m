//
//  FBOffersRequest.m
//  Pods
//
//  Created by Daniel on 04/10/15.
//
//

#import "FBROffersRequest.h"
#import "NSString+SHA.h"
#import "FBRLinkGenerator.h"
#import "FBRFyberParametersKeys.h"

#import "FBRFyber.h"

typedef void (^BackendCompletion)(NSData * _Nullable data,
                                  NSURLResponse * _Nullable response,
                                  NSError * _Nullable error);

static NSString * const kSignatureHTTPHeaderField = @"X-Sponsorpay-Response-Signature";

@interface FBROffersRequest()

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, copy) NSString *apiKey;

@end

@implementation FBROffersRequest

- (instancetype)initWithParams:(NSDictionary *)params
                        apiKey:(NSString *)apiKey {
    self = [super init];
    
    if (self){
        _params = [params mutableCopy];
        _apiKey = [apiKey copy];
    }
    
    return self;
}

+ (instancetype)requestForParams:(NSDictionary *)params
                          apiKey:(NSString *)apiKey {
    return [[[self class] alloc] initWithParams:params
                                     apiKey:apiKey];
}

- (void)startWithSuccess:(FBROffersSuccess)success
                 failure:(FBRFailure)failure{
#if defined(DEBUG)
    NSString *appId = self.params[kFBRFyberOfferParameterAppId];
    NSString *uID = self.params[kFBRFyberOfferParameterUID];
    NSString *locale = self.params[kFBRFyberOfferParameterLocale];
    NSString *oSVersion = self.params[kFBRFyberOfferParameterOSVersion];
    NSString *timestamp = self.params[kFBRFyberOfferParameterTimestamp];
    NSString *appleIdfa = self.params[kFBRFyberOfferParameterAppleIdfa];
    NSString *appleIdfaTrackingEnabled = self.params[kFBRFyberOfferParameterAppleIdfaTrackingEnabled];
    
    NSAssert(appId, @"No appId provided");
    NSAssert(uID, @"No uID provided");
    NSAssert(locale, @"No locale provided");
    NSAssert(oSVersion, @"No oSVersion provided");
    NSAssert(timestamp, @"No timestamp provided");
    NSAssert(appleIdfa, @"No appleIdfa provided");
    NSAssert(appleIdfaTrackingEnabled, @"No appleIdfaTrackingEnabled provided");
#endif
    
    NSString *urlString = [self urlForParams:self.params];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [self getRequestForUrl:url];
    
    NSURLSessionDataTask *task = [self taskForRequest:request
                                           completion:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
        if (error != nil) {
            
            failure(error);
            
            return;
        }
        
        NSString *string = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSDictionary *headers = ((NSHTTPURLResponse *)response).allHeaderFields;
            
            BOOL signatureMatches = [self checkSignatureForResponseHeaders:headers
                                                                   content:string];
            
            if (!signatureMatches) {
                
                failure([NSError errorWithDomain:NSStringFromClass([self class])
                                            code:-1000
                                        userInfo:@{NSLocalizedDescriptionKey: @"Signature missmatch"}]);
                
                return;
            }
        }
        
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                    error:&error];
        
        if (error != nil) {
            
            failure(error);
            
            return;
        }
        
        success(json);
    }];
    
    [task resume];
}

- (NSString *)urlForParams:(NSDictionary *)params{
    return [FBRLinkGenerator fyberLinkForParams:params
                                         apiKey:self.apiKey];
}

- (BOOL)checkSignatureForResponseHeaders:(NSDictionary *)responseHeaders
                                 content:(NSString *)responseString{
    
    NSString *responseSignature = responseHeaders[kSignatureHTTPHeaderField];
    
    NSString *contentoHash = [responseString stringByAppendingString:self.apiKey];
    
    NSString *responseHash = [contentoHash sha1];
    
    BOOL signatureMatches = [responseSignature isEqualToString:responseHash];
    
    return signatureMatches;
}

#pragma mark - Network Helpers

- (NSURLSessionDataTask *)taskForRequest:(NSMutableURLRequest *)request
                              completion:(BackendCompletion)completion {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data,
                                                                NSURLResponse *response,
                                                                NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data, response, error);
        });
    }];
    
    return task;
}

- (NSMutableURLRequest *)getRequestForUrl:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    return request;
}

@end
