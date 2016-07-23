//
//  UserListViewModel.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserListViewModel.h"
#import "UserAPIManager.h"
@interface UserListViewModel()<YLAPIManagerDataSource>
@property (nonatomic, strong) UserAPIManager *userAPIManager;
@property (nonatomic, strong) UserAPIManager *newsAPIManager;
@end
@implementation UserListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            self.newsViewModels = nil;
        }
        NSMutableArray *newsViewModels = [NSMutableArray arrayWithArray:self.newsViewModels];
        NSArray *newsModels = [self.userAPIManager fetchDataFromModel];
        RACSequence *newsViewModelSeq = [newsModels.rac_sequence map:^id(UserItemModel *model) {
            return [[UserItemViewModel alloc] initWithModel:model];
        }];
        [newsViewModels addObjectsFromArray:newsViewModelSeq.array];
        self.newsViewModels = newsViewModels;
    }];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.userAPIManager) {
        params = @{
                   kUserAPIManagerParamsKeySearchKeywords:self.keywords?:@"",
                   };
    }
    return params;
}

#pragma mark - getter && setter
- (UserAPIManager *)userAPIManager {
    if (_userAPIManager == nil) {
        _userAPIManager = [[UserAPIManager alloc] initWithPageSize:20];
        _userAPIManager.dataSource = self;
    }
    return _userAPIManager;
}

- (BOOL)hasNextPage {
    return self.userAPIManager.hasNextPage;
}

- (id<YLNetworkingListRACOperationProtocol>)networkingRAC {
    return self.userAPIManager;
}

@end
