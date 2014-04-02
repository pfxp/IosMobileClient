//
//  Controller.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Controller.h"


@implementation Controller

- (id) initWithAllValues:(BOOL)conn
             description:(NSString *)desc
                hostname:(NSString *)host
                  ctrlid:(NSNumber *)cId
                 locator:(BOOL)loc
                    name:(NSString*)nm
          controllerGuid:(NSString*)controllerGuid
{
    self = [super init];
    if (self)
    {
        _connected=conn;
        _controllerDescription=desc;
        _hostname=host;
        _ctrlId=cId;
        _locator=loc;
        _name=nm;
        _controllerGuid=controllerGuid;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"CONT Name=%@", self.name];
}

@end
