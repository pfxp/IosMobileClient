//
//  MapsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapDetailsViewController.h"
#import "IosMobileClientLib/Map.h"

//Uses delegation. The child view controller defines a delegate protocol that the parent view controller implements. Before the parent view controller displays the child view controller, it sets itself as the delegate of the child view controller. When the user has selected a row or what ever in the child view, the child view controller calls a method on its delegate and dismisses itself.

@interface MapsViewController : UITableViewController <MapDetailsViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *maps;
@property (nonatomic, strong) Map *selectedMap;

@end
