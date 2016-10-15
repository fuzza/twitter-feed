//
//  LoadMoreSectionController.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/15/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "LoadMoreSectionController.h"
#import "LoadMoreCell.h"

@implementation LoadMoreToken
@end

@implementation LoadMoreSectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    // Do nothing
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 44.f);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LoadMoreCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LoadMoreCell class]
                                                       forSectionController:self
                                                                    atIndex:index];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    // Do nothing
}

@end
