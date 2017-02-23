//
//  YLNetworking+ReactiveExtension.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLNetworking+ReactiveExtension.h"
#import "Foundation+YLNetworking.h"
#import <objc/runtime.h>

@interface YLBaseAPIManager (_ReactiveExtension)
// For RACCommand, allowsConcurrentExecution is NO by default. That is to say, there's only one request. So here I record the request of requestId.
@property (nonatomic, assign) NSInteger requestId;
@end

@implementation YLBaseAPIManager (_ReactiveExtension)
- (void)setRequestId:(NSInteger)requestId {
    objc_setAssociatedObject(self, @selector(requestId), @(requestId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)requestId {
    return [objc_getAssociatedObject(self, @selector(requestId)) integerValue];
}
@end

@implementation YLBaseAPIManager (ReactiveExtension)

- (RACSignal *)requestSignal {
    @weakify(self);
    RACSignal *requestSignal =
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        RACSignal *successSignal = [self rac_signalForSelector:@selector(afterPerformSuccessWithResponseModel:)];
        [[successSignal map:^id(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(id x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
        }];
        
        RACSignal *failSignal = [self rac_signalForSelector:@selector(afterPerformFailWithResponseError:)];
        [[failSignal map:^id(RACTuple *tuple) {
            return tuple.first;
        }] subscribeNext:^(id x) {
            NSLog(@"请求失败 %@",x);
            [subscriber sendError:x];
        }];
        return nil;
    }] replayLazily] takeUntil:self.rac_willDeallocSignal];
    return requestSignal;
}

- (RACCommand *)requestCommand {
    RACCommand *requestCommand = objc_getAssociatedObject(self, @selector(requestCommand));
    if (requestCommand == nil) {
        @weakify(self);
        requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            if ([input respondsToSelector:@selector(boolValue)] && [input boolValue]) {
                self.requestId = [self loadDataWithoutCache];
            } else {
                self.requestId = [self loadData];
            }
            return [self.requestSignal takeUntil:self.cancelCommand.executionSignals];
        }];
        objc_setAssociatedObject(self, @selector(requestCommand), requestCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requestCommand;
}

- (RACCommand *)cancelCommand {
    RACCommand *cancelCommand = objc_getAssociatedObject(self, @selector(cancelCommand));
    if (cancelCommand == nil) {
        @weakify(self);
        cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self cancelRequestWithRequestId:self.requestId];
            NSLog(@"cancelCommand 取消请求:%lu",self.requestId);
            return [RACSignal empty];
        }];
        objc_setAssociatedObject(self, @selector(cancelCommand), cancelCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cancelCommand;
}

- (RACSignal *)requestErrorSignal {
    return [self.requestCommand.errors subscribeOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)executionSignal {
    return [self.requestCommand.executionSignals switchToLatest];
}

@end
@implementation YLPageAPIManager (ReactiveExtension)
- (RACCommand *)requestCommand {
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ requestCommand error",[self class]]
                                   reason:@"Don't call this Method. Call  refreshCommand or requestNextPageCommand instead."
                                 userInfo:nil];
}

- (RACCommand *)refreshCommand {
    RACCommand *refreshCommand = objc_getAssociatedObject(self, @selector(refreshCommand));
    if (refreshCommand == nil) {
        @weakify(self);
        refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self reset];
            NSInteger requestId;
            if ([input respondsToSelector:@selector(boolValue)] && [input boolValue]) {
                requestId = [self loadNextPageWithoutCache];
            } else {
                requestId = [self loadNextPage];
            }
            
            if (requestId != kPageIsLoading) {
                self.requestId = requestId;
            }
            NSLog(@"[refreshCommand] 发出请求:%lu",requestId);
            return self.requestSignal;
        }];
        objc_setAssociatedObject(self, @selector(refreshCommand), refreshCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return refreshCommand;
}


- (RACCommand *)requestNextPageCommand {
    RACCommand *requestNextPageCommand = objc_getAssociatedObject(self, @selector(requestNextPageCommand));
    if (requestNextPageCommand == nil) {
        @weakify(self);
        requestNextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            NSInteger requestId = [self loadNextPage];
            if (requestId != kPageIsLoading) {
                self.requestId = requestId;
            }
            NSLog(@"[requestNextPageCommand] 发出请求:%lu",requestId);
            return self.requestSignal;
        }];
        objc_setAssociatedObject(self, @selector(requestNextPageCommand), requestNextPageCommand, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requestNextPageCommand;
}

- (RACSignal *)requestErrorSignal {
    return [[RACSignal merge:@[self.refreshCommand.errors, self.requestNextPageCommand.errors]]
            subscribeOn:[RACScheduler mainThreadScheduler]];
}

- (RACSignal *)executionSignal {
    RACSignal *refreshExecutionSignal =
    [[self.refreshCommand.executionSignals switchToLatest] map:^id(id value) {
        return @(YES);
    }];
    
    RACSignal *requestNextPageExecutionSignal =
    [[self.requestNextPageCommand.executionSignals switchToLatest] map:^id(id value) {
        return @(NO);
    }];
    return [RACSignal merge:@[refreshExecutionSignal, requestNextPageExecutionSignal]];
}
@end



@interface RACCommand (_YLExtension)

@end
@implementation RACCommand (YLExtension)
+ (void)load {
    [NSObject yl_methodSwizzlingWithTarget:@selector(execute:)
                                     using:@selector(yl_execute:)
                                  forClass:[RACCommand class]];
}

- (RACSignal *)yl_execute:(id)input {
    self.yl_timestamp = [NSDate timeIntervalSinceReferenceDate];
    return [self yl_execute:input];
}

- (NSTimeInterval)yl_timestamp {
    return [objc_getAssociatedObject(self, @selector(yl_timestamp)) doubleValue];
}

- (void)yl_setTimestamp:(NSTimeInterval)timestamp {
    objc_setAssociatedObject(self, @selector(yl_timestamp), @(timestamp), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)tryExecuteIntervalLongerThan:(NSInteger)seconds {
    BOOL result = NO;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if (now - self.yl_timestamp > seconds) {
        result = YES;
        [self execute:nil];
        
    }
    return result;
}
@end


