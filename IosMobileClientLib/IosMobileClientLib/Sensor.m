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
            sensorPoints:(NSArray *)sensorPointsArray
     topLeftCorner:(CamsGeoPoint*)topLeft
    topRightCorner:(CamsGeoPoint*)topRight
  bottomLeftCorner:(CamsGeoPoint*)bottomLeft
 bottomRightCorner:(CamsGeoPoint*)bottomRight
             centerPoint:(CamsGeoPoint*)center;
{
    self = [super init];
    
    if (self)
    {
        _sensorDescription = desc;
        _sensorId = sId;
        _channelNumber = cNum;
        _sensorGuid = sguid;
        
        // Sort the sensor points in ascending order by their sequence number.
        _sensorPoints = [[NSMutableArray alloc] initWithArray:sensorPointsArray];
        [_sensorPoints sortUsingComparator:^(id obj1, id obj2) {
            
            SensorLinePoint *point1 = (SensorLinePoint *)obj1;
            SensorLinePoint *point2 = (SensorLinePoint *)obj2;
            
            NSNumber *seq1 = [point1 sequence];
            NSNumber *seq2 = [point2 sequence];
            
            return [seq2 compare:seq1];
        }];
        
        _topLeftCornerGeoPoint = topLeft;
        _bottomLeftCornerGeoPoint = topRight;
        _bottomLeftCornerGeoPoint = bottomLeft;
        _bottomRightCornerGeoPoint = bottomRight;
        _centerPoint = center;
        
        // MKOverlay properties
        coordinate = [CamsGeoPoint convertCamsGeoPointToCoordinate:center];
        _centerMapPoint = MKMapPointForCoordinate(coordinate);
        
        _topLeftCornerCoord = [CamsGeoPoint convertCamsGeoPointToCoordinate:topLeft];
        _topLeftCornerMapPoint = MKMapPointForCoordinate(_topLeftCornerCoord);
        
        _topRightCornerCoord = [CamsGeoPoint convertCamsGeoPointToCoordinate:topRight];
        _topRightCornerMapPoint = MKMapPointForCoordinate(_topRightCornerCoord);
        
        _bottomLeftCornerCoord = [CamsGeoPoint convertCamsGeoPointToCoordinate:bottomLeft];
        _bottomLeftCornerMapPoint = MKMapPointForCoordinate(_bottomLeftCornerCoord);
        
        _bottomRightCornerCoord = [CamsGeoPoint convertCamsGeoPointToCoordinate:bottomRight];
        _bottomRightCornerMapPoint = MKMapPointForCoordinate(_bottomRightCornerCoord);
        
        [self calculateSensorRegion];
    }
    return self;
}


//
// Calculate the MKMapRect of the sensor.
//
- (void) calculateSensorRegion
{
    // Find the latitude and longitude span in degrees.
    double latSpan = [_topLeftCornerGeoPoint.latitude doubleValue] - [_bottomLeftCornerGeoPoint.latitude doubleValue];
    double longSpan = [_bottomLeftCornerGeoPoint.longitude doubleValue] - [_topLeftCornerGeoPoint.longitude doubleValue];
    
    // Put the spans into a MKCoordinateSpan
    MKCoordinateSpan span;
    span.latitudeDelta = latSpan;
    span.longitudeDelta = longSpan;
    
    // Calculate the origin of the map in latitude/longitude degrees.
    CLLocationCoordinate2D origin;
    origin.latitude = [_centerPoint.latitude doubleValue];
    origin.longitude = [_centerPoint.longitude doubleValue];
    
    // Calculate the map size in map points.
    MKMapSize size;
    size.height = fabs(_topLeftCornerMapPoint.y - _bottomLeftCornerMapPoint.y);
    size.width = fabs(_topRightCornerMapPoint.x - _topLeftCornerMapPoint.x);
    
    boundingMapRect.origin = _centerMapPoint;
    boundingMapRect.size = size;
}


//
// Text description of the sensor.
//
- (NSString *)description
{
    return [NSString stringWithFormat:@"SENSOR Desc=%@ SensorID=%@", _sensorDescription, _sensorId];
}


//
// Used by the renderer to draw the sensor.
//
-(CLLocationCoordinate2D*) pointsToDrawInOverlay
{
    // Calculate the points
    NSUInteger pointCount = [[self sensorPoints] count];
    CLLocationCoordinate2D *pointsToUse = malloc(sizeof(CLLocationCoordinate2D) * pointCount);
    
    CLLocationCoordinate2D *start = pointsToUse;
    for (int i=0; i < [[self sensorPoints] count]; i++)
    {
        SensorLinePoint *slp = [self sensorPoints][i];
        CLLocationCoordinate2D cor = [CamsGeoPoint convertCamsGeoPointToCoordinate:slp];
        *pointsToUse=cor;
        pointsToUse++;
    }
    return start;
}

@end

