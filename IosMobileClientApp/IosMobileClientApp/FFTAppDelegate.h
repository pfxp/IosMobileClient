//
//  FFTAppDelegate.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "WebServiceComms.h"
@interface FFTAppDelegate : UIResponder <UIApplicationDelegate>
{
    WebServiceComms *wsComms;
}
@property (strong, nonatomic) UIWindow *window;

@end
