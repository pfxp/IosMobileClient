//
//  Map.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 9/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Map.h"

@implementation Map

- (id) initWithDisplayName:(NSString *)displayName
{
    self = [super init];
    if (self)
    {
        self.displayName = displayName;
    }
    return self;
}


@end