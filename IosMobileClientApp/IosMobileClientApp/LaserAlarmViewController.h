//
//  LaserAlarmViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 19/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LaserAlarmViewController;
@class LaserAlarm;
@class Sensor;

@protocol LaserAlarmViewControllerDelegate <NSObject>
- (void)laserAlarmViewControllerDidGoBack:(LaserAlarmViewController *)controller;
@end

@interface LaserAlarmViewController : UIViewController
{
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *alarmTypeLabel;
    IBOutlet UILabel *sensorLabel;
}

@property (nonatomic, weak) id <LaserAlarmViewControllerDelegate> delegate;
@property (nonatomic) LaserAlarm *laserAlarm;
@property (nonatomic) Sensor *sensor;

- (IBAction)back:(id)sender;

@end
