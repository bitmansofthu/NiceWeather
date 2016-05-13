//
//  OpenWeatherMapProvider.m
//  TWCWeather
//
//  Created by AquaJava on 09/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "OpenWeatherMapProvider.h"
#import "OpenWeatherMapParser.h"
#import <UIKit/UIKit.h>

static NSString* const LOCATION_URL = @"http://api.openweathermap.org/data/2.5/weather?lat=%.2f&lon=%.2f&units=metric&APPID=8f9fa4c75230f9fb1b9a548642957330";

static NSString* const CITY_URL = @"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&APPID=8f9fa4c75230f9fb1b9a548642957330";

@implementation OpenWeatherMapProvider

// API KEY 8f9fa4c75230f9fb1b9a548642957330

- (void)weatherInfoWithCity:(NSString*)city complete:(WeatherInfoDownloadComplete)complete {
    [self downloadInfo:[NSString stringWithFormat:CITY_URL, city] complete:complete];
}

- (void)weatherInfoWithLocation:(NSArray*)coords complete:(WeatherInfoDownloadComplete)complete {
    if (coords.count == 2) {
        [self downloadInfo:[NSString stringWithFormat:LOCATION_URL, [coords[0] floatValue], [coords[1] floatValue]] complete:complete];
    }
    
}

- (void)downloadInfo:(NSString*)url complete:(WeatherInfoDownloadComplete)complete {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          OpenWeatherMapParser* parser = [[OpenWeatherMapParser alloc] init];
                                          
                                          if (!error) {
                                              WeatherInfo* info = [parser parseJsonData:data];
                                              
                                              if (info) {
                                                  complete(info, nil);
                                              } else {
                                                  complete(nil, parser.parseError);
                                              }
                                          } else {
                                              complete(nil, error);
                                          }
                                      });
                                  }];
    
    [task resume];
                                              
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
