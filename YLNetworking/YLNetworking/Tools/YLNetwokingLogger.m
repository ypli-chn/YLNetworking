//
//  YLNetwokingLogger.m
//  YLNetworking
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLNetwokingLogger.h"
#import "YLNetworkingConfiguration.h"
@implementation YLNetwokingLogger
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                           path:(NSString *)path
                         isJSON:(BOOL)isJSON
                         params:(id)requestParams
                    requestType:(NSString *)type {
#if YLNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ Request Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nParams is JSON : %@", isJSON?@"YES":@"NO"];
    [log appendFormat:@"\nRequest Type   : %@", type];
    [log appendFormat:@"\nRaw Request    : %@", request];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ Request Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logResponseWithRequest:(NSURLRequest *)request
                          path:(NSString *)path
                        params:(id)requestParams
                      response:(NSString *)response {
#if YLNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ Response Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nResponse String: %@", response];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logError:(NSString *)msg {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ Error Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\n%@", msg];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ Error Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}
@end
