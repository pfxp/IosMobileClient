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

-(id) initWithRequestType:(CamsWsRequest)request dataTask:(NSURLSessionDataTask *)dataTask baseUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        [self setCamsRequestType:request];
        [self setSessionDataTask:dataTask];
        [self setBaseUrl:url];
    }
    return self;
}

// Generates a full URL for the given command.
// Returns nil if there is a problem.
// TODO Investigate what happens if users leave the trailing slash on the baseUrl
+(NSURL *) generateUrlForRequest:(CamsWsRequest) request
                             baseUrl:(NSURL *) baseUrl;
{
    switch (request) {
        
        case GetControllers:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/json/GetControllers", baseUrl]];
            break;
        
        case GetSensors:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/json/GetSensors", baseUrl]];
            break;
        
        case GetZones:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/json/GetZones", baseUrl]];
            break;
        
        case GetMaps:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/json/GetMaps", baseUrl]];
            break;
            
        default:
            return nil;
            break;
    }
}

+(NSURL *) generateUrlForApnsRequest:(CamsWsRequest)request baseUrl:(NSURL *)baseUrl apnsid:(NSString*)apnsid
{
    NSString *val = [NSString stringWithFormat:@"%@/json/SetApnsTokenAsString?id=%@", baseUrl, apnsid];
    NSURL *result = [NSURL URLWithString:val];
    return result;
}

@end
