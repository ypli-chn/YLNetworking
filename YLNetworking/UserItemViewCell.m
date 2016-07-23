//
//  NewsViewCell.m
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright (c) 2015年 李云鹏. All rights reserved.
//

#import "UserItemViewCell.h"
#import <ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
NSString *const UserItemViewCellIdentifier = @"UserItemViewCellIdentifier";
@interface UserItemViewCell()

@end

@implementation UserItemViewCell

- (void)awakeFromNib {
    self.avatarImageView.image = nil; //prevent dirty data
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(UserItemViewModel *viewModel) {
        @strongify(self);
        self.nameLabel.text = viewModel.name;
        self.localeLabel.text = viewModel.locName;
        self.signatureLabel.text = viewModel.signature;
        
        
        // This practice doesn't meet MVVM, but it's so simple that I can't refuse it.
        // All principles are just for reference merely, aren't they?
        [self.avatarImageView setImageWithURL:viewModel.avatarURL];
    }];
    
}

@end
