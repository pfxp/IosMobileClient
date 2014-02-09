//
//  Map.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Points.h"

@interface Map : NSObject
@property (readwrite) NSString *displayName;
@property (readwrite) NSString *mapId;
@property (readwrite) CamsGeoPoint *topLeftCorner;
@property (readwrite) CamsGeoPoint *topRightCorner;
@property (readwrite) CamsGeoPoint *bottomLeftCorner;
@property (readwrite) CamsGeoPoint *bottomCorner;
@end
