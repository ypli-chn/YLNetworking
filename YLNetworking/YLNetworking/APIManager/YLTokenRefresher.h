//
//  YLTokenRefresher.h
//  YLNetworking
//
//  Created by Yunpeng on 16/8/28.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"

@interface YLTokenRefresher : YLBaseAPIManager<YLAPIManager>

- (void)needRefresh;


+ (instancetype)sharedInstance;
@end
