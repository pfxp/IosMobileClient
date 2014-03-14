//
//  Sensor.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Points.h"

@interface Sensor : NSObject <MKOverlay>
{
    CLLocationCoordinate2D *coordinatePoints;
}

#pragma mark MKOverlay protocol properties
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

#pragma mark CAMS properties
@property (readonly, copy) NSString *sensorDescription;
@property (readonly, copy) NSNumber *sensorId;
@property (readonly, copy) NSNumber *channelNumber;
@property (readonly, copy) NSString *sensorGuid;
@property (readonly, strong) NSMutableArray *sensorPoints;
@property (readonly, strong) NSArray *coordinates;

// The bounding rectangle of the sensor.
@property (readonly, strong) CamsGeoPoint* topLeftCornerGeoPoint;
@property (readonly, strong) CamsGeoPoint* topRightCornerGeoPoint;
@property (readonly, strong) CamsGeoPoint* bottomLeftCornerGeoPoint;
@property (readonly, strong) CamsGeoPoint* bottomRightCornerGeoPoint;
@property (readonly, strong) CamsGeoPoint* centerPoint;

// The bounding rectangle in MapKit coordinates.
@property (readonly) CLLocationCoordinate2D topLeftCornerCoord;
@property (readonly) CLLocationCoordinate2D topRightCornerCoord;
@property (readonly) CLLocationCoordinate2D bottomLeftCornerCoord;
@property (readonly) CLLocationCoordinate2D bottomRightCornerCoord;
@property (readonly) CLLocationCoordinate2D centerPointCoord;

// The bounding rectangle in Map Points
@property (readonly) MKMapPoint topLeftCornerMapPoint;
@property (readonly) MKMapPoint topRightCornerMapPoint;
@property (readonly) MKMapPoint bottomLeftCornerMapPoint;
@property (readonly) MKMapPoint bottomRightCornerMapPoint;
@property (readonly) MKMapPoint centerMapPoint;


- (id)        initWithDesc:(NSString*)desc
                  sensorid:(NSNumber *)sId
             channelNumber:(NSNumber *)cNum
                sensorGuid:(NSString *)sguid
                    sensorPoints:(NSArray *)sensorPointsArray
       topLeftCorner:(CamsGeoPoint*)topLeft
      topRightCorner:(CamsGeoPoint*)topRight
    bottomLeftCorner:(CamsGeoPoint*)bottomLeft
   bottomRightCorner:(CamsGeoPoint*)bottomRight
               centerPoint:(CamsGeoPoint*)center;


- (NSString *)description;
-(CLLocationCoordinate2D*) pointsToDrawInOverlay;


@end