//
//  YLNetworking+ReactiveExtension.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"
#import "YLPageAPIManager.h"
#import "NSMapTable+YLNetworking.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@protocol YLNetworkingRACOperationProtocol;
typedef NSMapTable<NSString *,id<YLNetworkingRACOperationProtocol>> YLNetworkingRACTable;

@protocol YLNetworkingRACOperationProtocol<NSObject>
- (RACCommand *)requestCommand;
- (RACCommand *)cancelCommand;
- (RACSignal *)requestErrorSignal;
- (RACSignal *)executionSignal;
@end

@protocol YLNetworkingListRACOperationProtocol<YLNetworkingRACOperationProtocol>
- (RACCommand *)refreshCommand;
- (RACCommand *)requestNextPageCommand;
@end

@protocol YLNetworkingRACProtocol <NSObject>

@optional
- (id<YLNetworkingRACOperationProtocol>)networkingRAC;
// 定义枚举在这允许获取多个APIManager的RAC
- (YLNetworkingRACTable *)networkingRACs;
@end


@protocol YLNetworkingListRACProtocol <NSObject>
@required
- (id<YLNetworkingListRACOperationProtocol>)networkingRAC;
@end


@interface YLBaseAPIManager (ReactiveExtension)<YLNetworkingRACOperationProtocol>
@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;
@property (nonatomic, strong, readonly) RACSignal *requestErrorSignal; //已为主线程
@property (nonatomic, strong, readonly) RACSignal *executionSignal;

- (RACSignal *)requestSignal;
@end

@interface YLPageAPIManager (ReactiveExtension)<YLNetworkingListRACOperationProtocol>
@property (nonatomic, strong, readonly) RACCommand *refreshCommand;
@property (nonatomic, strong, readonly) RACCommand *requestNextPageCommand;
@end

@interface RACCommand (YLExtension)
@property (nonatomic, assign, setter=yl_setTimestamp:) NSTimeInterval yl_timestamp;
// 尝试execute，但是需要与上次执行的间隔大于seconds才会执行
- (BOOL)tryExecuteIntervalLongerThan:(NSInteger)seconds;
@end
