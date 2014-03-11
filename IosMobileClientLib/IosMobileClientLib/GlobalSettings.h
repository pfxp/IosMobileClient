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

enum CamsWsRequest : NSInteger {
    GetControllers,
    GetZones,
    GetSensors,
    GetMaps,
    SetAPNSToken,
    GetZoneEvents,
    PostAcknowledgeAlarm
};

enum RequestPriority : NSInteger {
    Low,
    Medium,
    High
};

@interface GlobalSettings : NSObject

@end