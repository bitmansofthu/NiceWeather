//
//  LocationProvider.h
//  TWCWeather
//
//  Created by AquaJava on 13/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

static NSString* const kCurrentLocationUpdated = @"kCurrentLocationUpdated";

@interface LocationProvider : NSObject<CLLocationManagerDelegate>

+ (id)sharedInstance;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
