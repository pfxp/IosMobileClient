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

@interface LaserAlarmViewController : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *alarmTypeLabel;
    IBOutlet UILabel *sensorLabel;
}

@property (nonatomic) LaserAlarm *laserAlarm;
@property (nonatomic) Sensor *sensor;

@end
