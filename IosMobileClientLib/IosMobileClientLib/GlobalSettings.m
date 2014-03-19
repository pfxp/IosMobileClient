//
//  GlobalSettings.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "GlobalSettings.h"

@implementation  GlobalSettings


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

@end
