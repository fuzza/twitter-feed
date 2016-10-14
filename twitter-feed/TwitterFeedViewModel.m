//
//  TwitterFeedViewModel.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "TwitterFeedViewModel.h"
#import "TweetsService.h"
#import "Tweet.h"

@interface TwitterFeedViewModel ()

@property (nonatomic, strong)  TweetsService *tweetsService;
@property (nonatomic, readwrite) NSArray <Tweet *> *tweets;
@property (nonatomic, readwrite) RACCommand *loadTweets;

@end

@implementation TwitterFeedViewModel

- (instancetype)initWithTweetsService:(TweetsService *)tweetsService {
    self = [super init];
    if(self) {
        self.tweetsService = tweetsService;
        self.tweets = @[];
        [self setupCommands];
    }
    return self;
}

- (void)setupCommands {
    @weakify(self);
    self.loadTweets = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loadNextPage];
    }];
}

- (RACSignal *)loadNextPage {
    @weakify(self);
    return [[self.tweetsService loadTweetsForUser:@"objcio"
                                        beforeUid:self.tweets.lastObject.uid
                                            count:20] doNext:^(NSArray *tweets) {
        @strongify(self);
        self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
    }];
}

@end
