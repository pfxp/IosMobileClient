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

@protocol SystemAlarmViewControllerDelegate <NSObject>
- (void)systemAlarmViewControllerDidCancel:(SystemAlarmViewController *)controller;
@end

@interface SystemAlarmViewController : UIViewController
{
    IBOutlet UILabel *alarmTypeLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *controllerLabel;
}

@property (nonatomic, weak) id <SystemAlarmViewControllerDelegate> delegate;
@property (nonatomic, weak) SystemAlarm *systemAlarm;
@property (nonatomic, weak) Controller *controller;

- (IBAction)back:(id)sender;

@end




