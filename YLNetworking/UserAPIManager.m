//
//  NewsAPIManager.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserAPIManager.h"
#import <Mantle/Mantle.h>

NSString * const kUserAPIManagerParamsKeySearchKeywords = @"kUserAPIManagerParamsKeySearchKeywords";
@interface UserAPIManager ()
@end

@implementation UserAPIManager
#pragma mark - life cycle

#pragma mark - YLAPIManager
- (NSString *)path {
    return @"user";
}

- (NSString *)apiVersion {
    return @"v2";
}

- (BOOL)isAuth {
    return NO;
}

- (BOOL)isRequestUsingJSON {
    return NO;
}

- (BOOL)shouldCache {
    return YES;
}
- (YLRequestType)requestType {
    return YLRequestTypeGet;
}
- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"q"] = params[kUserAPIManagerParamsKeySearchKeywords];
    resultParams[@"start"] = @(self.currentPage * self.pageSize);
    resultParams[@"count"] = @(self.pageSize);
    return resultParams;
}

- (id)fetchDataFromModel:(Class)clazz {
    return [MTLJSONAdapter modelsOfClass:clazz
                           fromJSONArray:[super fetchData][@"users"]
                                   error:nil];
}

#pragma mark -
- (NSInteger)currentPageSize {
    if([super fetchData]) {
       return [[super fetchData][@"users"] count];
    }
    return kPageSizeNotFound;
}

@end
