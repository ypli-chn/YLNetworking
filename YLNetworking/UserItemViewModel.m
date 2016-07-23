//
//  NewsViewModel.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "UserItemViewModel.h"
#import "UserAPIManager.h"

@implementation UserItemViewModel

- (instancetype)initWithModel:(UserItemModel *)model {
    self = [super init];
    if (self) {
        RAC(self, name) = RACObserve(model, name);
        RAC(self, locName) = RACObserve(model, locName);
        RAC(self, signature) = RACObserve(model, signature);
        RAC(self, avatarURL) = [RACObserve(model, avatarURLString) map:^id(NSString *value) {
            if (value == nil) {
                return nil;
            }
            return [[NSURL alloc] initWithString:value];
        }];
    }
    return self;
}

@end
