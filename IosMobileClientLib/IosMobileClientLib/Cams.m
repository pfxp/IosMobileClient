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
        _repository = [[CamsObjectRepository alloc] init];
        queue = [NSMutableArray new];
        [self setBaseUrl:url];
        [self createSession];
        [self addRequests];
    }
    return self;
}


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

// Create the NSURLSession
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

// Add requests to get the controllers, sensors, zones and maps.
-(void) addRequests
{
    NSURL *getControllersUrl = (NSURL *) [IosSessionDataTask generateUrlForRequest:GetControllers baseUrl:[self baseUrl]];
    
    NSURLSessionDataTask *getControllersDataTask = [_session dataTaskWithURL:getControllersUrl ];
    
    
    IosSessionDataTask *getContoller = [[IosSessionDataTask alloc] initWithRequestType:GetControllers
                                                                              dataTask:getControllersDataTask
                                                                               baseUrl:[self baseUrl]];
    
    
    [ self PushGETRequestToQueue:getContoller];
    //[getControllersDataTask resume];
    
    //NSURL *u2 = (NSURL *) [IosSessionDataTask generateUrlForRequest:GetSensors baseUrl:[self baseUrl]];
    //NSURLSessionDataTask *dataTask2 = [_session dataTaskWithURL:[u2 absoluteURL] ];
    //IosSessionDataTask *getSensor = [[IosSessionDataTask alloc] initWithRequestType:GetSensors dataTask:dataTask2 baseUrl:[self baseUrl]];
    //[ self PushGETRequestToQueue:getSensor];
    //[dataTask2 resume];
  
    //NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:[NSURL URLWithString:@"http://peterpc.fft.local:4567/RestService.svc/json/GetControllers"] ];
    //[dataTask resume];
}

// Do requests.
-(void) doRequests
{
    NSLog(@"doRequests called.");
    for (IosSessionDataTask* request in queue)
    {
        NSLog(@"Processing request.");
        [request.sessionDataTask resume];
    }
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
    
    IosSessionDataTask *first = [self PopGETRequestFromQueue];
    
    [self.repository parseJsonDictionary:dict];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //Called when the data transfer is complete
    //Client side errors are indicated with the error parameter
    NSLog(@"task completed.");
}


@end
