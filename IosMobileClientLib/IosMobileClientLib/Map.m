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
        _displayName=displayName;
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
        if (!topLeft || !topRight || !bottomLeft || !bottomRight)
            return nil;
        
        _mapId=mapId;
        _topLeftCorner=topLeft;
        _topRightCorner=topRight;
        _bottomLeftCorner=bottomLeft;
        _bottomRightCorner=bottomRight;
    }
    return self;
}


- (NSString *)description
{
 /*   return [NSString stringWithFormat:@"Display name: %@ Map id: %@ Top left:%@ Top right:%@ Bottom left: %@ Bottom right:%@",
            self.displayName, self.mapId,
            self.topLeftCorner.description, self.topRightCorner.description,
            self.bottomLeftCorner.description, self.bottomRightCorner.description];  */
    return [NSString stringWithFormat:@"MAP Display name: %@", self.displayName];
}

@end