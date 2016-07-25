//
//  UserListViewController.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserListViewController.h"
#import "UserItemViewCell.h"
#import "MJRefresh.h"


@interface UserListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UserListViewModel * viewModel;
@end

@implementation UserListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    RAC(self.viewModel,keywords) = self.searchTextField.rac_textSignal;
    
    self.operationButton.rac_command = self.viewModel.networkingRAC.refreshCommand;

    [[[RACObserve(self.viewModel, userItemViewModels) skip:1]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self.tableView.header endRefreshing];
         if (self.viewModel.hasNextPage) {
             [self.tableView.footer endRefreshing];
         } else {
             [self.tableView.footer endRefreshingWithNoMoreData];
         }
     }];

    [self.viewModel.networkingRAC.requestErrorSignal
     subscribeNext:^(NSError *error) {
         @strongify(self);
         self.title = error.localizedDescription;
         [self.tableView.header endRefreshing];
         [self.tableView.footer endRefreshing];
    }];
    
    [self setupTableView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel.networkingRAC.cancelCommand execute:nil];
}

- (void)setupTableView {
    UINib *userNib = [UINib nibWithNibName:@"UserItemViewCell" bundle:nil];
    [self.tableView registerNib:userNib forCellReuseIdentifier:UserItemViewCellIdentifier];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingCommand:self.viewModel.networkingRAC.refreshCommand];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingCommand:self.viewModel.networkingRAC.requestNextPageCommand];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserItemViewCellIdentifier
                                                            forIndexPath:indexPath];
    cell.viewModel = self.viewModel.userItemViewModels[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.userItemViewModels count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UserItemViewCellHeight;
}


#pragma mark - getter && setter
- (UserListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[UserListViewModel alloc] init];
    }
    return _viewModel;
}




@end
