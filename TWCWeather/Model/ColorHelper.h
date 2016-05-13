//
//  ColorHelper.h
//  TWCWeather
//
//  Created by AquaJava on 09/05/16.
//  Copyright © 2016 AquaJava. All rights reserved.
//

#ifndef ColorHelper_h
#define ColorHelper_h

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#endif /* ColorHelper_h */
