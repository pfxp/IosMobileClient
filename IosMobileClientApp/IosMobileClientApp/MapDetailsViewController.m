//
//  MapDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MapDetailsViewController.h"
#import "AlarmAnnotation.h"

@interface MapDetailsViewController ()

@end

@implementation MapDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mapView setDelegate:self];

    // Do any additional setup after loading the view.
    self.navigationItem.title = self.map.displayName;
    
    // Find the latitude and longitude span in degrees.
    double latSpan = [self.map.topLeftCorner.latitude doubleValue] - [self.map.bottomLeftCorner.latitude doubleValue];
    double longSpan = [self.map.topRightCorner.longitude doubleValue] - [self.map.topLeftCorner.longitude doubleValue];

    // Put the spans into a MKCoordinateSpan
    MKCoordinateSpan span;
    span.latitudeDelta = latSpan;
    span.longitudeDelta = longSpan;

    // Calculate the origin of the map in latitude/longitude degrees.
    CLLocationCoordinate2D origin;
    origin.latitude = [self.map.bottomLeftCorner.latitude doubleValue] + latSpan/2;
    origin.longitude = [self.map.bottomLeftCorner.longitude doubleValue] + longSpan/2;
    
    // Construct a region for the MapView to display.
    MKCoordinateRegion region;
    region.center = origin;
    region.span = span;
    
    mapView.region = region;
   
    AlarmAnnotation *annotation = [[AlarmAnnotation alloc] initWithLocation:origin
                                                                      title:@"Zone 1"
                                                                   subtitle:@"Intrusion at 42m."
                                                                    eventId:[NSNumber numberWithInt:42]];
   
    [mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation functions
// Go back to previous screens.
- (IBAction)back:(id)sender
{
    [self.delegate mapDetailsViewControllerDidGoBack:self];
}

#pragma mark MKPamViewDelegate functions
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 500, 500);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[AlarmAnnotation class]])
    {
        AlarmAnnotation *alarmAnno = (AlarmAnnotation*) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mv dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (annotationView == nil)
        {
            annotationView = alarmAnno.annotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

// Called when the disclosure button in the annotation is tapped.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    AlarmAnnotation *annotation = (AlarmAnnotation*)view.annotation;
    NSString *message = [[NSString alloc] initWithFormat:@"Event %@:", [[annotation eventId] stringValue]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Intrusion!"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
@end
