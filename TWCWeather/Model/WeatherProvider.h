//
//  WeatherProvider.h
//  TWCWeather
//
//  Created by AquaJava on 12/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#ifndef WeatherProvider_h
#define WeatherProvider_h

#import "WeatherInfo.h"

typedef void(^WeatherInfoDownloadComplete)(WeatherInfo*, NSError*);

@protocol WeatherProvider <NSObject>

- (void)weatherInfoWithLocation:(NSArray*)coords complete:(WeatherInfoDownloadComplete)complete;
- (void)weatherInfoWithCity:(NSString*)city complete:(WeatherInfoDownloadComplete)complete;

@end

#endif /* WeatherProvider_h */
