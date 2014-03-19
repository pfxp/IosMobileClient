//
//  GlobalSettings.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "GlobalSettings.h"

@implementation  GlobalSettings

+(NSString *) alarmTypeAsString:(NSUInteger *)alarmType
{
    return @"Unknown";
    /*
    switch (alarmType)
    {
        case 1:
        {
            return @"1";
            break;
        }
        default:
        {
            return @"Unknown";
            break;
        }
    }
     */
}

@end
