//
//  FBRLinkGenerator.h
//  Pods
//
//  Created by Daniel on 06/10/15.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBRLinkGenerator : NSObject

+ (NSString *)fyberLinkForParams:(NSDictionary *)params
                          apiKey:(NSString *)apiKey;
@end

NS_ASSUME_NONNULL_END
