//
//  Tweet.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid" : @"id_str",
             @"text" : @"text",
             @"retweetCount" : @"retweet_count",
             @"createdAt" : @"created_at"
             };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    //"Wed May 23 06:01:13 +0000 2007"
    return [MTLValueTransformer transformerUsingForwardBlock:^NSDate *(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"];
        });
        return [dateFormatter dateFromString:dateString];
    }];
}

- (id<NSObject>)diffIdentifier {
    return self.uid;
}




@end
