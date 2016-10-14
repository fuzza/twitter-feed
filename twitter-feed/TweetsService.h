//
//  TweetsService.h
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetsService : NSObject

- (RACSignal *)loadTweetsForUser:(NSString *)user
                       beforeUid:(NSString *)tweetUid
                           count:(NSUInteger)count;

@end
