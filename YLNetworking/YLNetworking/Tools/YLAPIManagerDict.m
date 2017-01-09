//
//  YLAPIManagerDict.m
//  YLNetworking
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAPIManagerDict.h"
#import <libkern/OSAtomic.h>
#import "YLPageAPIManager.h"
@interface YLAPIManagerDict() {
    OSSpinLock _lock;
}
@property (nonatomic, strong) NSMutableDictionary *apiManagers;
@end

@implementation YLAPIManagerDict
- (instancetype)init {
    self = [super init];
    if (self) {
        _apiManagers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    OSSpinLockLock(&_lock);
    YLBaseAPIManager *apiManager = self.apiManagers[@(idx)];
    OSSpinLockUnlock(&_lock);
    return apiManager;
}
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    OSSpinLockLock(&_lock);
    self.apiManagers[@(idx)] = obj;
    OSSpinLockUnlock(&_lock);
}

@end
