//
//  Sensor.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Sensor.h"
#import <math.h>

@implementation Sensor

@synthesize boundingMapRect;
@synthesize coordinate;

- (id)      initWithDesc:(NSString*)desc
                sensorid:(NSNumber *)sId
           channelNumber:(NSNumber *)cNum
              sensorGuid:(NSString *)sguid
                  points:(NSArray *)pointsArray
     boundsTopLeftCorner:(CamsGeoPoint*)topLeft
    boundsTopRightCorner:(CamsGeoPoint*)topRight
  boundsBottomLeftCorner:(CamsGeoPoint*)bottomLeft
 boundsBottomRightCorner:(CamsGeoPoint*)bottomRight
             centerPoint:(CamsGeoPoint*)center;
{
    self = [super init];
    
    if (self)
    {
        _sensorDescription = desc;
        _sensorId = sId;
        _channelNumber = cNum;
        _sensorGuid = sguid;
        _points = pointsArray;
        _boundsTopLeftCorner = topLeft;
        _boundsTopRightCorner = topRight;
        _boundsBottomLeftCorner = bottomLeft;
        _boundsBottomRightCorner = bottomRight;
        _centerPoint = center;
        
        // MKOverlay properties
        coordinate = [Sensor convertCamsGeoPointToCoordinate:center];
        _centerMapPoint = MKMapPointForCoordinate(coordinate);
        
        _boundsTopLeftCornerCoord = [Sensor convertCamsGeoPointToCoordinate:topLeft];
        _boundsTopLeftCornerMapPoint = MKMapPointForCoordinate(_boundsTopLeftCornerCoord);
        
        _boundsTopRightCornerCoord = [Sensor convertCamsGeoPointToCoordinate:topRight];
        _boundsTopRightCornerMapPoint = MKMapPointForCoordinate(_boundsTopRightCornerCoord);
        
        _boundsBottomLeftCornerCoord = [Sensor convertCamsGeoPointToCoordinate:bottomLeft];
        _boundsBottomLeftCornerMapPoint = MKMapPointForCoordinate(_boundsBottomLeftCornerCoord);
        
        _boundsBottomRightCornerCoord = [Sensor convertCamsGeoPointToCoordinate:bottomRight];
        _boundsBottomRightCornerMapPoint = MKMapPointForCoordinate(_boundsBottomRightCornerCoord);
        
        // Find the latitude and longitude span in degrees.
        double latSpan = [topLeft.latitude doubleValue] - [bottomLeft.latitude doubleValue];
        double longSpan = [topRight.longitude doubleValue] - [topLeft.longitude doubleValue];
        
        // Put the spans into a MKCoordinateSpan
        MKCoordinateSpan span;
        span.latitudeDelta = latSpan;
        span.longitudeDelta = longSpan;
        
        // Calculate the origin of the map in latitude/longitude degrees.
        CLLocationCoordinate2D origin;
        origin.latitude = [center.latitude doubleValue];
        origin.longitude = [center.longitude doubleValue];
        
        // Construct a region for the MapView to display.
        MKCoordinateRegion region;
        region.center = origin;
        region.span = span;
        
        MKMapSize size;
        size.height = fabs(_boundsTopLeftCornerMapPoint.y - _boundsBottomLeftCornerMapPoint.y);
        size.width = fabs(_boundsTopRightCornerMapPoint.x - _boundsTopLeftCornerMapPoint.x);
        
        boundingMapRect.origin = _centerMapPoint;
        boundingMapRect.size = size;
        
    }
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"SENSOR Desc=%@ SensorID=%@ Channel=%@",
            _sensorDescription, _sensorId, _channelNumber];
}

-(CLLocationCoordinate2D*) pointsToDrawInOverlay
{
    // Calculate the points
    NSUInteger pointCount = [[self points] count];
    CLLocationCoordinate2D *pointsToUse = malloc(sizeof(CLLocationCoordinate2D) * pointCount);
    
    CLLocationCoordinate2D *start = pointsToUse;
    for (int i=0; i < [[self points] count]; i++)
    {
        SensorLinePoint *slp = [self points][i];
        CLLocationCoordinate2D cor = [Sensor convertCamsGeoPointToCoordinate:slp];
        *pointsToUse=cor;
        
    }
    return start;
}

+ (CLLocationCoordinate2D) convertCamsGeoPointToCoordinate:(CamsGeoPoint*)camsGeoPoint
{
    CLLocationCoordinate2D coord;
    coord.latitude = [camsGeoPoint.latitude doubleValue];
    coord.longitude = [camsGeoPoint.longitude doubleValue];
    return coord;
}

@end

