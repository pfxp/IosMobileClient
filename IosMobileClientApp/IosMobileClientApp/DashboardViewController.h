//
//  DashboardViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntrusionViewController.h"
#import "SystemAlarmViewController.h"
#import "LaserAlarmViewController.h"

@class Cams;

@interface DashboardViewController : UITableViewController <IntrusionDetailsViewControllerDelegate, UIAlertViewDelegate>
{
    ZoneEvent *event;
    LaserAlarm *laserAlarm;
    SystemAlarm *systemAlarm;
}

@property (readwrite, weak) Cams *cams;
@property (readwrite) BOOL hasZoneEventsSection;
@property (readwrite) BOOL hasLaserAlarmsSection;
@property (readwrite) BOOL hasSystemAlarmsSection;
@property (readwrite) int numSections;
@property (readwrite) NSMutableArray *sectionsToDisplay;
@property (readwrite) NSMutableArray *rowsInSection;

-(void) registerForNotifications;
-(void) calculateSections;
-(void) refreshAlarms;

@end
