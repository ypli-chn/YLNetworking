//
//  UserItemModel.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Mantle/Mantle.h>
@interface UserItemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *locId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *locName;
@property (nonatomic, copy) NSString *avatarURLString;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) BOOL isBanned;
@property (nonatomic, assign) BOOL isSuicide;
@end
