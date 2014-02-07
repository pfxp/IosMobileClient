//
//  WebServiceComms.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

// Performs asynchronous communicates with the web service

#import "WebServiceComms.h"
#import "GlobalSettings.h"

@implementation WebServiceComms

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.helloWorldUrl = @"http://rest-service.guides.spring.io/greeting";
        asyncTimeoutInSec = 20.0;
        finishedRequest=TRUE;
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
    
    NSLog(@"About to process JSON dictionary.");

    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:httpResponseData   options:NSJSONReadingMutableContainers  error:&e];
    NSArray *jsonArray = [dict objectForKey:@"GetAllControllersResult"];
    
    if (!jsonArray)
    {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else
    {
        for (NSDictionary *item in jsonArray)
        {
            NSString *connected = [item objectForKey:@"Connected"];
            NSString *description = [item objectForKey:@"Description"];
            NSString *hostname = [item objectForKey:@"Hostname"];
            NSString *idString = [item objectForKey:@"Id"];
            NSString *isLocator = [item objectForKey:@"Locator"];
            NSString *name = [item objectForKey:@"Name"];
            
            //BOOL connectedAsBool = [connected boolValue];
            //NSNumber *idNumber = [NSNumber numberWithInteger:[idString integerValue]];
            //BOOL locatorAsBool = [isLocator boolValue];
            
            //Controller *controller = [[Controller alloc] initWithAllValues:connectedAsBool description:description hostname:hostname
            //                                                        ctrlid:idNumber locator:locatorAsBool name:name];
            
            
            NSLog(@"%@, %@,%@,%@,%@,%@,", connected, description, hostname, idString, isLocator, name);
            //NSLog(@"CONT: %@", controller);
            
        }
    }
    
    
    finishedRequest=true;
}

// The request has failed for some reason!
// Check the error var
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
}

// tests the hello worls
- (void) asyncTest
{
    NSURL *url = [NSURL URLWithString:self.helloWorldUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:asyncTimeoutInSec];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
            url = [NSURL URLWithString:@"http://10.0.0.74:4567/RestService.svc/json/GetAllControllers"];
            break;
        case GetSensors:
            url = [NSURL URLWithString:@"http://10.0.0.74:4567/RestService.svc/json/GetAllSensors"];
            break;
        case GetZones:
            url = [NSURL URLWithString:@"http://10.0.0.74:4567/RestService.svc/json/GetAllZones"];
            break;
        default:
            return;
            break;
    }
    
    NSLog(@"Calling URL: %@", url);
    
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed  timeoutInterval:asyncTimeoutInSec];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
