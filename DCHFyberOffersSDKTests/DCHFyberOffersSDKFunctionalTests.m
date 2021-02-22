//
//  DCHFyberOffersSDKFunctionalTests.m
//  DCHFyberOffersSDKTests
//
//  Created by Daniel on 21/02/2021.
//

#import <XCTest/XCTest.h>

#import <DCHFyberOffersSDK/DCHFyberOffersSDK.h>

@interface DCHFyberOffersSDKFunctionalTests : XCTestCase

@property (nonatomic, strong) FBRFyber *fyber;

@end

NSString * const kFyberAPIKey = @"1c915e3b5d42d05136185030892fbb846c278927";

@implementation DCHFyberOffersSDKFunctionalTests

- (void)setUp {
    self.fyber = [FBRFyber withAPIKey:kFyberAPIKey];
}

- (void)testFetchOffers {
    
    FBRParams *params = [[FBRParams alloc] initWithAppId:@"2070"
                                                  userId:@"superman"
                                               offerType:OfferTypeFree];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Get offers"];
    
    [self.fyber offersForParams:params
                        success:^(NSArray<FBROfferItem *> *offers){
        
        XCTAssertTrue(0 != [offers count], @"Failed to get offers");
        
        [expectation fulfill];
    } failure:^(NSError *error){
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    __unused XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation]
                                                             timeout:3.0];
}

- (void)testWrongUserId {
    
    FBRParams *params = [[FBRParams alloc] initWithAppId:@"2070"
                                                  userId:@"spiderman"
                                               offerType:OfferTypeFree];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Get offers"];
    
    [self.fyber offersForParams:params
                        success:^(NSArray<FBROfferItem *> *offers){
        
        XCTAssertTrue(0 == [offers count], @"Failed to get offers");
        
        [expectation fulfill];
        
    } failure:^(NSError *error){
        NSLog(@"%@", [error localizedDescription]);
    }];
    
    __unused XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation]
                                                             timeout:3.0];
}

- (void)testSignatureMissmatchError {
    
    FBRParams *params = [[FBRParams alloc] initWithAppId:@"1001"
                                                  userId:@"superman"
                                               offerType:OfferTypeFree];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Get offers"];
    
    [self.fyber offersForParams:params
                        success:^(NSArray<FBROfferItem *> *offers){
        
        XCTAssert(NO, @"No success callback should be triggered when signature does not match");
        
    } failure:^(NSError *error){
        
        XCTAssertTrue(error, @"Failed to get offers");
        
        [expectation fulfill];
    }];
    
    __unused XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation]
                                                             timeout:3.0];
}

@end
