//
//  FFTViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceComms.h"

@interface FFTViewController : UIViewController
{
    IBOutlet UIButton *connectToHelloWorldWebServiceButton;
    IBOutlet UIButton *connectToCamsWebServiceButton;
    IBOutlet UIButton *getControllersButton;
    IBOutlet UILabel *outputLabel;
    WebServiceComms *wsComms;
}

- (IBAction) helloWorldButtonClicked:(id)sender ;
- (IBAction) camsButtonClicked:(id)sender ;
- (IBAction) getControllersButtonClicked:(id)sender ;
- (void)fetchHelloWorldGreeting;
- (void)invokeJsonData;
- (void)invokeGetControllers;
@end

