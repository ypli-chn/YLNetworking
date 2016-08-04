//
//  YLSignatureGenerator.m
//  YLNetworking
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLSignatureGenerator.h"
#import "Foundation+YLNetworking.h"
@implementation YLSignatureGenerator
+ (NSString *)signatureWithRequestPath:(NSString *)path params:(NSDictionary *)params extra:(NSString *)extra {
    return [[NSString stringWithFormat:@"%@%@%@",path, [params yl_md5], extra] yl_md5];
}
@end
