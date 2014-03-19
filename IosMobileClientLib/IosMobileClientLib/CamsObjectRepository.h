//
//  CamsObjectRepository.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalSettings.h"

@class Controller;
@class Sensor;
@class Zone;
@class Map;
@class ZoneEvent;
@class LaserAlarm;
@class SystemAlarm;
@class CamsGeoPoint;

@interface CamsObjectRepository : NSObject

@property (readwrite) NSMutableDictionary *controllers;
@property (readwrite) NSMutableDictionary *sensors;
@property (readwrite) NSMutableDictionary *zones;
@property (readwrite) NSMutableDictionary *maps;
@property (readwrite) NSMutableDictionary *zoneEvents;
@property (readwrite) NSMutableDictionary *laserAlarms;
@property (readwrite) NSMutableDictionary *systemAlarms;

-(CamsWsRequest) parseJsonDictionary:(NSDictionary *)dict;
-(CamsWsRequest) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest) req;
-(ZoneEvent*) getZoneEventOrderedByTimeDesc:(int) index;
-(LaserAlarm*) getLaserAlarmOrderedByTimeDesc:(int) index;
-(SystemAlarm*) getSystemAlarmOrderedByTimeDesc:(int) index;
-(Zone *) getZoneById:(NSNumber *)zoneId;
-(Sensor *) getSensorById:(NSNumber *)sensorId;
-(Controller *) getControllerById:(NSNumber *)controllerId;
-(Map *) getMapByIndex:(int) index;

+ (Controller *) parseControllerJsonDictionary:(NSDictionary *) dict;
+ (Sensor *) parseSensorJsonDictionary:(NSDictionary *) dict;
+ (Zone *) parseZoneJsonDictionary:(NSDictionary *) dict;
+ (Map *) parseMapJsonDictionary:(NSDictionary *) dict;
+ (ZoneEvent *) parseZoneEventJsonDictionary:(NSDictionary *) dict;
+ (LaserAlarm *) parseLaserAlarmJsonDictionary:(NSDictionary *) dict;
+ (SystemAlarm *) parseSystemAlarmJsonDictionary:(NSDictionary *) dict;
+ (CamsGeoPoint *) parseCamsGeoPointDictionary:(NSDictionary *) dict;

@end
