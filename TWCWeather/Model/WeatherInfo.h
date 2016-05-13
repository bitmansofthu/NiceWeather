//
//  WeatherInfo.h
//  TWCWeather
//
//  Created by AquaJava on 12/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

@property (nonatomic, assign) NSNumber* temp;
@property (nonatomic, assign) NSNumber* cloudiness;
@property (nonatomic, strong) NSString* condition;

@end
