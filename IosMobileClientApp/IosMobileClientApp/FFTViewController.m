//
//  FFTViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "FFTViewController.h"
#import "IosMobileClientLib/Controller.h"

@interface FFTViewController ()

@end

@implementation FFTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    wsComms = [[WebServiceComms alloc] init];
    outputLabel.text = wsComms.baseUrl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) helloWorldButtonClicked:(id)sender
{
    [self fetchHelloWorldGreeting];
}

// Gets the controllers from the web service.
- (IBAction) getControllersButtonClicked:(id)sender
{
    [wsComms callCamsWsMethod:GetControllers];
}

// Gets the sensors from the web service.
- (IBAction) getSensorsButtonClicked:(id)sender
{
    [wsComms callCamsWsMethod:GetSensors];
}

// Gets the zones from the web service.
- (IBAction) getZonesButtonClicked:(id)sender
{
    [wsComms callCamsWsMethod:GetZones];
}


// Gets a Hello World from a publicly availble web service.
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
             NSString *results = [NSString stringWithFormat:@"Hello World! ID: %@ Content: %@", idValue, content];
             outputLabel.text = results;
         }
     }];
}

@end
