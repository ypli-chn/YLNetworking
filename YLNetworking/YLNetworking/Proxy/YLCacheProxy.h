//
//  YLCacheProxy.h
//  YLNetworking
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLCacheProxy : NSObject
+ (instancetype)sharedInstance;


- (NSData *)cacheForParams:(NSDictionary *)params
                      host:(NSString *)host
                      path:(NSString *)path
                apiVersion:(NSString *)version;

- (NSData *)cacheForKey:(NSString *)key;



- (void)setCacheData:(NSData *)data
           forParams:(NSDictionary *)params
                host:(NSString *)host
                path:(NSString *)path
          apiVersion:(NSString *)version
  withExpirationTime:(NSTimeInterval)length;

- (void)setCacheData:(NSData *)data forKey:(NSString *)key  withExpirationTime:(NSTimeInterval)length;
@end
