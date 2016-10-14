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
             @"text" : @"text"
             };
}

- (id<NSObject>)diffIdentifier {
    return self.uid;
}

@end
