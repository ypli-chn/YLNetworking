//
//  YLResponseModel.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLResponseModel.h"
#import "NSURLRequest+YLNetworking.h"
#import "YLAuthParamsGenerator.h"

NSString * const YLNetworkingResponseErrorKey = @"xyz.ypli.error.responsee";
@implementation YLResponseError
@dynamic message;
- (instancetype)initWithMessage:(NSString *)message
                           code:(NSInteger)code
                      requestId:(NSInteger)requestId {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message
                                                         forKey:NSLocalizedDescriptionKey];
    self = [super initWithDomain:YLNetworkingResponseErrorKey code:code userInfo:userInfo];
    if (self) {
        _requestId = requestId;
    }
    return self;
}


+ (YLResponseError *)errorWithMessage:(NSString *)message
                                 code:(NSInteger)code
                            requestId:(NSInteger)requestId {
    return [[self alloc] initWithMessage:message code:code requestId:requestId];
}
#pragma mark -
- (NSString *)message {
    return [self localizedDescription];
}
#pragma mark -
- (NSString *)description {
    return [NSString stringWithFormat:@"[%lu]code:%lu, message:%@",self.requestId,self.code,self.message];
}
@end

@implementation YLResponseModel
- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSInteger)requestId
                               request:(NSURLRequest *)request
                              response:(NSURLResponse *)response
                          responseData:(NSData *)responseData
                                status:(YLResponseStatus)status {
    self = [super init];
    if (self) {
        _contentString = responseString;
        _requestId = requestId;
        _response = response;
        _responseData = responseData;
        _request = request;
        _requestParams = request.yl_requestParams;
        _isCache = NO;
    }
    return self;
}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _requestId = 0;
        _request = nil;
        _responseData = [data copy];
        _requestParams = nil;
        _isCache = YES;
    }
    return self;
}

- (NSDictionary *)requestParamsExceptToken {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.requestParams];
    NSArray<NSString *> *keys = [YLAuthParamsGenerator authParams].allKeys;
    // 这里保留UserId以防止不同用户的脏数据
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:kYLAuthParamsKeyUserId]) {
            [dict removeObjectForKey:obj];
        }
    }];
    return [dict copy];
}
@end
