//
//  LocationProvider.m
//  TWCWeather
//
//  Created by AquaJava on 13/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import "LocationProvider.h"

@interface LocationProvider()

@property (strong) CLLocation* bestEffortAtLocation;

@property (nonatomic, copy, nullable) LocationUpdateCompleted locationUpdateCompleted;
@property (nonatomic, copy, nullable) LocationUpdateFailed locationUpdateFailed;

@end

@implementation LocationProvider {
    CLLocationManager *locationManager;
    BOOL errorDelegateCalled;
}

- (id)init {
    if ((self = [super init])) {
        locationManager = [[CLLocationManager alloc] init];
        errorDelegateCalled = NO;
    }
    
    return self;
}

- (void)updateLocationWithCompletion:(LocationUpdateCompleted)complete failure:(LocationUpdateFailed)failed {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    self.locationUpdateCompleted = complete;
    self.locationUpdateFailed = failed;
    
    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    errorDelegateCalled = NO;
    self.bestEffortAtLocation = nil;
    
    self.locationUpdateCompleted = nil;
    self.locationUpdateFailed = nil;
    
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (!errorDelegateCalled) {
        if (self.locationUpdateFailed) {
            self.locationUpdateFailed(error);
        }
        
        errorDelegateCalled = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations lastObject];
    
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    //
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) {
        return;
    }
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (currentLocation.horizontalAccuracy < 0) {
        return;
    }
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (self.bestEffortAtLocation == nil || self.bestEffortAtLocation.horizontalAccuracy > currentLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = currentLocation;
        
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (currentLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            if (self.locationUpdateCompleted) {
                self.locationUpdateCompleted(currentLocation);
            }
            
            [self stopUpdatingLocation];
        }
    }
}

@end
