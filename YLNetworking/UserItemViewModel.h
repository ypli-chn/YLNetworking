//
//  NewsViewModel.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLNetworking.h"
#import "UserItemModel.h"
@interface UserItemViewModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *locName;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSURL *avatarURL;

- (instancetype)initWithModel:(UserItemModel *)model;
@end
