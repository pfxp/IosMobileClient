//
//  DashboardViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmDetailsViewController.h"

@class Cams;


@interface DashboardViewController : UITableViewController <AlarmDetailsViewControllerDelegate, UIAlertViewDelegate>
{
    IBOutlet UIButton *refreshButton;
}

@property (readwrite, weak) Cams *cams;

- (IBAction) refreshButtonClicked:(id)sender;
-(void) drawAlarms;

@end
