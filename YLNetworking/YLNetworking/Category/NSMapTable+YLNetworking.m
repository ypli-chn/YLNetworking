//
//  NSMapTable+YLNetworking.m
//  YLNetworking
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NSMapTable+YLNetworking.h"

@implementation NSMapTable (YLNetworking)
- (id)objectForKeyedSubscript:(id <NSCopying>)key {
    return [self objectForKey:key];
}
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    [self setObject:obj forKey:key];
}
@end
