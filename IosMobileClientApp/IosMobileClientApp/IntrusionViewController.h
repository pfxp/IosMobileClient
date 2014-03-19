//
//  AlarmDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntrusionViewController;
@class ZoneEvent;
@class LaserAlarm;
@class SystemAlarm;
@class Zone;

@protocol AlarmDetailsViewControllerDelegate <NSObject>
- (void)alarmDetailsViewControllerDidGoBack:(IntrusionViewController *)controller;
- (void)alarmDetailsViewControllerDidAcknowledge:(IntrusionViewController *)controller;
- (void)alarmDetailsViewControllerDidGoToMap:(IntrusionViewController *)controller;
@end


@interface IntrusionViewController : UIViewController
{
    IBOutlet UILabel *zoneLabel;
    IBOutlet UILabel *perimeterLabel;
    IBOutlet UILabel *timeLabel;
}

@property (nonatomic, weak) id<AlarmDetailsViewControllerDelegate> delegate;
@property (nonatomic, weak) ZoneEvent *zoneEvent;
@property (nonatomic, weak) Zone *zone;

- (IBAction)back:(id)sender;
- (IBAction)acknowledge:(id)sender;
- (IBAction)goToMap:(id)sender;

@end
