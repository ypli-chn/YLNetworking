//
//  YLAPIProxy.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAPIProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "YLBaseAPIManager.h"
#import "NSURLRequest+YLNetworking.h"
#import "YLNetworkingLogger.h"
#import "Foundation+YLNetworking.h"

@interface YLAPIProxy()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation YLAPIProxy

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YLAPIProxy *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSInteger)loadGETWithParams:(NSDictionary *)params
                       useJSON:(BOOL)useJSON
                          host:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version
                       success:(YLAPIProxySuccess)success
                          fail:(YLAPIProxyFail)fail {
    NSURLRequest *request = [YLAPIProxy requestWithParams:params
                                                  useJSON:useJSON
                                                   method:@"GET"
                                                     host:host
                                                     path:path
                                               apiVersion:version];
    
    NSNumber *requestId = [self loadRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)loadPOSTWithParams:(NSDictionary *)params
                        useJSON:(BOOL)useJSON
                           host:(NSString *)host
                           path:(NSString *)path
                     apiVersion:(NSString *)version
                        success:(YLAPIProxySuccess)success
                           fail:(YLAPIProxyFail)fail {
    NSURLRequest *request = [YLAPIProxy requestWithParams:params
                                                  useJSON:useJSON
                                                   method:@"POST"
                                                     host:host
                                                     path:path
                                               apiVersion:version];
    NSNumber *requestId = [self loadRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    if (requestId == nil) return;
    NSURLSessionDataTask *requestTask = self.dispatchTable[requestId];
    [requestTask cancel];
    [self.dispatchTable removeObjectForKey:requestId];
}

- (void)cancelRequestWithRequestIdList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestId:requestId];
    }
}


- (NSNumber *)loadRequest:(NSURLRequest *)request
                  success:(YLAPIProxySuccess)success
                     fail:(YLAPIProxyFail)fail {
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [self.sessionManager dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          NSNumber *requestID = @([dataTask taskIdentifier]);
                                          [self.dispatchTable removeObjectForKey:requestID];
                                          NSData *responseData = nil;
                                          if ([responseObject isKindOfClass:[NSData class]]) {
                                              responseData = responseObject;
                                          }
                                          if (error) {
                                              [YLNetworkingLogger logError:error.description];
                                              if (error.code == NSURLErrorCancelled) {
                                                  // 若取消则不发送任何消息
                                                  fail?fail(YLResponseError(@"取消访问",YLResponseStatusCancel,[requestID integerValue])):nil;
                                              } else if (error.code == NSURLErrorTimedOut) {
                                                  fail?fail(YLResponseError(@"网络超时",YLResponseStatusErrorTimeout,[requestID integerValue])):nil;
                                              } else {
                                                  fail?fail(YLResponseError(@"网络错误",YLResponseStatusErrorUnknown,[requestID integerValue])):nil;
                                              }
                                          } else {
                                              NSString *responseString = nil;
                                              if (responseData != nil) {
                                                  responseString = [[NSString alloc] initWithData:responseData
                                                                                         encoding:NSUTF8StringEncoding];;
                                              }
                                              [YLNetworkingLogger logResponseWithRequest:request path:request.URL.absoluteString params:request.yl_requestParams response:responseString];
                                              
                                              YLResponseModel *responseModel =
                                              [[YLResponseModel alloc] initWithResponseString:responseString
                                                                                    requestId:[requestID integerValue]
                                                                                      request:request
                                                                                     response:response
                                                                                 responseData:responseData
                                                                                       status:YLResponseStatusSuccess];
                                              success?success(responseModel):nil;
                                          }
                                      }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return requestId;
}

- (BOOL)isReachable {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

#pragma mark - Getter

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        //        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}
@end

@implementation YLAPIProxy (YLRequestGenerator)
+ (NSURLRequest *)requestWithParams:(NSDictionary *)params
                            useJSON:(BOOL)useJSON
                             method:(NSString *)method
                               host:(NSString *)host
                               path:(NSString *)path
                         apiVersion:(NSString *)version {
    NSString *urlString = [NSString yl_urlStringForHost:host path:path apiVersion:version];
    NSError *error = nil;
    if (![method isEqualToString:@"GET"]
        && ![method isEqualToString:@"POST"]) {
        [YLNetworkingLogger logError:@"[YLAPIProxy]未知请求方法"];
        return nil;
    }
    
    AFHTTPRequestSerializer *serializer = useJSON?[AFJSONRequestSerializer serializer]
    :[AFHTTPRequestSerializer serializer];
    
    serializer.timeoutInterval = kYLNetworkingTimeoutSeconds;
    NSMutableURLRequest *request = [serializer requestWithMethod:method
                                                       URLString:urlString
                                                      parameters:params
                                                           error:&error];
    
    //    [request setValue:@"3" forHTTPHeaderField:@"User-Id"];
    //    [request setValue:@"3" forHTTPHeaderField:@"User-Token"];
    //
    // 自定义header
    
    request.yl_requestParams = params;
    
    if (error) {
        [YLNetworkingLogger logError:request.description];
        return nil;
    }
    
    [YLNetworkingLogger logDebugInfoWithRequest:request path:urlString isJSON:useJSON params:params requestType:method];
    return request;
}


@end

