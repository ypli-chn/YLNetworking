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
            self.userItemViewModels = nil;
        }
        NSMutableArray *userItemViewModels = [NSMutableArray arrayWithArray:self.userItemViewModels];
        NSArray *userModels = [self.userAPIManager fetchDataFromModel];
        RACSequence *userViewModelSeq = [userModels.rac_sequence map:^id(UserItemModel *model) {
            return [[UserItemViewModel alloc] initWithModel:model];
        }];
        [userItemViewModels addObjectsFromArray:userViewModelSeq.array];
        self.userItemViewModels = userItemViewModels;
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
