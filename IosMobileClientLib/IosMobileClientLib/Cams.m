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
#import "RequestQueue.h"

@implementation Cams

-(id) initWithBaseUrl:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        _repository = [[CamsObjectRepository alloc] init];
        _dataFromWebService = [[NSMutableDictionary alloc] init];
        _camsObjectsReceived = [[NSMutableDictionary alloc] init];
        [self initializeCamsObjectsReceived];
        [self setBaseUrl:url];
        [self createSession];
        _requeustQueue = [[RequestQueue alloc] initWithBaseUrl:url session:[self session]];
        
        backgroundQueue = dispatch_queue_create("com.fftsecurity.bgqueue", NULL);
    }
    return self;
}

#pragma mark Session and data

-(void) initializeCamsObjectsReceived
{
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetControllers]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetSensors]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetZones]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetMaps]];
}

-(void) camsObjectReceived:(CamsWsRequest) request
{
    NSNumber *keyAsNumber = [NSNumber numberWithInt:request];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:YES] forKey:keyAsNumber];
    
    if (request == GetMaps)
    {
        [_delegateMapsArrived mapsArrivedFromServer];
    }
        
}

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
// Performs the following startup requests in the background queue.
//      * addConfigurationRequests
//      * addAlarmsRequests
//      * executeRequests
//
-(void) startup
{
    dispatch_async(backgroundQueue, ^(void) {
        [self addConfigurationRequests];
    });
    
    dispatch_async(backgroundQueue, ^(void) {
        [self addAlarmsRequests];
    });
    
    dispatch_async(backgroundQueue, ^(void) {
        [self executeRequests];
    });
    
}
//
// Add requests to get the controllers, sensors, zones and maps.
//
-(void) addConfigurationRequests
{
    [_requeustQueue addRequest:GetControllers];
    [_requeustQueue addRequest:GetSensors];
    [_requeustQueue addRequest:GetZones];
    [_requeustQueue addRequest:GetMaps];
 }


//
// Add requests to get alarms.
-(void) addAlarmsRequests
{
    [_requeustQueue addRequest:GetZoneEvents];
    [_requeustQueue addRequest:GetLaserAlarms];
    [_requeustQueue addRequest:GetSystemAlarms];
}


//
// Do requests.
//
-(void) executeRequests
{
    IosSessionDataTask *task;
    while ((task = [_requeustQueue popGETRequestFromQueue]) != nil)
    {
        [task.sessionDataTask resume];
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
    [self joinTogetherWsData:[dataTask taskIdentifier]  data:data];
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
        
        CamsWsRequest camsItemsRetrieved = [[self repository] parseJsonDictionary:dict];
        [self camsObjectReceived:camsItemsRetrieved];
    }
}


#pragma mark WS response functions.
//
// Data comes back from WebService in pieces. This function concatenates the NSData.
//
-(void) joinTogetherWsData:(NSUInteger)taskId  data:(NSData*)data
{
    NSNumber *key = [[NSNumber alloc] initWithUnsignedInteger:taskId];
    NSMutableData *existingData = [_dataFromWebService objectForKey:key];
    
    if (existingData==nil)
    {
        NSMutableData *firstdata = [[NSMutableData alloc] init];
        [firstdata appendData:data];
        [_dataFromWebService setObject:firstdata forKey:key];
    }
    else
    {
        [existingData appendData:data];
    }
}


#pragma mark APNS functions.
//
// TODO use the queue mechanism
//
-(void) registerApnsToken:(NSString *) token
{
    NSArray *array = [[NSArray alloc] initWithObjects:token, nil];
    NSURL *url = [IosSessionDataTask generateUrlForPostRequests:PostAPNSToken baseUrl:[self baseUrl] arguments:array];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *postDataTask = [_session dataTaskWithRequest:request];
    [postDataTask resume];
}


//
// TODO Use the queue mecahnism
//
-(void) acknowledgeAlarm:(NSNumber *) eventId
{
    NSArray *array = [[NSArray alloc] initWithObjects:eventId, nil];
    NSURL *url = [IosSessionDataTask generateUrlForPostRequests:PostAcknowledgeAlarm baseUrl:[self baseUrl] arguments:array];
    
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
    [self addAlarmsRequests];
    [self executeRequests];
}

@end
