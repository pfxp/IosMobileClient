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
@property (readwrite, copy) NSString *displayName;
@property (readwrite, copy) NSString *mapId;
@property (readwrite, strong) CamsGeoPoint *topLeftCorner;
@property (readwrite, strong) CamsGeoPoint *topRightCorner;
@property (readwrite, strong) CamsGeoPoint *bottomLeftCorner;
@property (readwrite, strong) CamsGeoPoint *bottomRightCorner;

- (NSString *)description;

- (id) initWithDisplayName:(NSString *)displayName;
- (id) initWithDisplayName:(NSString *)displayName
                     mapId:(NSString *)mapId
                   topLeft:(CamsGeoPoint *)topLeft
                  topRight:(CamsGeoPoint *)topRight
                bottomLeft:(CamsGeoPoint *)bottomLeft
               bottomRight:(CamsGeoPoint *)bottomRight;


@end
