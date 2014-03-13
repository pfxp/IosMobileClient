//
//  MapDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MapDetailsViewController.h"
#import "AlarmAnnotation.h"
#import "IosMobileClientLib/Map.h"
#import "IosMobileClientLib/CamsObjectRepository.h"
#import "IosMobileClientLib/Sensor.h"

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
    [self.mapView setDelegate:self];
    [self.mapView setMapType:MKMapTypeSatellite];
    
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
    [self.mapView setRegion:region];
  
    
    
    // Draw the overlay
    CLLocationCoordinate2D pointsToUse[3];
    pointsToUse[0].latitude = -12.401087;
    pointsToUse[0].longitude = 130.864336;
    pointsToUse[1].latitude = -12.422568;
    pointsToUse[1].longitude = 130.894805;
    pointsToUse[2].latitude = -12.432568;
    pointsToUse[2].longitude = 130.904805;
    MKPolyline *myPolyline = [MKPolyline polylineWithCoordinates:pointsToUse count:3];
    myPolyline.title = @"Colorado";
    
    [self.mapView addOverlay:myPolyline level:MKOverlayLevelAboveLabels];
    
   
    
   // for (Sensor *sensor in [self.repository.sensors allValues])
    //{
     //   [self.mapView addOverlay:sensor level:MKOverlayLevelAboveLabels];
    //}
    
    
    AlarmAnnotation *annotation = [[AlarmAnnotation alloc] initWithLocation:origin
                                                                      title:@"Zone 1"
                                                                   subtitle:@"Intrusion at 42m."
                                                                    eventId:[NSNumber numberWithInt:42]];
    
    [self.mapView addAnnotation:annotation];
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
//
// When an annotation is added, zoom into a region 1000m x 1000m
//
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1000, 1000);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}


//
// Retrieve the correct annotation view.
//
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

//
// Called when the annotation is tapped.
//
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


// Called when the overlay is added in iOS 7
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    CGFloat transparency = 0.3f;
    CGFloat lineWidth = 4.0f;
    
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setLineWidth:lineWidth];
        [renderer setAlpha:transparency];
        [renderer setLineCap:kCGLineCapRound];
        return renderer;
    }
    return nil;

}
@end
