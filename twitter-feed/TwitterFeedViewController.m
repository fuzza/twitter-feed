//
//  ViewController.m
//  twitter-feed
//
//  Created by Alex Faizullov on 10/14/16.
//  Copyright © 2016 Alex Faizullov. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "TwitterFeedViewModel.h"
#import "TweetsSectionController.h"
#import "TweetsSectionController.h"

@interface TwitterFeedViewController () <IGListAdapterDataSource>

@property (nonatomic, strong) TwitterFeedViewModel *viewModel;
@property (nonatomic, strong) IGListCollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *listAdapter;

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
    
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    self.listAdapter = [[IGListAdapter alloc] initWithUpdater:updater
                                                     viewController:self
                                                   workingRangeSize:0];
    self.listAdapter.collectionView = self.collectionView;
    self.listAdapter.dataSource = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.loadTweets execute:nil];
}

- (void)setupObserving {
    [self rac_liftSelector:@selector(tweetsDidUpdate:)
      withSignalsFromArray:@[[RACObserve(self.viewModel, tweets) deliverOnMainThread]]];
}

- (void)tweetsDidUpdate:(NSArray <Tweet *> *)tweets{
    [self.listAdapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.viewModel.tweets;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[TweetsSectionController alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
