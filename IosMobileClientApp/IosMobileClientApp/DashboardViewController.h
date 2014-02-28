//
//  DashboardViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 27/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cams;

@protocol DashboardViewControllerDelegate <NSObject>
@end


@interface DashboardViewController : UITableViewController <DashboardViewControllerDelegate>

@property (readwrite, weak) Cams *cams;

-(void) drawAlarms;

@end
