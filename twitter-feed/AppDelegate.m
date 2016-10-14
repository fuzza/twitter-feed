//
//  AppDelegate.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterFeedViewController.h"
#import "TwitterFeedViewModel.h"
#import "TweetsService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    TweetsService *tweetsService = [[TweetsService alloc] init];
    TwitterFeedViewModel *viewModel = [[TwitterFeedViewModel alloc] initWithTweetsService:tweetsService];
    TwitterFeedViewController *vc = [[TwitterFeedViewController alloc] initWithViewModel:viewModel];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
