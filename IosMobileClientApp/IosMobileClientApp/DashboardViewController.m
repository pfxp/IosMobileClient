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
#import "IosMobileClientLib/LaserAlarm.h"
#import "IosMobileClientLib/SystemAlarm.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setHasZoneEventsSection:NO];
    [self setHasLaserAlarmsSection:NO];
    [self setHasSystemAlarmsSection:NO];
    [self setNumSections:0];
    _sectionsToDisplay = [[NSMutableArray alloc] init];
    _rowsInSection = [[NSMutableArray alloc] init];
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource protocol
// Returns the number of sections.
// Section 1: Zone events.
// Section 2: Laser alarms.
// Section 3: System alarms.
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self calculateSections];
    return [self numSections];
}


//
// Works out how many sections are
-(void) calculateSections
{
    int numZoneEvents, numLaserAlarms, numSystemAlarms;
    
    numZoneEvents = [[[_cams repository] zoneEvents] count];
    numLaserAlarms = [[[_cams repository] laserAlarms] count];
    numSystemAlarms = [[[_cams repository] systemAlarms] count];
    
    [self setHasZoneEventsSection:(numZoneEvents > 0)];
    [self setHasLaserAlarmsSection:(numLaserAlarms > 0)];
    [self setHasSystemAlarmsSection:(numSystemAlarms > 0)];
    
    [self setNumSections:0];
    [[self sectionsToDisplay] removeAllObjects];
    
    if ([self hasZoneEventsSection])
    {
        self.numSections++;
        NSNumber *sect = [[NSNumber alloc] initWithInteger:IntrusionSection];
        [[self sectionsToDisplay] addObject:sect];
        
        NSNumber *num =[[NSNumber alloc] initWithInt:numZoneEvents];
        [[self rowsInSection] addObject:num];
    }
    
    if ([self hasLaserAlarmsSection])
    {
        self.numSections++;
        NSNumber *sect = [[NSNumber alloc] initWithInteger:LaserAlarmSection];
        [[self sectionsToDisplay] addObject:sect];
        
        NSNumber *num =[[NSNumber alloc] initWithInt:numLaserAlarms];
        [[self rowsInSection] addObject:num];
    }
    
    if ([self hasSystemAlarmsSection])
    {
        self.numSections++;
        NSNumber *sect = [[NSNumber alloc] initWithInteger:SystemAlarmSection];
        [[self sectionsToDisplay] addObject:sect];
        
        NSNumber *num =[[NSNumber alloc] initWithInt:numSystemAlarms];
        [[self rowsInSection] addObject:num];
        
    }
}

//
// Number of rows in each section.
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= [[self rowsInSection] count])
        return 0;
    
    return [[[self rowsInSection] objectAtIndex:section] integerValue];
}

//
// Sets the title title text
//sectionName = NSLocalizedString(@"mySectionName", @"mySectionName");
//
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section >= [[self sectionsToDisplay] count])
        return nil;
    
    NSNumber *sect = [[self sectionsToDisplay] objectAtIndex:section];
    AlarmSection alarmSection = (AlarmSection) [sect integerValue];
    
    NSString *sectionName;
    switch (alarmSection)
    {
        case IntrusionSection:
            sectionName = @"Intrusions";
            break;
        case LaserAlarmSection:
            sectionName = @"Laser Alarms";
            break;
        case SystemAlarmSection:
            sectionName = @"System Alarms";
            break;
        default:
            sectionName = nil;
            break;
    }
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSNumber *sect = [[self sectionsToDisplay] objectAtIndex:section];
    AlarmSection alarmSection = (AlarmSection) [sect integerValue];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntrusionAlarmCell"];
    
    switch (alarmSection)
    {
        case IntrusionSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"IntrusionAlarmCell"];
            
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
            break;
        }
            
        case LaserAlarmSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LaserAlarmCell"];
            laserAlarm = [self.cams.repository getLaserAlarmOrderedByTimeDesc:row];
            if (laserAlarm==nil)
            {
                cell.textLabel.text = @"Error";
                cell.detailTextLabel.text = @"Error";
                return cell;
            }
            
            if ([[laserAlarm sensorIds] count] == 0)
            {
                // This is an error condition
                cell.textLabel.text = [NSString stringWithFormat:@"Laser alarm"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Unknown sensor"];
            }
            else
            {
                NSNumber *sensorId = [[laserAlarm sensorIds] objectAtIndex:0];
                Sensor *sensor = [self.cams.repository getSensorById:sensorId];
                
                cell.textLabel.text = [NSString stringWithFormat:@"Laser alarm"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Laser alarm."];
            }
            break;
        }
            
        case SystemAlarmSection:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SystemAlarmCell"];
            systemAlarm = [self.cams.repository getSystemAlarmOrderedByTimeDesc:row];
            if (systemAlarm==nil)
            {
                cell.textLabel.text = @"Error";
                cell.detailTextLabel.text = @"Error";
                return cell;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"System alarm"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"System alarm."];
            break;
        }
            
        default:
            break;
    }
    return cell;
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
    [self calculateSections];
    [self.tableView reloadData];
}


@end
