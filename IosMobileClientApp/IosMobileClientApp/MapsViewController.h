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

@interface MapsViewController : UITableViewController <MapDetailsViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray *maps;
@property (nonatomic, strong) Map *selectedMap;

@end
