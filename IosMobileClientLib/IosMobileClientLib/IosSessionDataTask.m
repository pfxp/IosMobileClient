//
//  IosSessionDataTask.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 23/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "IosSessionDataTask.h"
#import "GlobalSettings.h"

@implementation IosSessionDataTask

-(id) initWithRequestSype:(CamsWsRequest) request dataTask:(NSURLSessionDataTask *) dataTask baseUrl:(NSString *)url
{
    self = [super init];
    if (self)
    {
        self.camsRequestType = request;
        self.sessionDataTask = dataTask;
        self.baseUrl = url;
    }
    return self;
}

// Generates a full URL for the given command.
// Returns nil if there is a problem.
+(NSURL *) GetUrlSuffixForRequest:(CamsWsRequest) request
                             baseUrl:(NSString *) baseUrl;
{
    switch (request) {
        
        case GetControllers:
            return [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetControllers", baseUrl]];
            break;
        
        case GetSensors:
            return [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/AllSensors", baseUrl]];
            break;
        
        case GetZones:
            return [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetZones", baseUrl]];
            break;
        
        case GetMaps:
            return [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetMaps", baseUrl]];
        
        default:
            return nil;
            break;
    }
}


@end
