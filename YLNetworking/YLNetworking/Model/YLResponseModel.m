//
//  YLResponseModel.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLResponseModel.h"
#import "NSURLRequest+YLNetworking.h"
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
                          responseData:(NSData *)responseData
                                status:(YLResponseStatus)status {
    self = [super init];
    if (self) {
        _contentString = responseString;
        _requestId = requestId;
        _responseData = responseData;
        _request = request;
        _requestParams = request.yl_requestParams;
    }
    return self;
}
@end
