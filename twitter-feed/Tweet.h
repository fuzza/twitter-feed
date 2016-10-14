//
//  Tweet.h
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Tweet : MTLModel <IGListDiffable, MTLJSONSerializing>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *text;

@end
