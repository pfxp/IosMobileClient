//
//  FFTViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "FFTViewController.h"
#import "CamsObject.h"

@interface FFTViewController ()

@end

@implementation FFTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    wsComms = [[WebServiceComms alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)helloWorldButtonClicked:(id) sender{
    NSLog(@"Hello world button pressed.");
    outputLabel.text = @"Hello world button pressed.";
    
    wsComms.asyncTest;
}

- (IBAction) camsButtonClicked:(id)sender
{
    NSLog(@"CAMS button pressed.");
    outputLabel.text = @"CAMS button pressed.";
    [self invokeGetControllers];
}

- (void)fetchHelloWorldGreeting
{
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
             NSString *results = [NSString stringWithFormat:@"ID: %@ Content: %@", idValue, content];
             outputLabel.text = results;

         }
     }];
}

- (void)invokeJsonData
{
    NSURL *url = [NSURL URLWithString:@"http://10.0.0.74:4567/RestService.svc/json/JSONData?id=123"];
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
             
             
             NSString *result = [greeting objectForKey:@"JSONDataResult"];
             NSString *results = [NSString stringWithFormat:@"Result: %@", result];
             outputLabel.text = results;
             
         }
     }];
}

- (void)invokeGetControllers
{
    NSURL *url = [NSURL URLWithString:@"http://10.0.0.74:4567/RestService.svc/json/GetAllControllers"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSError *e = nil;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&e];
             
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
                     
                     BOOL connectedAsBool = [connected boolValue];
                     NSNumber *idNumber = [NSNumber numberWithInteger:[idString integerValue]];
                     BOOL locatorAsBool = [isLocator boolValue];

                     Controller *controller = [[Controller alloc] initWithAllValues:connectedAsBool description:description hostname:hostname
                                                                                   ctrlid:idNumber locator:locatorAsBool name:name];
                     
                     
                     //NSLog(@"%@, %@,%@,%@,%@,%@,", connected, description, hostname, idString, isLocator, name);
                     NSLog(@"CONT: %@", controller);
                                          
                 }
             }
         }
     }];
}


// Gets the controllers from the web service.
- (IBAction) getControllersButtonClicked:(id)sender
{
    NSLog(@"Get Controllers button clicked.");
    [wsComms callCamsWsMethod:GetControllers];
}

@end
