//
//  DashboardViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "DashboardViewController.h"
#import "IosMobileClientLib/Cams.h"

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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];
    
    cell.textLabel.text = @"Zone alarm in north";
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


@end
