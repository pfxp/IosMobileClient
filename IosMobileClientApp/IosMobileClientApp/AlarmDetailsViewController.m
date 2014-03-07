//
//  AlarmDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "AlarmDetailsViewController.h"
#import "IosMobileClientLib/ZoneEvent.h"

@interface AlarmDetailsViewController ()

@end

@implementation AlarmDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    perimeterLabel.text = [[NSNumber numberWithDouble:[_zoneEvent perimeterDistance]] stringValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidCancel:self];
}

- (IBAction)acknowledge:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidAcknowledge:self];
}

- (IBAction)goToMap:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidGoToMap:self];
}

@end
