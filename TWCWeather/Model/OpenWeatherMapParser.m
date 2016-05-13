//
//  OpenWeatherMapParser.m
//  TWCWeather
//
//  Created by AquaJava on 12/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "OpenWeatherMapParser.h"
#import "WeatherInfo.h"

@implementation OpenWeatherMapParser

- (WeatherInfo*)parseJsonData:(NSData*)data {
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if (!e) {
        WeatherInfo* info = [[WeatherInfo alloc] init];
        
        info.temp = jsonDictionary[@"main"][@"temp"];
        info.cloudiness = jsonDictionary[@"clouds"][@"all"];
        
        return info;
    } else {
        self.parseError = e;
    }
    
    return nil;
}

@end
