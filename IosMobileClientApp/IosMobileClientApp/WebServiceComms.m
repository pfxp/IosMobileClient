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

// TODO Check for when the URL is invalid.
- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:@"url_pref"];
        NSLog(@"Base url=%@", self.baseUrl);
        helloWorldUrl = @"http://rest-service.guides.spring.io/greeting";
        asyncTimeoutInSec = 20.0;
        finishedRequest=TRUE;
        repository = [[CamsObjectRepository alloc] init];
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
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllControllers", self.baseUrl]];
            break;
        case GetSensors:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllSensors", self.baseUrl]];
            break;
        case GetZones:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllZones", self.baseUrl]];
            break;
        case GetMaps:
            url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/json/GetAllMaps", self.baseUrl]];
            break;
        default:
            return;
            break;
    }
    
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:asyncTimeoutInSec];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    #pragma unused (conn)
}


- (void) setAPNSTokenOnWebService:(NSString *)token
{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/xml/SetApnsTokenAsString?id=%@", self.baseUrl, token]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    NSString *res = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

// 
- (void) setAPNSTokenOnWebServiceAsStream:(NSString *)token
{
    NSLog(@"setAPNSTokenToWebService2 called.");
    NSData *postData = [token dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/xml/SetApnsTokenAsStream", self.baseUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&error];
    
    // Construct a String around the Data from the response
    NSString *res = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

@end
