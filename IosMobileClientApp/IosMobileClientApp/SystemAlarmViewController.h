//
//  SystemAlarmViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 19/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemAlarmViewController;
@class SystemAlarm;
@class Controller;

@interface SystemAlarmViewController : UIViewController
{
    IBOutlet UILabel *alarmTypeLabel;
    IBOutlet UILabel *controllerLabel;
    IBOutlet UILabel *timeLabel;
}

@property (nonatomic, weak) SystemAlarm *systemAlarm;
@property (nonatomic, weak) Controller *controller;

@end




