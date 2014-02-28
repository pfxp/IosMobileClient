//
//  AlarmDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmDetailsViewController;

@protocol AlarmDetailsViewControllerDelegate <NSObject>
- (void)alarmDetailsViewControllerDidAcknowledge:(AlarmDetailsViewController *)controller;
@end



@interface AlarmDetailsViewController : UIViewController

@property (nonatomic, weak) id <AlarmDetailsViewControllerDelegate> delegate;

- (IBAction)back:(id)sender;

@end
