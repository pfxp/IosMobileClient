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
        queue = [NSMutableArray new];
        _repository = [[CamsObjectRepository alloc] init];
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
                                                                                                         baseUrl:[self baseUrl]] ];
    IosSessionDataTask *getMaps = [[IosSessionDataTask alloc] initWithRequestType:GetMaps
                                                                          dataTask:getMapsDataTask
                                                                           baseUrl:[self baseUrl]];
    
    [self PushGETRequestToQueue:getContoller];
    //[self PushGETRequestToQueue:getSensors];
    //[self PushGETRequestToQueue:getZones];
    //[self PushGETRequestToQueue:getMaps];
}

//
// Do requests.
//
-(void) doRequests
{
    [queue removeAllObjects];
    [self addRequests];
    for (IosSessionDataTask* request in queue)
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
    NSLog(@"Received data.");
    
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
    
    if (data==nil)
    {
        NSLog(@"Data is nil. %@", e.description);
        return;
    }
    
    [[self repository] parseJsonDictionary:dict];
}


//Called when the data transfer is complete
//Client side errors are indicated with the error parameter
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
       if (error != nil)
        NSLog(@"Task completed with an error");
    else
        NSLog(@"Task completed successfully.");
}

#pragma mark Queue functions.
//
// Adds a GET request to the queue.
//
-(void) PushGETRequestToQueue:(IosSessionDataTask *) request
{
    [queue addObject:request];
}


//
// Returns nil if the queue is empty.
//
-(IosSessionDataTask *) PopGETRequestFromQueue
{
    if (queue==nil)
        return nil;
    if (queue.count == 0)
        return nil;
    
    IosSessionDataTask *result = [queue lastObject];
    [queue removeLastObject];
    return result;
}

@end
