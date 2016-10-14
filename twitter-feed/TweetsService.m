//
//  TweetsService.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/SLRequest.h>
#import "TweetsService.h"
#import "Tweet.h"

@implementation TweetsService

- (RACSignal *)loadTweetsForUser:(NSString *)user
                       beforeUid:(NSString *)tweetUid
                           count:(NSUInteger)count {
    @weakify(self);
    return [[[self authorize] flattenMap:^RACStream *(ACAccount *twitterAccount) {
        @strongify(self);
        return [self requestTimelineWithAccount:twitterAccount
                                        forUser:user
                                      beforeUid:tweetUid
                                          count:count];
    }]  flattenMap:^RACStream *(NSArray *responseArray) {
        @strongify(self);
        return [self mapResponseData:responseArray];
    }];
}

- (RACSignal *)authorize {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        
        void(^completion)(id<RACSubscriber>) = ^(id<RACSubscriber> subscriber){
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            if (arrayOfAccounts.count > 0) {
                ACAccount *twitterAccount = arrayOfAccounts.lastObject;
                [subscriber sendNext:twitterAccount];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError errorWithDomain:NSStringFromClass([self class])
                                                          code:401
                                                      userInfo:nil]];
            }
        };
        
        if(accountType.accessGranted) {
            completion(subscriber);
        } else {
            [accountStore requestAccessToAccountsWithType:accountType
                                                  options:nil
                                               completion:^(BOOL granted, NSError *error) {
                                                   if(granted) {
                                                       completion(subscriber);
                                                   } else {
                                                       [subscriber sendError:error];
                                                   }
                                               }];
        }
        return nil;
    }];
}

- (RACSignal *)requestTimelineWithAccount:(ACAccount *)twitterAccount
                                  forUser:(NSString *)user
                                beforeUid:(NSString *)tweetId
                                    count:(NSUInteger)count {
    NSParameterAssert(twitterAccount);
    NSParameterAssert(user);
    NSAssert(count > 0, @"Tweets count should be greater than zero");
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
        NSMutableDictionary *parameters = [@{
                                             @"screen_name" : user,
                                             @"count" : @(count).stringValue
                                             } mutableCopy];
        
        if(tweetId) {
            parameters[@"max_id"] = tweetId;
        }
        
        SLRequest *getFeedRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestURL parameters:parameters];
        getFeedRequest.account = twitterAccount;
        
        [getFeedRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            if(!error) {
                NSError *deserializationError = nil;
                NSArray *JSON = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error:&deserializationError];
                if(!deserializationError) {
                    [subscriber sendNext:JSON];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:error];
                }
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)mapResponseData:(NSArray *)responseArray {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *mappingError = nil;
        NSArray *tweets = [MTLJSONAdapter modelsOfClass:[Tweet class]
                                          fromJSONArray:responseArray
                                                  error:&mappingError];
        if(!mappingError) {
            [subscriber sendNext:tweets];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:mappingError];
        }
        return nil;
    }];
}

@end
