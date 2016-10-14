//
//  ViewController.h
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterFeedViewModel;

@interface TwitterFeedViewController : UIViewController

- (instancetype)initWithViewModel:(TwitterFeedViewModel *)viewModel;

@end

