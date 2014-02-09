//
//  Controller.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controller : NSObject
@property (readwrite) BOOL connected;
@property (readwrite, copy) NSString *controllerDescription;
@property (readwrite, copy) NSString *hostname;
@property (readwrite) NSNumber *ctrlId;
@property (readwrite) BOOL locator;
@property (readwrite, copy) NSString *name;

- (id) initWithAllValues:(BOOL)conn
             description:(NSString*)desc
                hostname:(NSString *)host
                  ctrlid:(NSNumber *)cId
                 locator:(BOOL)loc
                    name:(NSString*)nm;

- (NSString *)description;
- (void) doSomething;
@end
