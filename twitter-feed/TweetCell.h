//
//  TweetCell.h
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetCell : UICollectionViewCell

- (void)updateWithTweet:(Tweet *)tweet;

@end
