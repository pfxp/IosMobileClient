//
//  AlarmDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmDetailsViewController;
@class ZoneEvent;

@protocol AlarmDetailsViewControllerDelegate <NSObject>
- (void)alarmDetailsViewControllerDidCancel:(AlarmDetailsViewController *)controller;
- (void)alarmDetailsViewControllerDidAcknowledge:(AlarmDetailsViewController *)controller;
- (void)alarmDetailsViewControllerDidGoToMap:(AlarmDetailsViewController *)controller;
@end



@interface AlarmDetailsViewController : UIViewController
{
    IBOutlet UILabel *perimeterLabel;
}

@property (nonatomic, weak) id <AlarmDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) ZoneEvent *zoneEvent;

- (IBAction)back:(id)sender;
- (IBAction)acknowledge:(id)sender;
- (IBAction)goToMap:(id)sender;
@end
