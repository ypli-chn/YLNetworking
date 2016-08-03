//
//  MJRefresh+ReactiveExtension.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MJRefresh+ReactiveExtension.h"

@implementation MJRefreshHeader (ReactiveExtension)
+ (instancetype)headerWithRefreshingCommand:(RACCommand *)refreshingCommand {
    @weakify(refreshingCommand);
    return [self headerWithRefreshingBlock:^{
        @strongify(refreshingCommand);
        [refreshingCommand execute:nil];
    }];
}

@end


@implementation MJRefreshFooter(ReactiveExtension)
+ (instancetype)footerWithRefreshingCommand:(RACCommand *)refreshingCommand {
    @weakify(refreshingCommand);
    return [self footerWithRefreshingBlock:^{
        @strongify(refreshingCommand);
        [refreshingCommand execute:nil];
    }];
}

@end