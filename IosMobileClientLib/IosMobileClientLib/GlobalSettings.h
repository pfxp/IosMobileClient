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

@interface GlobalSettings : NSObject

+(NSString *) alarmTypeAsString:(NSUInteger *)alarmType;
@end