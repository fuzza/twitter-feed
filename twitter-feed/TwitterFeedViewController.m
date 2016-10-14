//
//  ViewController.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "TwitterFeedViewModel.h"

@interface TwitterFeedViewController ()

@property (nonatomic, strong) TwitterFeedViewModel *viewModel;
@property (nonatomic, strong) IGListCollectionView *collectionView;

@end

@implementation TwitterFeedViewController

- (instancetype)initWithViewModel:(TwitterFeedViewModel *)viewModel {
    self = [super init];
    if(self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupObserving];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.loadTweets execute:nil];
    
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.viewModel.loadTweets execute:nil];
    });
}

- (void)setupObserving {
    [[RACObserve(self.viewModel, tweets) map:^id(NSArray *tweets) {
        return @(tweets.count);
    }] subscribeNext:^(NSNumber *count) {
        NSLog(@"Tweets count = %@", count);
    }];
}

@end
