//
//  LocationProvider.m
//  TWCWeather
//
//  Created by AquaJava on 13/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "LocationProvider.h"

@implementation LocationProvider {
    CLLocationManager *locationManager;
}

+ (id)sharedInstance {
    static LocationProvider *locationProvider = nil;
    @synchronized(self) {
        if (locationProvider == nil)
            locationProvider = [[self alloc] init];
    }
    return locationProvider;
}

- (id)init {
    if ((self = [super init])) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    return self;
}

- (void)startUpdatingLocation {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationUpdated object:nil userInfo:@{@"error" : error}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationUpdated object:currentLocation];
}

@end
