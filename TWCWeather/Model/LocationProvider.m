//
//  LocationProvider.m
//  TWCWeather
//
//  Created by AquaJava on 13/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "LocationProvider.h"

@interface LocationProvider()

@property (strong) CLLocation* lastLocation;

@end

@implementation LocationProvider {
    CLLocationManager *locationManager;
    BOOL errorDelegateCalled;
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
        errorDelegateCalled = NO;
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
    errorDelegateCalled = NO;
    self.lastLocation = nil;
    
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (!errorDelegateCalled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationUpdated object:nil userInfo:@{@"error" : error}];
        
        errorDelegateCalled = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    if (self.lastLocation == nil && self.lastLocation.timestamp != currentLocation.timestamp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrentLocationUpdated object:currentLocation];
        
        self.lastLocation = currentLocation;
    }
}

@end
