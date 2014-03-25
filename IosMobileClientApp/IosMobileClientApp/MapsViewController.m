//
//  MapsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MapsViewController.h"
#import "IosMobileClientLib/GlobalSettings.h"
#import "IosMobileClientLib/Map.h"

@interface MapsViewController ()

@end

@implementation MapsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshMapsList];
    [self registerForNotifications];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedMaps:)
                                                 name:MapsReceivedFromServerNotification
                                               object:nil];
}


#pragma mark - UITableViewDataSource protocol
// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cams.repository.maps count];
}

//
// Creates a new cell from a prototype.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    Map *map = [self.cams.repository getMapByIndex:indexPath.row];
    cell.textLabel.text = map.displayName;
    return cell;
}



#pragma mark Segue data preparation
// Pass the selected map to the MapDetailsViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayMap"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MapDetailsViewController *mapDetailsViewController = segue.destinationViewController;
        mapDetailsViewController.delegate = self;
        mapDetailsViewController.map = [self.cams.repository getMapByIndex:indexPath.row];
        mapDetailsViewController.repository = self.cams.repository;
    }
}



#pragma mark MapDetailsViewControllerDelegate functions.
- (void)mapDetailsViewControllerDidGoBack:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark Notification handler.
//
// Called when maps are received from the Web Service. Redraws the list of maps.
//
- (void)receivedMaps:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       [self refreshMapsList];
                   });
}



#pragma mark Redraw the list of maps.
//
// Refreshes the maps list.
//
- (void)refreshMapsList
{
   [[self tableView] reloadData];
}

@end
