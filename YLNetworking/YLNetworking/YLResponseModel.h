//
//  YLResponseModel.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLNetworkingConfiguration.h"

#define YLResponseError(MSG,CODE,ID) [YLResponseError errorWithMessage:MSG code:CODE requestId:ID]

@interface YLResponseError : NSError
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSString *message;

- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId;

+ (YLResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId;
@end

@interface YLResponseModel : NSObject
@property (nonatomic, assign, readonly) YLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;

@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSInteger)requestId
                               request:(NSURLRequest *)request
                          responseData:(NSData *)responseData
                                status:(YLResponseStatus)status;
@end
