//
//  Zone.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject

@property (readonly, copy) NSNumber *zoneId;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *zoneDescription;
@property (readwrite, strong) NSArray *points;

- (id) initWithZoneId:(NSNumber*)zid
                 name:(NSString *)name
          zoneDescription:(NSString *)desc;

- (NSString *)description;

@end
