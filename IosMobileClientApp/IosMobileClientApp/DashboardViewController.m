//
//  DashboardViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "DashboardViewController.h"
#import "IosMobileClientLib/Cams.h"
#import "IosMobileClientLib/Zone.h"
#import "IosMobileClientLib/ZoneEvent.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self drawAlarms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol
// Returns the number of rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [[[_cams repository] zoneEvents] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
    //int section = indexPath.section;
    int row = indexPath.row;
    
    event = [self.cams.repository getZoneEventOrderedByTimeDesc:row];
    if (event==nil)
    {
        cell.textLabel.text = @"Error";
        cell.detailTextLabel.text = @"Error";
        return cell;
    }
    
    Zone *zone = [self.cams.repository getZoneById:[event zoneId]];
    
    NSString *zoneName = [zone name];
    cell.textLabel.text = [NSString stringWithFormat:@"Zone alarm in %@", zoneName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Perimeter distance %dm.", [[event perimeterDistance] intValue]];
    return cell;
}

//
// Draws the alarms in the Cams object.
//
-(void) drawAlarms
{
    
}

#pragma mark AlarmDetailsViewControllerDelegate
- (void)alarmDetailsViewControllerDidCancel:(AlarmDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alarmDetailsViewControllerDidAcknowledge:(AlarmDetailsViewController *)controller
{
    NSUserDefaults *standaloneUserDefaults = [NSUserDefaults standardUserDefaults];
    BOOL confirmAck = [standaloneUserDefaults boolForKey:@"confirm_ack_pref"];
    if (confirmAck)
    {
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                            message:@"Are you sure you want to acknowledge the alarm?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed cancel");
    }
    else
    {
        NSLog(@"user pressed ok");
        [self.cams acknowledgeAlarm:[event eventId]];
        [self.cams getAlarms];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)alarmDetailsViewControllerDidGoToMap:(AlarmDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayAlarm"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        AlarmDetailsViewController *alarmDetailsViewController = [navigationController viewControllers][0];
        
        alarmDetailsViewController.delegate = self;
        int row = indexPath.row;
        ZoneEvent *zoneEvent = [self.cams.repository getZoneEventOrderedByTimeDesc:row];
        Zone *zone = [self.cams.repository getZoneById:[zoneEvent zoneId]];
       
        [alarmDetailsViewController setZoneEvent:zoneEvent];
        [alarmDetailsViewController setZone:zone];
    }
}

//
// Called when the user clicks refresh
//
- (IBAction) refreshButtonClicked:(id)sender
{
    
    [self.tableView reloadData];
}


@end
