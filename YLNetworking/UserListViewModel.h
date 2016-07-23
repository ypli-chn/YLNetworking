//
//  UserListViewModel.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
#import "UserItemViewModel.h"

@interface UserListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, readonly) BOOL hasNextPage;
@property (nonatomic, copy) NSArray<UserItemViewModel *> *newsViewModels;
@end
