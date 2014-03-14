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

//Uses delegation. The child view controller defines a delegate protocol that the parent view controller implements. Before the parent view controller displays the child view controller, it sets itself as the delegate of the child view controller. When the user has selected a row or what ever in the child view, the child view controller calls a method on its delegate and dismisses itself.

// This protocol enables a Cancel or Save button to be used in the navigation bar.
@protocol MapDetailsViewControllerDelegate <NSObject>
- (void)mapDetailsViewControllerDidGoBack:(MapDetailsViewController *)controller;
- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller;
@end


@interface MapDetailsViewController : UIViewController <MKMapViewDelegate>
{
    MKCoordinateRegion region;
}

@property (nonatomic, weak) id <MapDetailsViewControllerDelegate> delegate;
@property (readwrite, weak) CamsObjectRepository *repository;
@property (nonatomic, strong) Map *map;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)back:(id)sender;
@end
