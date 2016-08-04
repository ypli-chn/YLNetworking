//
//  YLAPIBaseManager.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLResponseModel.h"
@class YLBaseAPIManager;
extern NSString * const kYLAPIBaseManagerRequestId;

// For transfer data
@protocol YLAPIManagerDataReformer <NSObject>
@required
- (id)apiManager:(YLBaseAPIManager *)manager reformData:(NSDictionary *)data;
@end

typedef NS_ENUM (NSUInteger, YLRequestType){
    YLRequestTypeGet,
    YLRequestTypePost,
};

typedef NS_ENUM (NSInteger, YLAPIManagerResponseStatus){
    YLAPIManagerResponseStatusDefault = -1,             //没有产生过API请求，默认状态。
    YLAPIManagerResponseStatusTimeout = 101,            //请求超时
    YLAPIManagerResponseStatusNoNetwork = 102,          //网络不通
    YLAPIManagerResponseStatusSuccess = 200,            //API请求成功且返回数据正确
    YLAPIManagerResponseStatusParsingError = 201,       //API请求成功但返回数据不正确
    YLAPIManagerResponseStatusNeedLogin = 300,          //认证信息无效
    YLAPIManagerResponseStatusRequestError = 400,       //请求出错，参数或方法错误
    YLAPIManagerResponseStatusTypeServerCrash = 500,    //服务器出错
    YLAPIManagerResponseStatusTypeServerMessage = 600,  //服务器自定义消息
};

@protocol YLAPIManager <NSObject>
@required
- (NSString *)path;
- (NSString *)apiVersion;
- (BOOL)isAuth;

@optional
- (YLRequestType)requestType;
- (BOOL)isResponseJSONable;
- (BOOL)isRequestUsingJSON;

- (BOOL)shouldCache;
- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期
@end

@protocol YLAPIManagerDataSource <NSObject>
@required
- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager;
@end


@protocol YLAPIManagerDelegate <NSObject>
@required
- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)manager;
- (void)apiManagerLoadDataFail:(YLResponseError *)error;
@end



@protocol YLAPIManagerInterceptor <NSObject>
@optional
- (BOOL)apiManager:(YLBaseAPIManager *)manager beforePerformSuccessWithResponseModel:(YLResponseModel *)responsemodel;
- (void)apiManager:(YLBaseAPIManager *)manager afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel;

- (BOOL)apiManager:(YLBaseAPIManager *)manager beforePerformFailWithResponseModel:(YLResponseError *)responseModel;
- (void)apiManager:(YLBaseAPIManager *)manager afterPerformFailWithResponseModel:(YLResponseError *)responseModel;

- (BOOL)apiManager:(YLBaseAPIManager *)manager shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)apiManager:(YLBaseAPIManager *)manager afterLoadRequestWithParams:(NSDictionary *)params;
@end



@interface YLBaseAPIManager : NSObject
@property (nonatomic, assign, readonly) BOOL isLoading;

@property (nonatomic, weak) id<YLAPIManagerDataSource> dataSource;
@property (nonatomic, weak) id<YLAPIManagerDelegate> delegate;
@property (nonatomic, weak) id<YLAPIManagerInterceptor> interceptor;

- (NSInteger)loadData;
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (BOOL)isReachable;

- (id)fetchData;
- (id)fetchDataWithReformer:(id<YLAPIManagerDataReformer>)reformer;
- (id)fetchDataFromModel:(Class)clazz; //默认只实现单个model，且对应model字段为data，否则需重写这个方法

- (NSDictionary *)reformParams:(NSDictionary *)params;

// default
- (NSString *)host;
- (YLRequestType)requestType;   //default is YLRequestTypePost;
- (BOOL)isResponseJSONable;     //default is YES;
- (BOOL)isRequestUsingJSON;     //default is YES;

- (NSInteger)cacheExpirationTime; // 返回0或者负数则永不过期

#pragma mark - 拦截器
// 用于子类需要监听相关事件，覆盖时需调用super对应方法
- (BOOL)beforePerformSuccessWithResponseModel:(YLResponseModel *)responseModel;
- (void)afterPerformSuccessWithResponseModel:(YLResponseModel *)responseModel;

- (BOOL)beforePerformFailWithResponseModel:(YLResponseError *)responseModel;
- (void)afterPerformFailWithResponseModel:(YLResponseError *)responseModel;

- (BOOL)shouldLoadRequestWithParams:(NSDictionary *)params;
- (void)afterLoadRequestWithParams:(NSDictionary *)params;

#pragma mark - 校验
// 需要校验则重写此方法
- (BOOL)isResponseDataCorrect:(YLResponseModel *)reponseModel;
@end
