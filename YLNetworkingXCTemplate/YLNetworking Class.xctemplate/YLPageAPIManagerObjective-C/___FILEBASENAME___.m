//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___FILEBASENAME___.h"
#import <Mantle/Mantle.h>

// NSString * const k___FILEBASENAMEASIDENTIFIER___ParamsKeyExample = @"k___FILEBASENAMEASIDENTIFIER___ParamsKeyExample";

@implementation ___FILEBASENAMEASIDENTIFIER___
#pragma mark - YLAPIManager

- (NSString *)path {
    return @"___VARIABLE_requestPath___";
}

- (NSString *)apiVersion {
    return @"___VARIABLE_apiVersion___";
}

- (BOOL)isAuth {
    return <#(BOOL)#>;
}


- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    // 在这里写参数赋值
//    resultParams[@"example"] = params[k___FILEBASENAMEASIDENTIFIER___ParamsKeyExample];
    
    
    
    
    return resultParams;
}

- (id)fetchDataFromModel:(Class)clazz {
    // 选择JSON数据中数据列表对应的键值
    return [MTLJSONAdapter modelsOfClass:clazz
                           fromJSONArray:[super fetchData][<#(nonnull NSString *)#>]
                                   error:nil];
}


#pragma mark -
- (NSInteger)currentPageSize {
    if([super fetchData]) {
        return [[super fetchData][<#(nonnull NSString *)#>] count];
    }
    return kPageSizeNotFound;
}



@end
