//
//  FFTViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "FFTViewController.h"

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
    //outputLabel.text = wsComms.fetchHelloWorldGreeting;    //[self fetchHelloWorldGreeting];
    wsComms.asyncTest;
}

- (IBAction) camsButtonClicked:(id)sender
{
    NSLog(@"CAMS button pressed.");
    outputLabel.text = @"CAMS button pressed.";
    [self invokeJsonData];
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

@end
