//
//  NSURLRequest+YLNetworking.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSURLRequest+YLNetworking.h"
#import <objc/runtime.h>

@implementation NSURLRequest (YLNetworking)
- (void)setYl_requestParams:(NSDictionary *)yl_requestParams {
     objc_setAssociatedObject(self, @selector(yl_requestParams), yl_requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)yl_requestParams {
    return objc_getAssociatedObject(self, @selector(yl_requestParams));
}
@end