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

static NSString * const  kYLNetworkingCacheKeyCacheData = @"xyz.ypli.kYLNetworkingCacheKeyCacheData";
static NSString * const  kYLNetworkingCacheKeyCacheTime = @"xyz.ypli.kYLNetworkingCacheKeyCacheTime";
static NSString * const  kYLNetworkingCacheKeyCacheAgeLength = @"xyz.ypli.kYLNetworkingCacheKeyCacheAgeLength";

static NSString * const  kYLNetworkingCache = @"xyz.ypli.kYLNetworkingCache";

@interface YLCacheProxy()
@property (nonatomic, strong) YYCache *cache;
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
    NSDictionary *cacheDict = [self.cache objectForKey:key];
    
    NSData *cacheData = cacheDict[kYLNetworkingCacheKeyCacheData];
    NSTimeInterval cacheTime = [cacheDict[kYLNetworkingCacheKeyCacheTime] doubleValue];
    NSInteger cacheAgeLength = [cacheDict[kYLNetworkingCacheKeyCacheAgeLength] integerValue];
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if (now - cacheTime > cacheAgeLength) {
        [YLNetworkingLogger logInfo:@"已过期" label:@"Cache"];
        [self.cache removeObjectForKey:key];
        return nil;
    } else {
        if ([cacheData isKindOfClass:[NSData class]]) {
            NSString *log =[NSString stringWithFormat:@"读取缓存:\n%@",[[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding]];
            [YLNetworkingLogger logInfo:log label:@"Cache"];
            return cacheData;
        } else {
            NSString *log = [NSString stringWithFormat:@"Return nil because cache data(%@) is NOT kind of NSData.",[cacheData class]];
            [YLNetworkingLogger logError:log];
            return nil;
        }
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
    if (data == nil) {
        return;
    }
    if ([data isKindOfClass:[NSData class]]) {
        NSDictionary *cacheDict =
        @{
          kYLNetworkingCacheKeyCacheData: data,
          kYLNetworkingCacheKeyCacheTime: @([NSDate timeIntervalSinceReferenceDate]),
          kYLNetworkingCacheKeyCacheAgeLength : @(length),
          };
        
        [self.cache setObject:cacheDict forKey:key];
        
        NSString *log =[NSString stringWithFormat:@"写入缓存:\n %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        [YLNetworkingLogger logInfo:log label:@"Cache"];
    } else {
        [YLNetworkingLogger logError:
         [NSString stringWithFormat:@"Cache data(%@) is NOT kind of NSData",[data class]]];
    }
}

- (YYCache *)cache {
    if (_cache == nil) {
        _cache = [[YYCache alloc] initWithName:kYLNetworkingCache];
        _cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    }
    return _cache;
}
@end
