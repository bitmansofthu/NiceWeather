//
//  OpenWeatherMapParser.h
//  TWCWeather
//
//  Created by AquaJava on 12/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherInfo;

@interface OpenWeatherMapParser : NSObject

@property (nonatomic, strong) NSError* parseError;

- (WeatherInfo*)parseJsonData:(NSData*)data;

@end
