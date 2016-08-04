//
//  YLCacheProxy.m
//  YLNetworking
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLCacheProxy.h"
#import "Foundation+YLNetworking.h"
#import <YYCache/YYCache.h>
#import "YLSignatureGenerator.h"
#import "YLNetworkingLogger.h"
#import "YLNetworkingConfiguration.h"

static NSString * const  kYLNetworkingCacheObjctKey = @"xyz.ypli.kYLNetworkingCacheObjctKey";
static NSString * const  kYLNetworkingCacheDefault = @"xyz.ypli.kYLNetworkingCache.default";
@interface YLCacheProxy()
@property (nonatomic, strong) YYCache *defaultCache;
@end
@implementation YLCacheProxy

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YLCacheProxy *instance;
    dispatch_once(&onceToken, ^{
        instance = [[YLCacheProxy alloc] init];
    });
    return instance;
}

- (NSData *)cacheForParams:(NSDictionary *)params host:(NSString *)host path:(NSString *)path apiVersion:(NSString *)version {
    NSString *urlString = [NSString yl_urlStringForHost:host path:path apiVersion:version];
    NSString *key = [YLSignatureGenerator signatureWithRequestPath:urlString params:params extra:nil];
    return [self cacheForKey:key];
}

- (NSData *)cacheForKey:(NSString *)key {
    id cache = [self.defaultCache objectForKey:key];
    if (cache == nil) {
        NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        YYCache *cacheFile = [[YYCache alloc] initWithPath:[basePath stringByAppendingPathComponent:key]];
        cache = [cacheFile objectForKey:kYLNetworkingCacheObjctKey];
    }
    
    if ([cache isKindOfClass:[NSData class]]) {
        NSString *log =[NSString stringWithFormat:@"读取缓存:\n%@",[[NSString alloc] initWithData:cache encoding:NSUTF8StringEncoding]];
        [YLNetworkingLogger logInfo:log label:@"Cache"];
        return cache;
    } else {
        NSString *log = [NSString stringWithFormat:@"Return nil because cache data(%@) is NOT kind of NSData.",[cache class]];
        [YLNetworkingLogger logError:log];
        return nil;
    }
}


- (void)setCacheData:(NSData *)data
           forParams:(NSDictionary *)params
                host:(NSString *)host
                path:(NSString *)path
          apiVersion:(NSString *)version
  withExpirationTime:(NSTimeInterval)length {
    NSString *urlString = [NSString yl_urlStringForHost:host path:path apiVersion:version];
    NSString *key = [YLSignatureGenerator signatureWithRequestPath:urlString params:params extra:nil];
    [self setCacheData:data forKey:key withExpirationTime:length];
}

- (void)setCacheData:(NSData *)data forKey:(NSString *)key withExpirationTime:(NSTimeInterval)length {
    if ([data isKindOfClass:[NSData class]]) {
        if (length == kYLCacheExpirationTimeDefault) {
            [self.defaultCache setObject:data forKey:key];
            return;
        } else {
            // 确保从默认中删除之前的缓存
            [self.defaultCache removeObjectForKey:key];
        }
        NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
        YYCache *cache = [[YYCache alloc] initWithPath:[basePath stringByAppendingPathComponent:key]];
        cache.diskCache.ageLimit = length;
        [cache setObject:data forKey:kYLNetworkingCacheObjctKey];
        
        NSString *log =[NSString stringWithFormat:@"写入缓存:\n %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        [YLNetworkingLogger logInfo:log label:@"Cache"];
    } else {
        [YLNetworkingLogger logError:
        [NSString stringWithFormat:@"Cache data(%@) is NOT kind of NSData",[data class]]];
    }
}


- (YYCache *)defaultCache {
    if (_defaultCache == nil) {
        _defaultCache = [[YYCache alloc] initWithName:kYLNetworkingCacheDefault];
        _defaultCache.diskCache.ageLimit = kYLCacheExpirationTimeDefault;
    }
    return _defaultCache;
}
@end
