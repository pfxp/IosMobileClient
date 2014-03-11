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

-(id) initWithRequestType:(CamsWsRequest)request
                 dataTask:(NSURLSessionDataTask *)dataTask
                  baseUrl:(NSURL *)url
                 priority:(int)priority
           taskIdentifier:(NSUInteger)taskId
               submitTime:(NSDate*) submitTime;

{
    self = [super init];
    if (self)
    {
        [self setCamsRequestType:request];
        [self setSessionDataTask:dataTask];
        [self setBaseUrl:url];
        [self setPriority:priority];
        [self setTaskIdentifier:taskId];
        [self setSubmitTime:submitTime];
        
    }
    return self;
}

// Generates a full URL for the given command.
// Returns nil if there is a problem.
// TODO Investigate what happens if users leave the trailing slash on the baseUrl
+(NSURL *) generateUrlForGetRequests:(CamsWsRequest) request
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
        case GetZoneEvents:
            return [NSURL URLWithString:[NSString stringWithFormat:@"%@/json/GetZoneEvents", baseUrl]];
            break;
        default:
            return nil;
            break;
    }
}

+(NSURL *) generateUrlForPostRequests:(CamsWsRequest)request baseUrl:(NSURL *)baseUrl arguments:(NSArray*)apnsid
{
    NSMutableString *val = [[NSMutableString alloc] init];
    
    switch (request)
    {
        case SetAPNSToken:
            if ([apnsid count] != 1)
                return nil;
            val = [NSMutableString stringWithFormat:@"%@/json/SetApnsTokenAsString?id=%@", baseUrl, apnsid[0]];
            break;
            
        case PostAcknowledgeAlarm:
            if ([apnsid count] != 1)
                return nil;
            val = [NSMutableString stringWithFormat:@"%@/json/AcknowledgeZoneEvent?id=%@", baseUrl, apnsid[0]];
            break;
        default:
            return nil;
            break;
    }
    
    return [NSURL URLWithString:val];
}

@end
