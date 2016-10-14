//
//  TweetCell.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"

@interface TweetCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation TweetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self setupTextLabel];
    [self setupSeparator];
}

- (void)setupTextLabel {
    self.textLabel = [UILabel new];
    [self.contentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(5, 5, 6, 5));
    }];
}

- (void)setupSeparator {
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1);
    }];
}

- (void)updateWithTweet:(Tweet *)tweet {
    self.textLabel.text = tweet.text;
}

@end
