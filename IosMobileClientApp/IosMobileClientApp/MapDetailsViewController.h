//
//  MapDetailsViewController.h
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IosMobileClientLib/Map.h"

@class MapDetailsViewController;

@protocol MapDetailsViewControllerDelegate <NSObject>
- (void)playerDetailsViewControllerDidCancel:(MapDetailsViewController *)controller;
- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller;
@end


@interface MapDetailsViewController : UIViewController
    @property (nonatomic, weak) id <MapDetailsViewControllerDelegate> delegate;
    @property (nonatomic, strong) Map *map;
    - (IBAction)back:(id)sender;
@end
