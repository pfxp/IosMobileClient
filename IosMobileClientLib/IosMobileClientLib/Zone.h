//
//  Zone.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject
@property (readwrite, copy) NSNumber *zoneId;
@property (readwrite, copy) NSString *name;
@property (readwrite, copy) NSString *description;
@property (readwrite) NSArray *points;

- (id) initWithZoneId:(NSNumber*)zid
           name:(NSString *)name
      description:(NSString *)desc;
@end
