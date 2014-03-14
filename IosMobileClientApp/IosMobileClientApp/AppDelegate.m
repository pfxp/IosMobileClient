//
//  FFTAppDelegate.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import "AppDelegate.h"
#import "IosMobileClientLib/Map.h"
#import "DashboardViewController.h"
#import "MapsViewController.h"
#import "UtilitiesViewController.h"

@implementation AppDelegate
{

}

#pragma mark Standard overrides

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Register for push notifications.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound| UIRemoteNotificationTypeAlert)];
    
    NSUserDefaults *standaloneUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *url_preference = [standaloneUserDefaults objectForKey:@"url_pref"];
    if (!url_preference)
    {
        [self registerDefaultsFromSettingsBundle];
    }
    
    // Initialize the CAMS object, request configuration data and alarm data.
    cams = [[Cams alloc] initWithBaseUrl:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"url_pref"]]];
    [cams addConfigurationRequests];
    [cams addAlarmsRequests];
    [cams executeRequests];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // Give CAMS data to Dashboard
    UINavigationController *dashboardNavController = [tabBarController viewControllers][0];
    DashboardViewController *dashViewController = [dashboardNavController viewControllers][0];
    dashViewController.cams = cams;

    // Give CAMS data to Maps view
    UINavigationController *navigationController = [tabBarController viewControllers][1];
    MapsViewController *mapsViewController = [navigationController viewControllers][0];
    mapsViewController.cams = cams;

    // Give CAMS data to Utilities view.
    UtilitiesViewController *utilitiesVC = [tabBarController viewControllers][2];
    utilitiesVC.cams = cams;

    return YES;
}

///////////////////////////////////////////////
// Sends the APNS token to the Web Service.
///////////////////////////////////////////////
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"TOKEN: %@", token);
    
    [cams registerApnsToken:token];
}

//
// Called when a push notification is received.
//
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *badgeSoundText = [userInfo objectForKey:@"aps"];
    if (badgeSoundText!=nil)
    {
        //NSString *badge = [badgeSoundText objectForKey:@"badge"];
        //NSString *sound = [badgeSoundText objectForKey:@"sound"];
        NSString *alert = [badgeSoundText objectForKey:@"alert"];
        NSLog(@"APNS push alert: Alert:%@", alert);
    }
    
    [cams getAlarms];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark My functions
//
// Apply the default settings vaslue.
- (void) registerDefaultsFromSettingsBundle
{
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            //NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];

}
@end
