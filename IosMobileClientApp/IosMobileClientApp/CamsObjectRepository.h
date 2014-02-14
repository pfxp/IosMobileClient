//
//  CamsObjectRepository.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 7/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IosMobileClientLib/GlobalSettings.h"

@interface CamsObjectRepository : NSObject

@property (readwrite) NSMutableDictionary *controllers;
@property (readwrite) NSMutableDictionary *sensors;
@property (readwrite) NSMutableDictionary *zones;

-(void) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequest) req;

- (int) GetControllers;
- (int) GetSensors;
- (int) GetGetZones;

@end
