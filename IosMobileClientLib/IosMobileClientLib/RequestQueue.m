//
//  RequestQueue.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 2/03/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "RequestQueue.h"
#import "IosSessionDataTask.h"

@implementation RequestQueue


-(id) initWithBaseUrl:(NSURL *)baseUrl
              session:(NSURLSession*)session;
{
    self = [super init];
    if (self)
    {
        queueLock = [[NSLock alloc] init];
        _queue = [[NSMutableArray alloc] init];
        
        [self setBaseUrl:baseUrl];
        [self setSession:session];
    }
    return self;
}

#pragma mark Queue functions.
//
// Adds a GET request to the queue.
//
-(void) pushGETRequestToQueue:(IosSessionDataTask *) request
{
    [queueLock lock];
    [_queue addObject:request];
    [queueLock unlock];
}


//
// Returns nil if the queue is empty.
//
-(IosSessionDataTask *) popGETRequestFromQueue
{
    [queueLock lock];
    
    if (_queue==nil)
    {
        [queueLock unlock];
        return nil;
    }
    if ([_queue count] == 0)
    {
        [queueLock unlock];
        return nil;
    }
    
    IosSessionDataTask *result = [_queue lastObject];
    [_queue removeLastObject];
    [queueLock unlock];
    
    return result;
}

//
// Adds a cams request
//
-(void) addRequest:(CamsWsRequest) request
{
    NSURLSessionDataTask *task = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:request
                                                                                             baseUrl:[self baseUrl]] ];
    
    IosSessionDataTask *iosDataTask = [[IosSessionDataTask alloc] initWithRequestType:request
                                                                             dataTask:task
                                                                              baseUrl:[self baseUrl]
                                                                             priority:Medium
                                                                       taskIdentifier:[task taskIdentifier]
                                                                           submitTime:[NSDate date]];
    [self pushGETRequestToQueue:iosDataTask];
}

@end
