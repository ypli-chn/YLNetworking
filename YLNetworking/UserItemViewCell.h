//
//  NewsViewCell.h
//  YLNetworking
//
//  Created by Yunpeng on 16/7/3.
//  Copyright (c) 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserItemViewModel.h"
static const CGFloat UserItemViewCellHeight = 80;
extern NSString *const UserItemViewCellIdentifier;
@interface UserItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localeLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, strong) UserItemViewModel *viewModel;
@end
