//
//  WebServiceComms.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

// Performs asynchronous communicates with the web service

#import "WebServiceComms.h"
#import "IosMobileClientLib/GlobalSettings.h"

@implementation WebServiceComms

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.helloWorldUrl = @"http://rest-service.guides.spring.io/greeting";
        asyncTimeoutInSec = 20.0;
        finishedRequest=TRUE;
        repository = [[CamsObjectRepository alloc] init];
        baseUrl = @"http://192.168.66.107:4567/RestService.svc";
    }
    return self;
}


// A response has been received, this is where we initialize the instance var you created
// so that we can append data to it in the didReceiveData method
// Furthermore, this method is called each time there is a redirect so reinitializing it
// also serves to clear it
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
       httpResponseData = [[NSMutableData alloc] init];
}


// Append the new data to the instance variable you declared
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [httpResponseData appendData:data];
}


// Return nil to indicate not necessary to store a cached response for this connection
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
        return nil;
}


// The request is complete and data has been received
// You can parse the stuff in your instance variable now
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (httpResponseData.length <= 0 )
    {
        finishedRequest=true;
        return;
    }
    
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:httpResponseData  options:NSJSONReadingMutableContainers  error:&e];
   
    [repository parseJsonDictionary:dict command:_currentRequest];
    finishedRequest=true;
}

// The request has failed for some reason!
// Check the error var
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
}

//
// Does an HTTP request on a very simple web service.
- (NSString *)fetchHelloWorldGreeting
{
    __block NSString *results;
    
    NSURL *url = [NSURL URLWithString:@"http://rest-service.guides.spring.io/greeting"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             
             
             NSString *idValue = [[greeting objectForKey:@"id"] stringValue];
             NSString *content = [greeting objectForKey:@"content"];
             results = [NSString stringWithFormat:@"ID: %@ Content: %@", idValue, content];
             NSLog(@"%@",results);
         }
     }];
    
    return results;
}

// Calls CAMS web service methods.
- (void) callCamsWsMethod:(CamsWsRequent) command
{
    NSURL *url;
    NSMutableURLRequest *request;
    
    if (!finishedRequest)
    {
        NSLog(@"Have not finished request");
    }
    
    finishedRequest=false;
    self.currentRequest = command;
    
    switch (command)
    {
        case GetControllers:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllControllers", baseUrl]];
            break;
        case GetSensors:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllSensors", baseUrl]];
            break;
        case GetZones:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllZones", baseUrl]];
            break;
        default:
            return;
            break;
    }
    
    //NSLog(@"Calling URL: %@", url);
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed  timeoutInterval:asyncTimeoutInSec];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
