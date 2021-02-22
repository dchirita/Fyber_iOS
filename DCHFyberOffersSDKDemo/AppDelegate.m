//
//  AppDelegate.m
//  DCHFyberOffersSDKDemo
//
//  Created by Daniel on 20/02/2021.
//

#import "AppDelegate.h"

#import "MainFlowHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[MainFlowHandler shared] application:application
                   didFinishLaunchingWithOptions:launchOptions];
}

@end
