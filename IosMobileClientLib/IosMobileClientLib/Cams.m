//
//  Cams.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Cams.h"
#import "GlobalSettings.h"
#import "CamsObjectRepository.h"
#import "IosSessionDataTask.h"

@implementation Cams

-(id) initWithBaseUrl:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        _queue = [[NSMutableArray alloc] init];
        _repository = [[CamsObjectRepository alloc] init];
        _dataFromWebService = [[NSMutableDictionary alloc] init];
        [self setBaseUrl:url];
        [self createSession];
    }
    return self;
}

#pragma mark Session and data
//
// Create the NSURLSession
//
-(void) createSession
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    [sessionConfig setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [sessionConfig setTimeoutIntervalForRequest:10.0];
    [sessionConfig setTimeoutIntervalForResource:30.0];
    [sessionConfig setHTTPMaximumConnectionsPerHost:1];
    
    _session = [NSURLSession sessionWithConfiguration:sessionConfig
                                             delegate:self
                                        delegateQueue:[NSOperationQueue mainQueue]];
    }

//
// Add requests to get the controllers, sensors, zones and maps.
//
-(void) addRequests
{
    NSURLSessionDataTask *getControllersDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetControllers
                                                                                                               baseUrl:[self baseUrl]] ];
    IosSessionDataTask *getContoller = [[IosSessionDataTask alloc] initWithRequestType:GetControllers
                                                                              dataTask:getControllersDataTask
                                                                               baseUrl:[self baseUrl]];
    
    NSURLSessionDataTask *getSensorsDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetSensors
                                                                                                           baseUrl:[self baseUrl]] ];
    IosSessionDataTask *getSensors = [[IosSessionDataTask alloc] initWithRequestType:GetSensors
                                                                            dataTask:getSensorsDataTask
                                                                             baseUrl:[self baseUrl]];
    
    NSURLSessionDataTask *getZonesDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetZones
                                                                                                         baseUrl:[self baseUrl]] ];
    IosSessionDataTask *getZones = [[IosSessionDataTask alloc] initWithRequestType:GetZones
                                                                          dataTask:getZonesDataTask
                                                                           baseUrl:[self baseUrl]];
    
    NSURLSessionDataTask *getMapsDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetMaps
                                                                                                        baseUrl:[self baseUrl]]];
    IosSessionDataTask *getMaps = [[IosSessionDataTask alloc] initWithRequestType:GetMaps
                                                                         dataTask:getMapsDataTask
                                                                          baseUrl:[self baseUrl]];
    
    
    NSURLSessionDataTask *getZoneEventsDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetZoneEvents
                                                                                                        baseUrl:[self baseUrl]]];
    IosSessionDataTask *getZoneEvents = [[IosSessionDataTask alloc] initWithRequestType:GetZoneEvents
                                                                         dataTask:getZoneEventsDataTask
                                                                          baseUrl:[self baseUrl]];
    
    
    [self pushGETRequestToQueue:getContoller];
    [self pushGETRequestToQueue:getSensors];
    [self pushGETRequestToQueue:getZones];
    [self pushGETRequestToQueue:getMaps];
    [self pushGETRequestToQueue:getZoneEvents];
}


//
// Do requests.
//
-(void) doRequests
{
    [_queue removeAllObjects];
    [self addRequests];
    for (IosSessionDataTask* request in _queue)
        [request.sessionDataTask resume];
}

#pragma mark NSUrlSessionDelegate methods
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"download task");
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%f / %f", (double)totalBytesWritten,
          (double)totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"didBecomeInvalidWithError");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"didReceiveChallenge");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}

#pragma mark NSUrlSessionDataDelegate methods
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"Became download task.");
}

// Called when a request is finished.
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self addData:[dataTask taskIdentifier]  data:data];
}

//
// Adds data to the queue
//
-(void) addData:(NSUInteger)taskId  data:(NSData*)data
{
    NSNumber *key = [[NSNumber alloc] initWithUnsignedInteger:taskId];
    NSMutableData *val = [_dataFromWebService objectForKey:key];
    
    if (val==nil)
    {
        NSMutableData *firstdata = [[NSMutableData alloc] init];
        [firstdata appendData:data];
        [_dataFromWebService setObject:firstdata forKey:key];
        
    }
    else
    {
        [val appendData:data];
    }
  }


//Called when the data transfer is complete
//Client side errors are indicated with the error parameter
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil)
    {
        NSLog(@"Task completed with an error");
    }
    else
    {
        NSNumber *key = [[NSNumber alloc] initWithUnsignedInteger:[task taskIdentifier]];
        NSMutableData *data = [_dataFromWebService objectForKey:key];
        
        if (data==nil)
            return;
        
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&e];
        
        [[self repository] parseJsonDictionary:dict];
    }
}


#pragma mark Queue functions.
//
// Adds a GET request to the queue.
//
-(void) pushGETRequestToQueue:(IosSessionDataTask *) request
{
    [_queue addObject:request];
}


//
// Returns nil if the queue is empty.
//
-(IosSessionDataTask *) popGETRequestFromQueue
{
    if (_queue==nil)
        return nil;
    if ([_queue count] == 0)
        return nil;
    
    IosSessionDataTask *result = [_queue lastObject];
    [_queue removeLastObject];
    return result;
}

#pragma mark APNS functions.
//
// TODO use the queue mechanism
//
-(void) registerApnsToken:(NSString *) token
{
    NSURL *url = [IosSessionDataTask generateUrlForApnsRequest:SetAPNSToken baseUrl:[self baseUrl] apnsid:token];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [_session dataTaskWithRequest:request];
    [postDataTask resume];
}

//
// Retrieve the alarms.
//
-(void) getAlarms
{
    NSURLSessionDataTask *getZoneEventsDataTask = [_session dataTaskWithURL:[IosSessionDataTask generateUrlForRequest:GetZoneEvents
                                                                                                              baseUrl:[self baseUrl]]];
    [getZoneEventsDataTask resume];
}

@end
