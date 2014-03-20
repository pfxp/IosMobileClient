//
//  AlarmDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "IntrusionViewController.h"
#import "IosMobileClientLib/Points.h"
#import "IosMobileClientLib/Cams.h"
#import "IosMobileClientLib/Zone.h"
#import "IosMobileClientLib/ZoneEvent.h"
#import "IosMobileClientLib/LaserAlarm.h"
#import "IosMobileClientLib/SystemAlarm.h"
#import "IosMobileClientLib/FFTCLLocation.h"

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@interface IntrusionViewController ()

@end

@implementation IntrusionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}



// TODO Set to locale specific date formatting.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"HH:mm:ss yyyy-mm-dd"];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    //Optionally for time zone converstions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    _eventLocation = [self generateEventLocation];
    [zoneLabel setText:[_zone name]];
    [perimeterLabel setText:[[_zoneEvent perimeterDistance] stringValue]];
    [timeLabel setText:[formatter stringFromDate:[_zoneEvent eventTimeUtc]]];
    [directionsLabel setText:[self generateDirections]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlarmDetailsViewControllerDelegate functions
//
// Go back to previous scene
//
- (IBAction)back:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidGoBack:self];
}



//
// Acknowledge the intrusion
//
- (IBAction)acknowledge:(id)sender
{
       
    [self.delegate alarmDetailsViewControllerDidAcknowledge:self];
}



//
// Go to the relevant map
//
- (IBAction)goToMap:(id)sender
{
    [self.delegate alarmDetailsViewControllerDidGoToMap:self];
}



#pragma mark Directions functions
//
// Converts the CAMS GeoPoint into a CLLocation
//
-(CLLocation *) generateEventLocation
{
    CLLocationCoordinate2D eventLocation2D;
    eventLocation2D.latitude = [[[self.zoneEvent camsGeoPoint] latitude] doubleValue];
    eventLocation2D.longitude = [[[self.zoneEvent camsGeoPoint] longitude] doubleValue];
    
    CLLocationDistance altitude = 0;
    CLLocationAccuracy horizontalAccuracy=1;
    CLLocationAccuracy verticalAccuracy=1;
    CLLocationDirection course=0;
    CLLocationSpeed speed=0;
    NSDate *timestamp = [NSDate date];
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:eventLocation2D
                                                         altitude:altitude
                                               horizontalAccuracy:horizontalAccuracy
                                                 verticalAccuracy:verticalAccuracy
                                                           course:course
                                                            speed:speed
                                                        timestamp:timestamp];
    return location;
}

//
// Generate the results
//
-(NSString *) generateDirections
{
    CLLocation *curr = [self.cams currentLocation];
    CLLocationDistance locationDistance = [ curr distanceFromLocation:[self eventLocation]];
    
    CLLocationDirection direction = [curr directionToLocation:[self eventLocation]];
    
    float dir = [self getHeadingForDirectionFromCoordinate:[curr coordinate] toCoordinate:[[self eventLocation] coordinate]];
    
    return [[NSString alloc] initWithFormat:@"Dir: %.0f\nDistance: %.0f", dir, locationDistance ];
}

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiandsToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}

@end
