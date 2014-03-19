//
//  SystemAlarmViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 19/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SystemAlarmViewController;

@protocol SystemAlarmViewControllerDelegate <NSObject>
- (void)systemAlarmViewControllerDidCancel:(SystemAlarmViewController *)controller;
@end

@interface SystemAlarmViewController : UIViewController
{
     IBOutlet UILabel *timeLabel;
}

@property (nonatomic, weak) id <SystemAlarmViewControllerDelegate> delegate;

- (IBAction)back:(id)sender;
@end




