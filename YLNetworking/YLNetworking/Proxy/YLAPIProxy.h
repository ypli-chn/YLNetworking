//
//  YLAPIProxy.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLResponseModel.h"

/*
 * The purpose of this file is to facilitate the replacement of AFNetworking
 */

typedef void(^YLAPIProxySuccess)(YLResponseModel *response);
typedef void(^YLAPIProxyFail)(YLResponseError *error);

@interface YLAPIProxy : NSObject
+ (instancetype)sharedInstance;

- (BOOL)isReachable;

- (NSInteger)loadGETWithParams:(NSDictionary *)params
                       useJSON:(BOOL)useJSON
                          host:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version
                       success:(YLAPIProxySuccess)success
                          fail:(YLAPIProxyFail)fail;

- (NSInteger)loadPOSTWithParams:(NSDictionary *)params
                        useJSON:(BOOL)useJSON
                           host:(NSString *)host
                           path:(NSString *)path
                     apiVersion:(NSString *)version
                        success:(YLAPIProxySuccess)success
                           fail:(YLAPIProxyFail)fail;

- (NSNumber *)loadRequest:(NSURLRequest *)request
                  success:(YLAPIProxySuccess)success
                     fail:(YLAPIProxyFail)fail;

- (void)cancelRequestWithRequestId:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIdList:(NSArray *)requestIdList;
@end

@class YLBaseAPIManager;
@protocol YLAPIManager;
@interface YLAPIProxy (YLRequestGenerator)
+ (NSURLRequest *)requestWithParams:(NSDictionary *)params
                            useJSON:(BOOL)useJSON
                             method:(NSString *)method
                               host:(NSString *)host
                               path:(NSString *)path
                         apiVersion:(NSString *)version;
@end
