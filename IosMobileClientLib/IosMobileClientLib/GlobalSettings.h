//
//  GlobalSettings.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum CamsWsRequent : NSInteger CamsWsRequent;

enum CamsWsRequent : NSInteger {
    GetControllers,
    GetZones,
    GetSensors
};

@interface GlobalSettings : NSObject

@end