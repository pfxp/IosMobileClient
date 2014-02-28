//
//  ZoneEvent.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Controller;
@class Sensor;

@interface ZoneEvent : NSObject

@property (readwrite, copy) NSNumber *eventId;
@property (readwrite) NSDate *eventTimeUtc;
@property (readwrite) BOOL acknowledged;
@property (readwrite) BOOL active;
@property (readwrite) BOOL dynamic;
@property (readwrite, strong) Controller *controller;
@property (readwrite, strong) Sensor *sensor;

-(id) initWithEventId:(NSNumber *)eventId
            eventTime:(NSDate *)eventTime
         acknowledged:(BOOL)acknowledged
               active:(BOOL)active
              dynamic:(BOOL)dynamic
           controller:(Controller*)controller
               sensor:(Sensor *)sensor;

- (NSString*) description;
@end
