//
//  CamsObjectRepository.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 7/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "CamsObjectRepository.h"
#import "GlobalSettings.h"
#import "CamsObject.h"

@implementation CamsObjectRepository

- (id) init
{
    self = [super init];

    return self;
}

- (int) GetControllers
{
    return 0;
}

- (int) GetSensors
{
    return 0;
}

- (int) GetGetZones
{
    return 0;
}

// Parses the JSON dictionary.
-(void) parseJsonDictionary:(NSDictionary *)dict command:(CamsWsRequent)req
{
    NSArray *jsonArray;
    
    switch(req)
    {
        case GetControllers:
            
            jsonArray = [dict objectForKey:@"GetAllControllersResult"];
            
            if (jsonArray)
            {
                for (NSDictionary *item in jsonArray)
                {
                    NSString *connected = [item objectForKey:@"Connected"];
                    NSString *description = [item objectForKey:@"Description"];
                    NSString *hostname = [item objectForKey:@"Hostname"];
                    NSString *idString = [item objectForKey:@"Id"];
                    NSString *isLocator = [item objectForKey:@"Locator"];
                    NSString *name = [item objectForKey:@"Name"];
                    
                    BOOL connectedAsBool = [connected boolValue];
                    NSNumber *idNumber = [NSNumber numberWithInteger:[idString integerValue]];
                    BOOL locatorAsBool = [isLocator boolValue];
                    Controller *controller = [[Controller alloc] initWithAllValues:connectedAsBool description:description hostname:hostname
                                                                            ctrlid:idNumber locator:locatorAsBool name:name];
                    
                    NSLog(@"CONT: %@", controller);
                    self.controllers[idNumber] = controller;
                }
            }

            break;
        case GetSensors:
            jsonArray = [dict objectForKey:@"GetAllSensorsResult"];
            
            if (jsonArray)
            {
                for (NSDictionary *item in jsonArray)
                {
                    NSString *description = [item objectForKey:@"Description"];
                    NSString *sensorId = [item objectForKey:@"SensorId"];
                    NSString *channelNumber = [item objectForKey:@"ChannelNumber"];
                    NSString *sensorGuid = [item objectForKey:@"SensorGuid"];
                   
                    NSNumber *sensorIdNumber = [NSNumber numberWithInteger:[sensorId integerValue]];
                    NSNumber *channelNumberNumber = [NSNumber numberWithInteger:[channelNumber integerValue]];
                    
                    Sensor *sensor = [[Sensor alloc] initWithDesc:description sensorid:sensorIdNumber channelNumber:channelNumberNumber sensorGuid:sensorGuid];
                    
                    NSLog(@"SENS: %@", sensor);
                    self.sensors[sensorIdNumber] = sensor;
                }
            }

            break;
        case GetZones:
            
            break;
    }
}

@end
