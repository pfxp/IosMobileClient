//
//  FFTAppDelegate.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 6/02/2014.
//  Copyright (c) 2014 Peter Pellegrini. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

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
    [self registerDefaultsFromSettingsBundle];
    
    // Get a dictionary of valid URLS
    NSDictionary *urls = [self processUrls:standaloneUserDefaults];
    
    // Initialize the CAMS object, request configuration data and alarm data.
    cams = [[Cams alloc] initWithUrls:urls];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    // Give CAMS data to Alarm List
    UINavigationController *alarmListNavController = [tabBarController viewControllers][0];
    DashboardViewController *alarmListViewController = [alarmListNavController viewControllers][0];
    alarmListViewController.cams = cams;

    // Give CAMS data to Maps view
    UINavigationController *mapsNavController = [tabBarController viewControllers][1];
    MapsViewController *mapsViewController = [mapsNavController viewControllers][0];
    mapsViewController.cams = cams;
    
    // Give CAMS data to Utilities view.
    UtilitiesViewController *utilitiesVC = [tabBarController viewControllers][3];
    utilitiesVC.cams = cams;

    // Start downloading data
    [cams startStandardLocationService];
    [cams startup];
    

    // test if system-wide location services are enabled.
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Location Service"
                                                         message:@"Location services are required. "
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    
    
    // Test if application is allowed to use location services.
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus!=kCLAuthorizationStatusAuthorized)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"App requires Location Services"
                                                         message:@"Location services must be enabled for this app."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }

    
    return YES;
}

///////////////////////////////////////////////
// Sends the APNS token to the Web Service.
///////////////////////////////////////////////
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
   
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
    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settingsRoot = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferencesRoot = [settingsRoot objectForKey:@"PreferenceSpecifiers"];
    
    NSDictionary *settingsServers = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"servers.plist"]];
    NSArray *preferencesServers = [settingsServers objectForKey:@"PreferenceSpecifiers"];

    NSDictionary *settingsSounds = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"sounds.plist"]];
    NSArray *preferencesSounds = [settingsSounds objectForKey:@"PreferenceSpecifiers"];

    unsigned long defaultsCount = [preferencesRoot count] + [preferencesServers count] + [preferencesSounds count];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:defaultsCount];
    
    // root.plist
    for(NSDictionary *prefSpecification in preferencesRoot) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            //NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    // servers.plist
    for(NSDictionary *prefSpecification in preferencesServers) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }

    // sounds.plist
    for(NSDictionary *prefSpecification in preferencesSounds) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}



//
// Reads the non-blank URLS from the settings.
// TODO tighten the logic
//
- (NSDictionary *) processUrls:(NSUserDefaults *) defaults
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    for (int i=1; i <= 8; i++)
    {
        NSString *key = [[NSString alloc] initWithFormat:@"pref_server_%d", i];
        NSString *value = [defaults stringForKey:key];
        NSURL *url = [NSURL URLWithString:value];
        
        if ([value length] > 5 && url != nil)
        {
            [dictionary setValue:url forKey:key];
        }
    }
    
    return dictionary;
}
@end
