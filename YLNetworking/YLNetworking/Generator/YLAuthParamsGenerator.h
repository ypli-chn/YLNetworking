//
//  YLAuthParamsGenerator.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const kYLAuthParamsKeyUserId;
@interface YLAuthParamsGenerator : NSObject
+ (NSDictionary *)authParams;
@end
