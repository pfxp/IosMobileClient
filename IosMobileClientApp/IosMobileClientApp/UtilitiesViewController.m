//
//  FFTViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "UtilitiesViewController.h"
#import "IosMobileClientLib/Controller.h"

@interface UtilitiesViewController ()

@end

@implementation UtilitiesViewController

//
// Checks if the URL has been set.
//
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

+(NSString *) displayDictionaryAsString:(NSDictionary *) dict
{
    NSMutableString *outputText = [NSMutableString new];
    for(id key in dict)
        [outputText appendFormat:@"key=%@ val=%@\n", key, [dict objectForKey:key]];
    return outputText;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *url = [[alertView textFieldAtIndex:0] text];
    
    //NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"url_pref"];
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
    NSDictionary *controllers = [[[self cams] repository] controllers];
    outputLabel.text = [UtilitiesViewController displayDictionaryAsString:controllers];
}

// Gets the sensors from the web service.
- (IBAction) getSensorsButtonClicked:(id)sender
{
    NSDictionary *sensors = [[[self cams] repository] sensors];
    outputLabel.text = [UtilitiesViewController displayDictionaryAsString:sensors];
}

// Gets the zones from the web service.
- (IBAction) getZonesButtonClicked:(id)sender
{
    NSDictionary *zones = [[[self cams] repository] zones];
    outputLabel.text = [UtilitiesViewController displayDictionaryAsString:zones];
}

- (IBAction) getMapsButtonClicked:(id)sender
{
    NSDictionary *maps = [[[self cams] repository] maps];
    outputLabel.text = [UtilitiesViewController displayDictionaryAsString:maps];
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


- (IBAction) getZoneEventsButtonClicked:(id)sender
{
    NSDictionary *zoneEvents = [[[self cams] repository] zoneEvents];
    outputLabel.text = [UtilitiesViewController displayDictionaryAsString:zoneEvents];
}

- (IBAction) getsCamsObjectsButtonClicked:(id)sender
{
    NSLog(@"Multi button clicked.");
    [_cams doRequests];
}

@end
