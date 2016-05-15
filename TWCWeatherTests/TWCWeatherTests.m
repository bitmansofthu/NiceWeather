//
//  TWCWeatherTests.m
//  TWCWeatherTests
//
//  Created by AquaJava on 09/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OpenWeatherMapParser.h"
#import "WeatherInfo.h"

@interface TWCWeatherTests : XCTestCase

@end

@implementation TWCWeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testJsonParser {
    NSString* json = @"{\"coord\":{\"lon\":-0.13,\"lat\":51.51},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"02d\"}],\"base\":\"cmc stations\",\"main\":{\"temp\":15.2,\"pressure\":1023.87,\"humidity\":52,\"temp_min\":15.2,\"temp_max\":15.2,\"sea_level\":1033.82,\"grnd_level\":1023.87},\"wind\":{\"speed\":4.16,\"deg\":324.504},\"clouds\":{\"all\":8},\"dt\":1463335880,\"sys\":{\"message\":0.0052,\"country\":\"GB\",\"sunrise\":1463285224,\"sunset\":1463341660},\"id\":2643743,\"name\":\"London\",\"cod\":200}";
    
    OpenWeatherMapParser* parser = [[OpenWeatherMapParser alloc] init];
    WeatherInfo* info = [parser parseJsonData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    XCTAssert(parser.parseError == nil);
    XCTAssert(info.temp != nil && [info.temp floatValue] == 15.2f);
    XCTAssert(info.cloudiness != nil && [info.cloudiness integerValue] == 8);
    
}

@end
