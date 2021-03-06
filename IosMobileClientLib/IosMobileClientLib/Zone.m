//
//  Zone.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Zone.h"

@implementation Zone

- (id) initWithZoneId:(NSNumber*)zid
             zoneGuid:(NSString*)zoneGuid
                 name:(NSString *)name
          zoneDescription:(NSString *)desc
{
    self = [super init];
    
    if (self)
    {
        _zoneId = zid;
        _zoneGuid=zoneGuid;
        _name = name;
        _zoneDescription=desc;
    }
    return self;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"ZONE: Name: %@,  Desc: %@", [self name], [self zoneDescription]];
}

@end
