//
//  FFTCLLocation.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 20/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "FFTCLLocation.h"


@implementation CLLocation (Direction)

- (CLLocationDirection)directionToLocation:(CLLocation *)location {
	
	CLLocationCoordinate2D coord1 = self.coordinate;
	CLLocationCoordinate2D coord2 = location.coordinate;
	
	CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
	CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
	CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
	
	CLLocationDegrees radians = atan2(yComponent, xComponent);
	CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
	
	return fmod(degrees, 360);
}

@end


