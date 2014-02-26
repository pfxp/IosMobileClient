//
//  FFTAppDelegate.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebServiceComms.h"
#import "IosMobileClientLib/Cams.h"

@interface FFTAppDelegate : UIResponder <UIApplicationDelegate>
{
    WebServiceComms *wsComms;
    Cams *cams;
}
@property (strong, nonatomic) UIWindow *window;

@end
