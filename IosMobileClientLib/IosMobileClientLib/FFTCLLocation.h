//
//  FFTCLLocation.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 20/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define RAD_TO_DEG(r) ((r) * (180 / M_PI))

@interface CLLocation (Direction)
- (CLLocationDirection)directionToLocation:(CLLocation *)location;
@end



