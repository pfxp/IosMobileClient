//
//  MapsViewController.m
//  IosMobileClientApp
//
//  Created by Peter Pellegrini on 11/02/2014.
//  Copyright (c) 2014 Future Fibre Technologies Pty Ltd. All rights reserved.
//

#import "MapsViewController.h"
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    
    Map *map = [self.cams.repository getMapByIndex:indexPath.row];
    cell.textLabel.text = map.displayName;
    //cell.detailTextLabel.text = player.game;
    return cell;
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark My functions


- (void)mapDetailsViewControllerDidGoBack:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Pass the selected map to the MapDetailsViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayMap"]) {
        NSString *ti = [self title];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //UINavigationController *navigationController = segue.destinationViewController;
        //MapDetailsViewController *mapDetailsViewController = [navigationController viewControllers][0];
        
        MapDetailsViewController *mapDetailsViewController = segue.destinationViewController;
        mapDetailsViewController.delegate = self;
        mapDetailsViewController.map = [self.cams.repository getMapByIndex:indexPath.row];
        mapDetailsViewController.repository = self.cams.repository;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger row = [indexPath row];
    //self.selectedMap = (self.maps)[row];
    //int k=0;
}

#pragma mark MapsArrivedFromServerProtocol methods
- (void)mapsArrivedFromServer
{
   [self.tableView reloadData];
}

@end
