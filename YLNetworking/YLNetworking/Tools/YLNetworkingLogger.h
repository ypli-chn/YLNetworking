//
//  YLNetworkingLogger.h
//  YLNetworking
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLNetworkingLogger : NSObject
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                           path:(NSString *)path
                         isJSON:(BOOL)isJSON
                         params:(id)requestParams
                    requestType:(NSString *)type;

+ (void)logResponseWithRequest:(NSURLRequest *)request
                          path:(NSString *)path
                        params:(id)requestParams
                      response:(NSString *)response;
+ (void)logInfo:(NSString *)msg;
+ (void)logInfo:(NSString *)msg label:(NSString *)label;
+ (void)logError:(NSString *)msg;
@end
