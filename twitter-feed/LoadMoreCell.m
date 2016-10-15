//
//  LoadMoreCell.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/15/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "LoadMoreCell.h"

@interface LoadMoreCell ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation LoadMoreCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:self.spinner];
    
    [self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.height.offset(20);
    }];
    [self.spinner startAnimating];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.spinner startAnimating];
}

@end
