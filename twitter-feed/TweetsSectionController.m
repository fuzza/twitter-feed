//
//  TweetsSectionController.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "TweetsSectionController.h"
#import "TweetCell.h"
#import "Tweet.h"

@interface TweetsSectionController ()

@property (nonatomic, strong) Tweet *tweet;

@end

@implementation TweetsSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.collectionContext reloadInSectionController:self atIndexes:[NSIndexSet indexSetWithIndex:0]];
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 44.f);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    TweetCell *cell = [self.collectionContext dequeueReusableCellOfClass:[TweetCell class]
                                                    forSectionController:self
                                                                 atIndex:index];
    [cell updateWithTweet:self.tweet];
    return cell;
}

- (void)didUpdateToObject:(Tweet *)object {
    self.tweet = object;
}

@end
