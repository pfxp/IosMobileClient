//
//  MapDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IosMobileClientLib/CamsObjectRepository.h"

// This is a forward declaration.
@class MapDetailsViewController;
@class Cams;

@interface MapDetailsViewController : UIViewController <MKMapViewDelegate>
{
    MKCoordinateRegion region;
}

@property (readwrite, weak) CamsObjectRepository *repository;
@property (nonatomic, strong) Map *map;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
