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
@property (nonatomic, strong) NSDictionary *response;

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
@property (nonatomic, copy, readonly) NSURLResponse *response;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSInteger)requestId
                               request:(NSURLRequest *)request
                              response:(NSURLResponse *)response
                          responseData:(NSData *)responseData
                                status:(YLResponseStatus)status;

- (NSDictionary *)requestParamsExceptToken;
@end
