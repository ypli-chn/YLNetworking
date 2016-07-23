//
//  UserItemModel.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserItemModel.h"
@interface UserItemModel()
@end
@implementation UserItemModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid":@"uid",
             @"signature":@"signature",
             @"locId":@"loc_id",
             @"name":@"name",
             @"createdTime":@"created",
             @"locName":@"loc_name",
             @"avatarURLString":@"large_avatar",
             @"isBanned":@"is_banned",
             @"isSuicide":@"is_suicide",
             };
}
@end
