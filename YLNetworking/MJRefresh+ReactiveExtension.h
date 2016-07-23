//
//  MJRefresh+ReactiveExtension.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MJRefresh.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface MJRefreshHeader (ReactiveExtension)
+ (instancetype)headerWithRefreshingCommand:(RACCommand *)refreshingCommand;

@end

@interface MJRefreshFooter(ReactiveExtension)
+ (instancetype)footerWithRefreshingCommand:(RACCommand *)refreshingCommand;
@end