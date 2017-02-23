//
//  Foundation+YLNetworking.h
//  YLNetworking
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)
+ (void)yl_methodSwizzlingWithTarget:(SEL)originalSelector
                             using:(SEL)swizzledSelector
                          forClass:(Class)clazz;
@end


@interface NSString (YLNetworking)
- (NSString *)yl_md5;
+ (NSString *)yl_urlStringForHost:(NSString *)host
                          path:(NSString *)path
                    apiVersion:(NSString *)version;
@end

@interface NSData (YLNetworking)
- (NSString *)yl_md5;
@end


@interface NSDictionary (YLNetworking)
- (NSString *)yl_md5;
@end
