//
//  Controller.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Controller.h"


@implementation Controller

- (id) initWithAllValues:(BOOL)conn description:(NSString *)desc hostname:(NSString *)host
                  ctrlid:(NSNumber *)cId locator:(BOOL)loc name:(NSString*)nm
{
    self = [super init];
    if (self)
    {
        [self setConnected:conn];
        [self setControllerDescription:desc];
        [self setHostname:host];
        [self setCtrlId:cId];
        [self setLocator:loc];
        [self setName:nm];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" Name=%@ Desc=%@ Conn=%@ Hostname=%@ CtrlID=%@ Locator=%@", self.name, self.controllerDescription, self.connected ? @"YES" : @"NO",
            self.hostname, self.ctrlId, self.locator ? @"YES" : @"NO"];
}

- (void) doSomething
{
    
}

@end
