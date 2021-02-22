//
//  FBRParams.m
//  DCHFyberOffersSDK
//
//  Created by Daniel on 20/02/2021.
//

#import "FBRParams.h"

@implementation FBRParams

- (instancetype)initWithAppId:(NSString *)appId
                       userId:(NSString *)userId
                    offerType:(OfferType)offerType {
    self = [super init];
    
    if (self) {
        _appId = [appId copy];
        _userId = [userId copy];
        _offerType = offerType;
    }
    
    return self;
}
@end
