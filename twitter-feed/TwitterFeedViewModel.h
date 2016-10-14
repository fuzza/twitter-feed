//
//  TwitterFeedViewModel.h
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;
@class TweetsService;

@interface TwitterFeedViewModel : NSObject

- (instancetype)initWithTweetsService:(TweetsService *)tweetsService;

@property (nonatomic, readonly) NSArray <Tweet *> *tweets;
@property (nonatomic, readonly) RACCommand *loadTweets;

@end
