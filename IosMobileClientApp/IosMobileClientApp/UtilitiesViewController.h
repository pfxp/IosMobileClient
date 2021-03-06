//
//  FFTViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosMobileClientLib/Cams.h"

@interface UtilitiesViewController : UIViewController
{
    IBOutlet UIButton *helloWorldButton;
    IBOutlet UIButton *getControllersButton;
    IBOutlet UIButton *getSensorsButton;
    IBOutlet UIButton *getZonesButton;
    IBOutlet UIButton *getMapsButton;
    IBOutlet UIButton *getZoneEventsButton;
    IBOutlet UIButton *getCamsObjectsButton;
    IBOutlet UIButton *acknowledgeAllZoneEventsButton;
    IBOutlet UILabel *outputLabel;
    
    IBOutlet UITextField *usernameTextBox;
    IBOutlet UITextField *passwordTextBox;
    IBOutlet UIButton *authenticate;
}

@property (readwrite, weak) Cams *cams;

- (IBAction) helloWorldButtonClicked:(id)sender;
- (IBAction) getControllersButtonClicked:(id)sender;
- (IBAction) getSensorsButtonClicked:(id)sender;
- (IBAction) getZonesButtonClicked:(id)sender;
- (IBAction) getMapsButtonClicked:(id)sender;
- (IBAction) getZoneEventsButtonClicked:(id)sender;
- (IBAction) getsCamsObjectsButtonClicked:(id)sender;
- (IBAction) acknowledgeAllZoneEventsButtonClicked:(id)sender;
- (IBAction) authenticateButtonClicked:(id)sender;
+ (NSString *) displayDictionaryAsString:(NSDictionary *) dict;

@end

