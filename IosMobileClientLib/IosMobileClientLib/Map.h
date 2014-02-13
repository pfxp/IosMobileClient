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
@property (readonly, copy) NSString *displayName;
@property (readonly, copy) NSString *mapId;
@property (readonly, strong) CamsGeoPoint *topLeftCorner;
@property (readonly, strong) CamsGeoPoint *topRightCorner;
@property (readonly, strong) CamsGeoPoint *bottomLeftCorner;
@property (readonly, strong) CamsGeoPoint *bottomRightCorner;


- (id) initWithDisplayName:(NSString *)displayName;
- (id) initWithDisplayName:(NSString *)displayName
                     mapId:(NSString *)mapId
                   topLeft:(CamsGeoPoint *)topLeft
                  topRight:(CamsGeoPoint *)topRight
                bottomLeft:(CamsGeoPoint *)bottomLeft
               bottomRight:(CamsGeoPoint *)bottomRight;

- (NSString *)description;

@end
