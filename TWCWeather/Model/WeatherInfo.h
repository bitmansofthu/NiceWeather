//
//  WeatherInfo.h
//  TWCWeather
//
//  Created by AquaJava on 12/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

@property (nonatomic, strong) NSNumber* temp;
@property (nonatomic, strong) NSNumber* cloudiness;
@property (nonatomic, strong) NSString* condition;

@end
