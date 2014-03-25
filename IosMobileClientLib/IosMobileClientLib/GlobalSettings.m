//
//  GlobalSettings.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "GlobalSettings.h"

#pragma mark Notification identifiers.
NSString *ControllersReceivedFromServerNotification = @"ControllersReceivedFromServer";
NSString *SensorsReceivedFromServerNotification = @"SensorsReceivedFromServer";
NSString *ZonesReceivedFromServerNotification = @"ZonesReceivedFromServer";
NSString *MapsReceivedFromServerNotification = @"MapsReceivedFromServer";
NSString *ZoneEventsReceivedFromServerNotification = @"ZoneEventsReceivedFromServer";
NSString *LaserAlarmsReceivedFromServerNotification = @"LaserAlarmsReceivedFromServer";
NSString *SystemAlarmsReceivedFromServerNotification = @"SystemAlarmsReceivedFromServer";

@implementation  GlobalSettings

static NSArray *compassBearings = nil;

//
// Static initializer of sorts
// Refer to http://stackoverflow.com/questions/992070/static-constructor-equivalent-in-objective-c
+ (void) initialize
{
    if (compassBearings == nil)
    {
        compassBearings = [[NSArray alloc] initWithObjects:@"north",@"NNE",@"NE",@"ENE",@"east",@"ESE",@"SE", @"SSE",@"south",@"SSW",@"SW",@"WSW",@"west",@"WNW",@"NW",@"NNW",nil];
    }
}



//
// TODO Redundant function
//
+(AlarmType) alarmTypeFromNumber:(NSNumber *)alarmTypeAsNumber
{
    return (AlarmType) [alarmTypeAsNumber longValue];
}



// Returns a string representation of alarms.
// TODO Localise the strings
// TODO Add External alarms.
+(NSString *) alarmTypeAsString:(AlarmType) alarmType
{
    switch (alarmType)
    {
        case UnknownAlarm:
            // Unknown alarm
            return @"Unknown Alarm";
            break;
            
            // Intrusion alarms
        case Intrusion:
            return @"Intrusion";
            break;
            
            // Laser alarms
        case FibreBreak:
            return @"Fibre Break";
            break;
        case OpticalPowerDegraded:
            return @"Optical Power Degraded";
            break;
        case LaserTemperatureWarning:
            return @"Laser Temperature Warning";
            break;
        case LaserShutdown:
            return @"Laser Shutdown";
            break;
        case LaserOff:
            return @"Laser Off";
            break;
        case SopAlarm:
            return @"Sop Alarm";
            break;
            
            // System alarms
        case FossShutdown:
            return @"FOSS Shutdown";
            break;
        case SopDegraded:
            return @"SOP Degraded";
            break;
        case FossDegraded:
            return @"FOSS Degraded";
            break;
        case LocatorFault:
            return @"Locator Fault";
            break;
        case LostComms:
            return @"Lost Communications";
            break;
        case TemperatureWarning:
            return @"Temperature Warning";
            break;
        case TemperatureShutdown:
            return @"Temperature Shutdown";
            break;
        case PowerSupplyDegraded:
            return @"Power Supply Degraded";
            break;
        case FotechLaserOff:
            return @"Fotech Laser Off";
            break;
            
        default:
            return @"Bad Alarm";
            break;
    }
}



//
// TODO Fix this logic.
//
+(NSString *) convertHeadingToCompassBearing:(float) direction
{
    int val=abs((int) floor(((direction/22.5)+.5)));
    return [compassBearings objectAtIndex:val];
}

@end
