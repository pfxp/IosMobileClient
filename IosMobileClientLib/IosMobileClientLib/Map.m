//
//  Map.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Map.h"

@implementation Map

- (id) initWithDisplayName:(NSString *)displayName
{
    self = [super init];
    if (self)
    {
        [self setDisplayName:displayName];
    }
    return self;
}

- (id) initWithDisplayName:(NSString *)displayName
                     mapId:(NSString *)mapId
                   topLeft:(CamsGeoPoint *)topLeft
                  topRight:(CamsGeoPoint *)topRight
                bottomLeft:(CamsGeoPoint *)bottomLeft
               bottomRight:(CamsGeoPoint *)bottomRight;
{
    self = [self initWithDisplayName:displayName];
    
    if (self)
    {
        //if (!([self topLeftCorner]) || !([self topRightCorner]) || !([self bottomLeftCorner]) || !([self bottomRightCorner]))
        //    return nil;
            
        [self setMapId:mapId];
        [self setTopLeftCorner:topLeft];
        [self setTopRightCorner:topRight];
        [self setBottomLeftCorner:bottomLeft];
        [self setBottomRightCorner:bottomRight];
    }
    return self;
}


@end