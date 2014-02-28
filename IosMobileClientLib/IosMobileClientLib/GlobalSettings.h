//
//  GlobalSettings.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum CamsWsRequest : NSInteger CamsWsRequest;

enum CamsWsRequest : NSInteger {
    GetControllers,
    GetZones,
    GetSensors,
    GetMaps,
    SetAPNSToken,
    GetZoneEvents
};

@interface GlobalSettings : NSObject

@end