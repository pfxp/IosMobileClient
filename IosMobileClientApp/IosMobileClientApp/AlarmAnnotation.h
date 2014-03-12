//
//  AlarmAnnotation.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 12/03/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface AlarmAnnotation : NSObject <MKAnnotation>
{
    //NSString *title;
    //NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSNumber *eventId;

-(id) initWithLocation:(CLLocationCoordinate2D)coord title:(NSString*)title subtitle:(NSString*)subtitle eventId:(NSNumber*)eventId;
-(MKPinAnnotationView*) annotationView;

@end
