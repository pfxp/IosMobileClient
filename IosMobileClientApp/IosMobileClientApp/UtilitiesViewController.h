//
//  FFTViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceComms.h"

@interface UtilitiesViewController : UIViewController
{
    IBOutlet UIButton *helloWorldButton;
    IBOutlet UIButton *getControllersButton;
    IBOutlet UIButton *getSensorsButton;
    IBOutlet UIButton *getZonesButton;
    IBOutlet UIButton *getMapsButton;
    IBOutlet UIButton *setTokenButton;
    IBOutlet UIButton *setTokenButton2;
    IBOutlet UILabel *outputLabel;
}

@property (readwrite, weak) WebServiceComms *wsComms;
- (IBAction) helloWorldButtonClicked:(id)sender;
- (IBAction) getControllersButtonClicked:(id)sender;
- (IBAction) getSensorsButtonClicked:(id)sender;
- (IBAction) getZonesButtonClicked:(id)sender;
- (IBAction) getMapsButtonClicked:(id)sender;
- (IBAction) postTokenButtonClicked:(id)sender;
- (IBAction) postTokenButtonClicked2:(id)sender;

@end

