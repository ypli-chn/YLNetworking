//
//  YLSignatureGenerator.h
//  YLNetworking
//
//  Created by Yunpeng on 16/8/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSignatureGenerator : NSObject

+ (NSString *)signatureWithRequestPath:(NSString *)path params:(NSDictionary *)params extra:(NSString *)extra;
@end
