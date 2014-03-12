//
//  MapDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "IosMobileClientLib/Map.h"

// This is a forward declaration.
@class MapDetailsViewController;

//Uses delegation. The child view controller defines a delegate protocol that the parent view controller implements. Before the parent view controller displays the child view controller, it sets itself as the delegate of the child view controller. When the user has selected a row or what ever in the child view, the child view controller calls a method on its delegate and dismisses itself.

// This protocol enables a Cancel or Save button to be used in the navigation bar.
@protocol MapDetailsViewControllerDelegate <NSObject>
- (void)mapDetailsViewControllerDidGoBack:(MapDetailsViewController *)controller;
- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller;
@end


@interface MapDetailsViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, weak) id <MapDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) Map *map;

- (IBAction)back:(id)sender;
@end
