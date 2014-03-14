//
//  AlarmAnnotation.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 12/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MyAlarmAnnotation.h"

@implementation MyAlarmAnnotation

@synthesize coordinate;

-(id) initWithLocation:(CLLocationCoordinate2D)coord title:(NSString*)title subtitle:(NSString*)subtitle eventId:(NSNumber *)eventId
{
    self = [super init];
    if (self)
    {
        [self setCoordinate:coord];
        [self setTitle:title];
        [self setSubtitle:subtitle];
        [self setEventId:eventId];
    }
    return self;
}

-(MKPinAnnotationView*) annotationView
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.enabled=YES;
    annotationView.canShowCallout=YES;
    annotationView.image = [UIImage imageNamed:@"1star"];
    annotationView.animatesDrop=YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
