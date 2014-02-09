//
//  Zone.h
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject
@property (readwrite) NSNumber *zoneId;
@property (readwrite) NSString *name;
@property (readwrite) NSString *description;
@property (readwrite) NSArray *points;
@end
