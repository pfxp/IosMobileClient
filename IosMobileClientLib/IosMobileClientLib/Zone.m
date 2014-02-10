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
                 name:(NSString *)name
          description:(NSString *)desc
{
    self = [super init];
    
    if (self)
    {
        self.zoneId = zid;
        self.name = name;
        self.description=desc;
    }
    return self;
}

@end
