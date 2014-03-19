//
//  GlobalSettings.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CamsWsRequest : NSInteger CamsWsRequest;
typedef enum RequestPriority : NSInteger RequestPriority;
typedef enum AlarmSection : NSInteger AlarmSection;
typedef enum AlarmType : NSInteger AlarmType;

enum CamsWsRequest : NSInteger {
    Unknown,
    GetControllers,
    GetZones,
    GetSensors,
    GetMaps,
    GetZoneEvents,
    GetLaserAlarms,
    GetSystemAlarms,
    PostAPNSToken,
    PostAcknowledgeAlarm
};

enum RequestPriority : NSInteger {
    Low,
    Medium,
    High
};

enum AlarmSection : NSInteger {
    IntrusionSection=0,
    LaserAlarmSection=1,
    SystemAlarmSection=2
};

enum AlarmType : NSInteger {
    UnknownAlarm=0x0,
    Intrusion=0x01,
    FibreBreak=0x100,
    OpticalPowerDegraded=0x200,
    LaserTemperatureWarning=0x400,
    LaserShutdown=0x800,
    LaserOff=0x1000,
    SopAlarm=0x2000,
    FossShutdown=0x100000,
    SopDegraded=0x200000,
    FossDegraded=0x400000,
    LocatorFault=0x800000,
    LostComms=0x1000000,
    TemperatureWarning=0x2000000,
    TemperatureShutdown=0x4000000,
    PowerSupplyDegraded=0x8000000,
    FotechLaserOff=0x10000000
};

@interface GlobalSettings : NSObject

+(AlarmType) alarmTypeFromNumber:(NSNumber *)alarmTypeAsNumber;
+(NSString *) alarmTypeAsString:(AlarmType) alarmType;
@end