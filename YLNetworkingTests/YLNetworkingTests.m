//
//  YLNetworkingTests.m
//  YLNetworkingTests
//
//  Created by Yunpeng on 16/7/13.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserAPIManager.h"
@interface YLNetworkingTests : XCTestCase <YLAPIManagerDataSource,YLAPIManagerDelegate> {
    XCTestExpectation *expectation;
}
@property (nonatomic, strong) UserAPIManager *apiManagerFirst;
@property (nonatomic, strong) UserAPIManager *apiManagerSecond;
@end

@implementation YLNetworkingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}



- (void)testDependency {
    expectation = [self expectationWithDescription:@"YLNetworkingTest"];
    
    self.apiManagerFirst = [[UserAPIManager alloc] init];
    self.apiManagerFirst.dataSource = self;
    self.apiManagerFirst.delegate = self;
    
    self.apiManagerSecond = [[UserAPIManager alloc] init];
    self.apiManagerSecond.dataSource = self;
    self.apiManagerSecond.delegate = self;
    
    [self.apiManagerSecond addDependency:self.apiManagerFirst];
    [self.apiManagerSecond loadNextPage];
    [self.apiManagerFirst loadNextPage];
    
    [self waitForExpectationsWithTimeout:20 handler:nil];
    
}

- (void)apiManagerLoadDataSuccess:(YLBaseAPIManager *)manager {
    if (manager == self.apiManagerFirst) {
        NSLog(@"apiManagerFirst Done");
    } else if(manager == self.apiManagerSecond) {
        NSLog(@"apiManagerSecond Done");
        [expectation fulfill];
    }
}

- (void)apiManagerLoadDataFail:(YLResponseError *)error {
    NSLog(@"===> %@",error);
    [expectation fulfill];
}

- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.apiManagerFirst) {
        params = @{
                   kUserAPIManagerParamsKeySearchKeywords:@"First",
                   };
    } else if(manager == self.apiManagerSecond) {
        params = @{
                   kUserAPIManagerParamsKeySearchKeywords:@"Second",
                   };
    }
   
    return params;
}

@end
