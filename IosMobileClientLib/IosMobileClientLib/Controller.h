//
//  Controller.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Controller : NSObject
@property (readonly) BOOL connected;
@property (readonly, copy) NSString *controllerDescription;
@property (readonly, copy) NSString *hostname;
@property (readonly, copy) NSNumber *ctrlId;
@property (readonly) BOOL locator;
@property (readonly, copy) NSString *name;

- (id) initWithAllValues:(BOOL)conn
             description:(NSString*)desc
                hostname:(NSString *)host
                  ctrlid:(NSNumber *)cId
                 locator:(BOOL)loc
                    name:(NSString*)nm;

- (NSString *)description;
@end
