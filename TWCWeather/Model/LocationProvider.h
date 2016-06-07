//
//  LocationProvider.h
//  TWCWeather
//
//  Created by AquaJava on 13/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationUpdateCompleted)(CLLocation*);
typedef void(^LocationUpdateFailed)(NSError*);

@interface LocationProvider : NSObject<CLLocationManagerDelegate>

- (void)updateLocationWithCompletion:(LocationUpdateCompleted)complete failure:(LocationUpdateFailed)failed ;
- (void)stopUpdatingLocation;

@end
