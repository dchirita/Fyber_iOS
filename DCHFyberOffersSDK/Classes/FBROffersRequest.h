//
//  FBOffersRequest.h
//  Pods
//
//  Created by Daniel on 04/10/15.
//
//

#import <Foundation/Foundation.h>
#import "FBRGenericBlocks.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBROffersRequest : NSObject

+ (instancetype)requestForParams:(NSDictionary *)params
                          apiKey:(NSString *)apiKey;

- (void)startWithSuccess:(FBROffersSuccess)success
                 failure:(FBRFailure)failure;

@end

NS_ASSUME_NONNULL_END
