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

#pragma mark MKOverlay protocol properties
@property (nonatomic, readonly) MKMapRect boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

#pragma mark CAMS properties
@property (readonly, copy) NSString *sensorDescription;
@property (readonly, copy) NSNumber *sensorId;
@property (readonly, copy) NSNumber *channelNumber;
@property (readonly, copy) NSString *sensorGuid;
@property (readonly, strong) NSArray *points;

@property (readonly, strong) CamsGeoPoint* boundsTopLeftCorner;
@property (readonly, strong) CamsGeoPoint* boundsTopRightCorner;
@property (readonly, strong) CamsGeoPoint* boundsBottomLeftCorner;
@property (readonly, strong) CamsGeoPoint* boundsBottomRightCorner;
@property (readonly, strong) CamsGeoPoint* centerPoint;


- (id)        initWithDesc:(NSString*)desc
                  sensorid:(NSNumber *)sId
             channelNumber:(NSNumber *)cNum
                sensorGuid:(NSString *)sguid
                    points:(NSArray *)pointsArray
       boundsTopLeftCorner:(CamsGeoPoint*)topLeft
      boundsTopRightCorner:(CamsGeoPoint*)topRight
    boundsBottomLeftCorner:(CamsGeoPoint*)bottomLeft
   boundsBottomRightCorner:(CamsGeoPoint*)bottomRight
               centerPoint:(CamsGeoPoint*)center;





- (NSString *)description;



@end