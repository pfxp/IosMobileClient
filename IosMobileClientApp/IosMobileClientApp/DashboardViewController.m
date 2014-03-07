//
//  DashboardViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "DashboardViewController.h"
#import "IosMobileClientLib/Cams.h"
#import "IosMobileClientLib/Zone.h"b
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
    int section = indexPath.section;
    int row = indexPath.row;
    
       /*
      
    
    for (ZoneEvent *event in mutableIntrusions)
    {
        //ZoneEvent *zoneEvent = [[self.cams.repository.zoneEvents objectForKey:key]];
        
    }
    
   // self.cams.repository.zoneEvents
    */
    
    ZoneEvent *event = [self.cams.repository getZoneEventOrderedByTimeDesc:row];
    if (event==nil)
    {
        cell.textLabel.text = @"Error";
        cell.detailTextLabel.text = @"Error";
        return cell;
    }
    
    int zoneId = [event zoneId];
    NSNumber *zoneIdInt = [[NSNumber alloc] initWithInt:zoneId];
    Zone *zone = [self.cams.repository getZoneById:zoneIdInt];
    
    NSString *zoneName = [zone name];
    cell.textLabel.text = [NSString stringWithFormat:@"Zone alarm in %@", zoneName];
    cell.detailTextLabel.text = @"Perimeter distance 30m.";
    return cell;
}

//
// Draws the alarms in the Cams object.
//
-(void) drawAlarms
{
    
}

#pragma mark AlarmDetailsViewControllerDelegate
- (void)alarmDetailsViewControllerDidAcknowledge:(AlarmDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alarmDetailsViewControllerDidGoToMap:(AlarmDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayAlarm"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        AlarmDetailsViewController *alarmDetailsViewController = [navigationController viewControllers][0];
        
        alarmDetailsViewController.delegate = self;
        //mapDetailsViewController.map = [self.maps objectAtIndex:indexPath.row];
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
