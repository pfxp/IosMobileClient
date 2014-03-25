//
//  AlarmDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 28/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class IntrusionViewController;
@class ZoneEvent;
@class LaserAlarm;
@class SystemAlarm;
@class Zone;
@class Cams;



@protocol IntrusionDetailsViewControllerDelegate <NSObject>
- (void)alarmDetailsViewControllerDidAcknowledge:(IntrusionViewController *)controller;
- (void)alarmDetailsViewControllerDidGoToMap:(IntrusionViewController *)controller;
@end


@interface IntrusionViewController : UIViewController
{
    IBOutlet UILabel *zoneLabel;
    IBOutlet UILabel *perimeterLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *directionsLabel;
}

@property (readwrite, weak) Cams *cams;
@property (nonatomic, weak) id<IntrusionDetailsViewControllerDelegate> delegate;
@property (nonatomic, weak) ZoneEvent *zoneEvent;
@property (nonatomic, weak) Zone *zone;
@property (nonatomic) CLLocation *eventLocation;

- (IBAction)acknowledge:(id)sender;
- (IBAction)goToMap:(id)sender;

-(CLLocation *) generateEventLocation;
-(NSString *) generateDirections;
- (float) getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc;
@end
