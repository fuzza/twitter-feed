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
#import "LoadMoreSectionController.h"

@interface TwitterFeedViewController () <IGListAdapterDataSource, IGListAdapterDelegate>

@property (nonatomic, strong) TwitterFeedViewModel *viewModel;
@property (nonatomic, strong) IGListCollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *listAdapter;

@property (nonatomic, assign) BOOL loading;

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
    [self setupListAdapter];
    [self setupObserving];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[IGListCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupListAdapter {
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    self.listAdapter = [[IGListAdapter alloc] initWithUpdater:updater
                                               viewController:self
                                             workingRangeSize:0];
    self.listAdapter.collectionView = self.collectionView;
    self.listAdapter.dataSource = self;
    self.listAdapter.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.loadTweets execute:nil];
}

- (void)setupObserving {
    [self rac_liftSelector:@selector(tweetsDidUpdate:)
      withSignalsFromArray:@[[RACObserve(self.viewModel, tweets) deliverOnMainThread]]];
    RAC(self, loading) = self.viewModel.loadTweets.executing;
}

- (void)tweetsDidUpdate:(NSArray <Tweet *> *)tweets{
    [self.listAdapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    if(self.loading) {
        return [(NSArray *)self.viewModel.tweets arrayByAddingObject:[LoadMoreToken new]];
    }
    return self.viewModel.tweets;
}

- (IGListSectionController<IGListSectionType> *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if([object isKindOfClass:[LoadMoreToken class]]) {
        return [[LoadMoreSectionController alloc] init];
    }
    return [[TweetsSectionController alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - IGListAdapterDelegate

- (void)listAdapter:(IGListAdapter *)listAdapter willDisplayObject:(id)object atIndex:(NSInteger)index {
    if([object isKindOfClass:[Tweet class]] && index == self.listAdapter.objects.count - 2) {
        [self.viewModel.loadTweets execute:nil];
    }
}


- (void)listAdapter:(IGListAdapter *)listAdapter didEndDisplayingObject:(id)object atIndex:(NSInteger)index {
    // Do nothing
}

@end
