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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.maps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    
    Map *map = (self.maps)[indexPath.row];
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


- (void)playerDetailsViewControllerDidCancel:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerDetailsViewControllerDidSave:(MapDetailsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DisplayMap"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *navigationController = segue.destinationViewController;
        MapDetailsViewController *mapDetailsViewController = [navigationController viewControllers][0];
        
        mapDetailsViewController.delegate = self;
        mapDetailsViewController.map = [self.maps objectAtIndex:indexPath.row];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSUInteger row = [indexPath row];
    //self.selectedMap = (self.maps)[row];
    //int k=0;
}

@end
