//
//  Cams.m
//  IosMobileClientLib
//
//  Created by Peter Pellegrini on 21/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "Cams.h"
#import "GlobalSettings.h"


@implementation Cams 

-(id) init
{
    self = [super init];
    
    if (self)
    {
        _controllersUrl = @"http://10.0.0.74:4567/RestService.svc/json/GetAllControllers";
        //repository = [[CamsObjectRepository alloc] init];
        [self start];
    }
    return self;
}


-(void) start
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
    [sessionConfig setRequestCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [sessionConfig setTimeoutIntervalForRequest:10.0];
    
    //sessionConfig.timeoutIntervalForRequest = 10.0;
    sessionConfig.timeoutIntervalForResource = 30.0;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    

    _session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];

}

-(void) GetControllers
{
        NSURLSessionDownloadTask *getImageTask = [_session downloadTaskWithURL:[NSURL URLWithString:_controllersUrl]];
    [getImageTask resume];
}

-(void) GetControllers2
{
    NSURLSessionDataTask *dataTask = [_session dataTaskWithURL:[NSURL URLWithString:_controllersUrl] ];
    [dataTask resume];
    
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

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // Handle data here.
    NSLog(@"Received data.");
    
    
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers  error:&e];
    
    
    //[repository parseJsonDictionary:dict command:GetControllers];
    int k=0;
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //Called when the data transfer is complete
    //Client side errors are indicated with the error parameter
    
    
}

/*
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"Received response.");
    
}
*/

/*
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSLog(@"Cached response.");
}
*/


@end
