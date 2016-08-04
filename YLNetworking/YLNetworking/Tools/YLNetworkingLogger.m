//
//  YLNetworkingLogger.m
//  YLNetworking
//
//  Created by Yunpeng on 16/8/3.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLNetworkingLogger.h"
#import "YLNetworkingConfiguration.h"
@implementation YLNetworkingLogger
+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                           path:(NSString *)path
                         isJSON:(BOOL)isJSON
                         params:(id)requestParams
                    requestType:(NSString *)type {
#if YLNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ YLNetworking Request Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nParams is JSON : %@", isJSON?@"YES":@"NO"];
    [log appendFormat:@"\nRequest Type   : %@", type];
    [log appendFormat:@"\nRaw Request    : %@", request];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ YLNetworking Request Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logResponseWithRequest:(NSURLRequest *)request
                          path:(NSString *)path
                        params:(id)requestParams
                      response:(NSString *)response {
#if YLNetworkingLog && DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ YLNetworking Response Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\nReuqest Path   : %@", path];
    [log appendFormat:@"\nReuqest Params : %@", requestParams];
    [log appendFormat:@"\nResponse String: %@", response];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ YLNetworking Response Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}

+ (void)logInfo:(NSString *)msg {
    [self logInfo:msg label:@"Log"];
}

+ (void)logInfo:(NSString *)msg label:(NSString *)label {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendFormat:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ YLNetworking %@ Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙",label];
    [log appendFormat:@"\n%@", msg];
    [log appendFormat:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ YLNetworking %@ Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖",label];
    NSLog(@"%@",log);
#endif
}

+ (void)logError:(NSString *)msg {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘↘ [ YLNetworking Error Info ] ↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙↙"];
    [log appendFormat:@"\n%@", msg];
    [log appendString:@"\n↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗↗ [ YLNetworking Error Info End ] ↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖↖"];
    NSLog(@"%@",log);
#endif
}
@end
