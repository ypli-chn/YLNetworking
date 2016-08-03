//
//  YLAPIBaseManager.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLBaseAPIManager.h"
#import "YLAPIProxy.h"
#import <Mantle/Mantle.h>
#import "YLAuthParamsGenerator.h"
NSString * const kYLAPIBaseManagerRequestId = @"xyz.ypli.kYLAPIBaseManagerRequestID";

#define YLLoadRequest(REQUEST_METHOD, REQUEST_ID)                                                  \
{\
__weak typeof(self) weakSelf = self;\
REQUEST_ID = [[YLAPIProxy sharedInstance] load##REQUEST_METHOD##WithParams:apiParams useJSON:self.isRequestUsingJSON host:self.host path:self.child.path apiVersion:self.child.apiVersion success:^(YLResponseModel *response) {\
    __strong typeof(weakSelf) strongSelf = weakSelf;\
    [strongSelf dataDidLoad:response];\
} fail:^(YLResponseError *error) {\
    __strong typeof(weakSelf) strongSelf = weakSelf;\
    [strongSelf dataLoadFailed:error];\
}];\
[self.requestIdList addObject:@(REQUEST_ID)];\
}\

@interface YLBaseAPIManager()
@property (nonatomic, strong, readwrite) id rawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, weak) YLBaseAPIManager<YLAPIManager>* child;

@end
@implementation YLBaseAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(YLAPIManager)]) {
            self.child = (id <YLAPIManager>)self;
        } else {
            @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ init failed",[self class]]
                                           reason:@"Subclass of YLAPIBaseManager should implement <YLAPIManager>"
                                         userInfo:nil];
        }
    }
    return self;
}

//- (BOOL)shouldCache {
//    return kYLShouldCacheDefault;
//}

- (NSString *)host {
    return kServerURL;
}

- (YLRequestType)requestType {
    return YLRequestTypePost;
}

- (BOOL)isResponseJSONable {
    return YES;
}

- (BOOL)isRequestUsingJSON {
    return YES;
}

- (BOOL)isReachable {
    return [[YLAPIProxy sharedInstance] isReachable];
}

- (BOOL)isLoading {
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (NSInteger)loadData {
    NSDictionary *params = [self.dataSource paramsForAPI:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

// 不将此方法开放出去是为了强制使用dataSource来提供数据，类同UITableView
- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldLoadRequestWithParams:params]) {
        if ([[YLAPIProxy sharedInstance] isReachable]) {
            self.isLoading = YES;
            NSMutableDictionary *finalAPIParams = [[NSMutableDictionary alloc] init];
            if (params) {
                [finalAPIParams addEntriesFromDictionary:apiParams];
            }
            if (self.child.isAuth) {
                NSDictionary *authParams = [YLAuthParamsGenerator authParams];
                if (authParams) {
                    [finalAPIParams addEntriesFromDictionary:authParams];
                } else {
                    [self dataLoadFailed:
                     [YLBaseAPIManager errorWithRequestId:requestId
                                                   status:YLAPIManagerResponseStatusNeedLogin]];
                }
            }
            switch (self.child.requestType) {
                case YLRequestTypeGet:
                    YLLoadRequest(GET, requestId);
                    break;
                case YLRequestTypePost:
                    YLLoadRequest(POST, requestId);
                    break;
                default:
                    break;
            }
            NSMutableDictionary *params = [apiParams mutableCopy];
            params[kYLAPIBaseManagerRequestId] = @(requestId);
            [self afterLoadRequestWithParams:params];
            return requestId;
        } else {
            [self dataLoadFailed:
             [YLBaseAPIManager errorWithRequestId:requestId
                                           status:YLAPIManagerResponseStatusNoNetwork]];
            return requestId;
        }
    }
    return requestId;
}



#pragma mark - api callbacks
- (void)dataDidLoad:(YLResponseModel *)responseModel {
    
    self.isLoading = NO;
    [self removeRequestIdWithRequestId:responseModel.requestId];
    
    if ([self isResponseJSONable]) {
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseModel.responseData
                                                             options:NSJSONReadingMutableLeaves
                                                               error:&error];
        if (error != nil) {
            [self dataLoadFailed:
             [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                           status:YLAPIManagerResponseStatusParsingError]];
            return;
        }
        
        self.rawData = jsonDict;
        NSInteger status = [jsonDict[@"status"] integerValue];
        if (status != YLAPIManagerResponseStatusSuccess) {
            YLResponseError *error = [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                                                   status:status
                                                                    extra:jsonDict[@"message"]];
            
            [self.delegate apiManagerLoadDataFail:error];
        }
    } else {
        self.rawData = [responseModel.responseData copy];
    }
    
    if([self isResponseDataCorrect:responseModel]) {
        if ([self beforePerformSuccessWithResponseModel:responseModel]) {
            [self.delegate apiManagerLoadDataSuccess:self];
        }
        [self afterPerformSuccessWithResponseModel:responseModel];
    } else {
        [self.delegate apiManagerLoadDataFail:
         [YLBaseAPIManager errorWithRequestId:responseModel.requestId
                                       status:YLAPIManagerResponseStatusParsingError]];
    }
    
}

- (void)dataLoadFailed:(YLResponseError *)error {
    [self removeRequestIdWithRequestId:error.requestId];
    if ([self beforePerformFailWithResponseModel:error]) {
        [self.delegate apiManagerLoadDataFail:error];
    }
    [self afterPerformFailWithResponseModel:error];
}


#pragma mark - public API
- (void)cancelAllRequests {
    [[YLAPIProxy sharedInstance] cancelRequestWithRequestIdList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIdWithRequestId:requestID];
    [[YLAPIProxy sharedInstance] cancelRequestWithRequestId:@(requestID)];
}

- (id)fetchData {
    return [self fetchDataWithReformer:nil];
}

- (id)fetchDataWithReformer:(id<YLAPIManagerDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(apiManager:reformData:)]) {
        resultData = [reformer apiManager:self reformData:self.rawData];
    } else {
        resultData = [self.rawData mutableCopy];
    }
    return resultData;
}

- (id)fetchDataFromModel:(Class)clazz {
    NSError *error;
    id model = [MTLJSONAdapter modelOfClass:clazz fromJSONDictionary:[self fetchData][@"data"] error:&error];
    NSLog(@"Error:%@",error);
    return model;
}

//- (id)fetchDataFromModel {
//    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ fetchDataFromModel failed",[self class]]
//                                   reason:@"Subclass of YLAPIBaseManager should override fetchDataFromModel."
//                                 userInfo:nil];
//}

#pragma mark - private API
- (void)removeRequestIdWithRequestId:(NSInteger)requestId {
    NSNumber *requestIdToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIdToRemove = storedRequestId;
        }
    }
    if (requestIdToRemove) {
        [self.requestIdList removeObject:requestIdToRemove];
    }
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#define YLResponseErrorWithMSG(MSG) YLResponseError(MSG, status, requestId)
+ (YLResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(YLAPIManagerResponseStatus)status {
    return [self errorWithRequestId:requestId status:status extra:nil];
}
+ (YLResponseError *)errorWithRequestId:(NSInteger)requestId
                                 status:(YLAPIManagerResponseStatus)status
                                  extra:(NSString *)message {
    switch (status) {
        case YLAPIManagerResponseStatusParsingError:
            return YLResponseErrorWithMSG(@"数据解析错误");
        case YLAPIManagerResponseStatusTimeout:
            return YLResponseErrorWithMSG(@"请求超时");
        case YLAPIManagerResponseStatusNoNetwork:
            return YLResponseErrorWithMSG(@"当前网络已断开");
        case YLAPIManagerResponseStatusNeedLogin:
            return YLResponseErrorWithMSG(@"请登录");
        case YLAPIManagerResponseStatusRequestError:
            return YLResponseErrorWithMSG(@"参数错误");
        case YLAPIManagerResponseStatusTypeServerCrash:
            return YLResponseErrorWithMSG(@"服务器出错");
        case YLAPIManagerResponseStatusTypeServerMessage:
            return YLResponseErrorWithMSG(message?:@"未知信息");
        default:
            return YLResponseErrorWithMSG(@"未知错误");
    }
}

#pragma mark - 
- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformSuccessWithResponseModel:)]) {
        result = [self.interceptor apiManager:self beforePerformSuccessWithResponseModel:responseModel];
    }
    return result;
}
- (void)afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformSuccessWithResponseModel:)]) {
        [self.interceptor apiManager:self afterPerformSuccessWithResponseModel:responseModel];
    }
}

- (BOOL)beforePerformFailWithResponseModel:(YLResponseError *)responseModel {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:beforePerformFailWithResponseModel:)]) {
        result = [self.interceptor apiManager:self beforePerformFailWithResponseModel:responseModel];
    }
    return result;
}
- (void)afterPerformFailWithResponseModel:(YLResponseError *)responseModel {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterPerformFailWithResponseModel:)]) {
        [self.interceptor apiManager:self afterPerformFailWithResponseModel:responseModel];
    }
}

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params {
    BOOL result = YES;
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:shouldLoadRequestWithParams:)]) {
        result = [self.interceptor apiManager:self shouldLoadRequestWithParams:params];
    }
    return result;
}

- (void)afterLoadRequestWithParams:(NSDictionary *)params {
    if (self != self.interceptor
        && [self.interceptor respondsToSelector:@selector(apiManager:afterLoadRequestWithParams:)]) {
        [self.interceptor apiManager:self afterLoadRequestWithParams:params];
    }
}

#pragma mark - 校验器
// 这里不作实现，这样子类重写时，不需要调用super
- (BOOL)isResponseDataCorrect:(YLResponseModel *)reponseModel {
    return YES;
}
@end
