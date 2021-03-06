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

-(id) initWithUrls:(NSDictionary *)urls
{
    self = [super init];
    
    if (self)
    {
        _repository = [[CamsObjectRepository alloc] init];
        _dataFromWebService = [[NSMutableDictionary alloc] init];
        _camsObjectsReceived = [[NSMutableDictionary alloc] init];
        _urls = urls;
        
        NSURL *url = [_urls objectForKey:@"pref_server_1"];
        
        [self initializeCamsObjectsReceived];
        [self setBaseUrl:url];
        [self createSession];
        
        _requeustQueue = [[RequestQueue alloc] initWithBaseUrl:url session:[self session]];
        backgroundQueue = dispatch_queue_create("com.fftsecurity.bgqueue", NULL);
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

#pragma mark Session and data
//
// Initially no CAMS objects have been received.
//
-(void) initializeCamsObjectsReceived
{
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetControllers]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetSensors]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetZones]];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:GetMaps]];
}


//
// Keeps a record of which CAMS objects have been received.
//
-(void) camsObjectReceived:(CamsWsRequest) request
{
    NSNumber *keyAsNumber = [NSNumber numberWithInt:request];
    [_camsObjectsReceived setObject:[NSNumber numberWithBool:YES] forKey:keyAsNumber];
}

//
// Returns true if the CAMS object has been received.
//
-(BOOL) hasCamsObjectBeenReceived:(CamsWsRequest) request
{
    return ([_camsObjectsReceived objectForKey:[NSNumber numberWithInt:request]] != nil);
}

//
// Create the NSURLSession
// TODO Remove the hardcoded username and password.
//
-(void) createSession
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
   
    
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", @"test", @"test"];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];
    NSString *userAgentString = @"IosMobileClientApp/com.fftsecurity";
    
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json",
                                              @"Authorization": authString,
                                              @"User-Agent": userAgentString}];
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
// Start receiving updates using the Standard Location Service.
// TODO In release mode, reduce the accuracy.
//
-(void) startStandardLocationService
{
    if (_locationManager == nil)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set movement threshold for new event
    _locationManager.distanceFilter = 200;
    
    [_locationManager startUpdatingLocation];
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

//
// Called when using HTTPS

//
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"didReceiveChallenge called. Using HTTPS.");
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    
    // TODO Very dangerous. I am accepting a self-signed certificate from my development computer.
    /*
     if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
     {
         NSString *host = challenge.protectionSpace.host;
        if([challenge.protectionSpace.host isEqualToString:@"peterpc.fft.local"] || [challenge.protectionSpace.host isEqualToString:@"ghost"]
           || [challenge.protectionSpace.host isEqualToString:@"10.0.0.62"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
     */
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

#pragma mark Standard Location service delegate functions
//
// Get location updates.
//
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    int locationCount = [locations count];
    if (locationCount==0)
        return;
    
    CLLocation *loc =[locations objectAtIndex:locationCount-1];
    [self setCurrentLocation:loc];
}

@end

