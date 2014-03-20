//
//  MapDetailsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MapDetailsViewController.h"
#import "MyAlarmAnnotation.h"
#import "IosMobileClientLib/Map.h"
#import "IosMobileClientLib/CamsObjectRepository.h"
#import "IosMobileClientLib/Sensor.h"
#import "IosMobileClientLib/GlobalSettings.h"

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
    [self.navigationItem setTitle:self.map.displayName];
    
    [self.mapView setMapType:MKMapTypeSatellite];
    [self.mapView setShowsUserLocation:YES];
    
    [self defineMapRegion];
    [self drawSensors];
    //[self drawAnnotations];
  }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Mapping functions
//
// Calculates the MKCoordinateRegion which defines the map display bounds.
// Adds 10% buffer for visual appeal.
// TODO Remove the 10% buffer hard code.
-(void) defineMapRegion
{
    // Find the latitude and longitude span in degrees.
    double latSpan = [self.map.topLeftCorner.latitude doubleValue] - [self.map.bottomLeftCorner.latitude doubleValue];
    double longSpan = [self.map.topRightCorner.longitude doubleValue] - [self.map.topLeftCorner.longitude doubleValue];
    
    // Put the spans into a MKCoordinateSpan.
    MKCoordinateSpan span;
    span.latitudeDelta = latSpan;
    span.longitudeDelta = longSpan;
    
    // Calculate the origin of the map in latitude/longitude degrees.
    CLLocationCoordinate2D origin;
    origin.latitude = [self.map.bottomLeftCorner.latitude doubleValue] + latSpan/2;
    origin.longitude = [self.map.bottomLeftCorner.longitude doubleValue] + longSpan/2;
    
    // Add a buffer to the span
    MKCoordinateSpan bufferedSpan;
    bufferedSpan.latitudeDelta = latSpan * 1.1f;
    bufferedSpan.longitudeDelta = longSpan * 1.1f;

    // Construct a region for the MapView to display.
    region.center = origin;
    region.span = bufferedSpan;
    
    // Set the region.
    [self.mapView setRegion:region];
}

//
// Draws the sensors
-(void) drawSensors
{
    for (Sensor *sensor in [self.repository.sensors allValues])
        [[self mapView] addOverlay:sensor level:MKOverlayLevelAboveLabels];
}

//
// Draw annotations
-(void) drawAnnotations
{
    MyAlarmAnnotation *annotation = [[MyAlarmAnnotation alloc] initWithLocation:region.center
                                                                          title:@"Zone 1"
                                                                       subtitle:@"Intrusion at 42m."
                                                                        eventId:[NSNumber numberWithInt:42]];
    [self.mapView addAnnotation:annotation];
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
    
    if ([mp isKindOfClass:[MyAlarmAnnotation class]])
    {
        MKCoordinateRegion annotationRegion = MKCoordinateRegionMakeWithDistance([mp coordinate], 1000, 1000);
        [mv setRegion:annotationRegion animated:YES];
        [mv selectAnnotation:mp animated:YES];
    }
}


//
// Retrieve the correct annotation view.
//
- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyAlarmAnnotation class]])
    {
        MyAlarmAnnotation *alarmAnno = (MyAlarmAnnotation*) annotation;
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
    MyAlarmAnnotation *annotation = (MyAlarmAnnotation*)view.annotation;
    NSString *message = [[NSString alloc] initWithFormat:@"Event %@:", [[annotation eventId] stringValue]];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Intrusion!"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
}

//
// Called when the overlay is added in iOS 7
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    CGFloat transparency = 0.6f;
    CGFloat lineWidth = 2.0f;
    
    if ([overlay isKindOfClass:MKPolyline.class]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setLineWidth:lineWidth];
        [renderer setAlpha:transparency];
        [renderer setLineCap:kCGLineCapRound];
        return renderer;
    }
    else if ([overlay isKindOfClass:Sensor.class]) {
        Sensor *sensor = (Sensor *) overlay;
        NSUInteger numPoints = [[sensor sensorPoints] count];
        CLLocationCoordinate2D *coordinateData =[sensor pointsToDrawInOverlay];
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinateData count:numPoints];
        
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        [renderer setStrokeColor:[UIColor greenColor]];
        [renderer setLineWidth:lineWidth];
        [renderer setAlpha:transparency];
        [renderer setLineCap:kCGLineCapRound];
        
        free(coordinateData);
        return renderer;
    }
    return nil;
}
@end
