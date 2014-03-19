//
//  AlarmDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "IntrusionViewController.h"
#import "IosMobileClientLib/Zone.h"
#import "IosMobileClientLib/ZoneEvent.h"
#import "IosMobileClientLib/LaserAlarm.h"
#import "IosMobileClientLib/SystemAlarm.h"

@interface IntrusionViewController ()

@end

@implementation IntrusionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

// TODO Set to locale specific date formatting.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"HH:mm:ss yyyy-mm-dd"];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //Optionally for time zone converstions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    zoneLabel.text = [_zone name];
    perimeterLabel.text = [[_zoneEvent perimeterDistance] stringValue];
    timeLabel.text = [formatter stringFromDate:[_zoneEvent eventTimeUtc]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlarmDetailsViewControllerDelegate functions
//
// Go back to previous scene
//
- (IBAction)back:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidGoBack:self];
}



//
// Acknowledge the intrusion
//
- (IBAction)acknowledge:(id)sender
{
       
    [self.delegate alarmDetailsViewControllerDidAcknowledge:self];
}



//
// Go to the relevant map
//
- (IBAction)goToMap:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidGoToMap:self];
}


@end
