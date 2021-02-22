//
//  DCHFyberOffersSDKTests.m
//  DCHFyberOffersSDKTests
//
//  Created by Daniel on 20/02/2021.
//

#import <XCTest/XCTest.h>

#import <DCHFyberOffersSDK/DCHFyberOffersSDK.h>

//--------------------- Exposing private headers ------------------------
@interface NSString (SHA)
- (NSString *)sha1;
@end

@interface FBRLinkGenerator : NSObject
+ (NSString *)fyberLinkForParams:(NSDictionary *)params
                          apiKey:(NSString *)apiKey;
@end
//-----------------------------------------------------------------------

@interface DCHFyberOffersSDKTests : XCTestCase

@end

@implementation DCHFyberOffersSDKTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testOffersModelling {
    
    FBROfferItem *offer = [FBROfferItem offerWithTitle:@"First Offer"
                                               teaser:@"The teaser"
                                         thumbnailUrl:@"http://cdn3.sponsorpay.com/assets/175/win_icon_square_60.png"
                                               payout:100];
    
    XCTAssertTrue([offer.title isEqualToString:@"First Offer"],
                  @"Offer should have title");
    
    XCTAssertTrue([offer.teaser isEqualToString:@"The teaser"],
                  @"Should have teaser");
    
    XCTAssertTrue([offer.thumbnailUrl isEqualToString:@"http://cdn3.sponsorpay.com/assets/175/win_icon_square_60.png"],
                  @"Offer should have thumbnailUrl");
    
    XCTAssertTrue(offer.payout == 100,
                  @"Offer should have correct payout");
}

- (void)testSHA {
    
    NSString *inputString = @"appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&"
    @"ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&"
    @"pub0=campaign2&timestamp=1312553361&"
    @"uid=player1&e95a21621a1865bcbae3bee89c4d4f84";
    
    NSString *sha1 = [inputString sha1];
    
    XCTAssertTrue([sha1 isEqualToString:@"7a2b1604c03d46eec1ecd4a686787b75dd693c4d"], @"SHA1 computation failed");
}

- (void)testFyberURLComputation {
    
    NSDictionary *params = @{@"appid" : @"2070",
                             @"apple_idfa" : @"B5944FC0-268A-4AD2-A0E2-799E75E37287",
                             @"apple_idfa_tracking_enabled" : @"true",
                             @"ip" : @"109.235.143.113",
                             @"locale" : @"DE",
                             @"offer_types" : @"112",
                             @"os_version" : @"8.4",
                             @"timestamp" : @"1444080064",
                             @"uid" : @"spiderman"};
    
    NSString *outputString = [FBRLinkGenerator fyberLinkForParams:params
                                                           apiKey:@"1c915e3b5d42d05136185030892fbb846c278927"];
    
    NSString *correctString = @"http://api.fyber.com/feed/v1/offers.json?appid=2070&"
    @"apple_idfa=B5944FC0-268A-4AD2-A0E2-799E75E37287&"
    @"apple_idfa_tracking_enabled=true&ip=109.235.143.113&"
    @"locale=DE&offer_types=112&os_version=8.4&"
    @"timestamp=1444080064&uid=spiderman&"
    @"hashkey=3dcc6db136d1c523e432fbd86836bb42e784cc6f";
    
    XCTAssertTrue([outputString isEqualToString:correctString], @"String url computation failed");
    
    NSURL *url = [NSURL URLWithString:outputString];
    
    XCTAssertTrue(nil != url, @"String url is an invalid URL");
}

@end
