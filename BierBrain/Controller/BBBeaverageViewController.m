//
//  BBBeaverageViewController.m
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import "BBBeaverageViewController.h"

@interface BBBeaverageViewController ()
{
    NSArray *m_aBeaverages;
}
@end

@implementation BBBeaverageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Initialie Beaverages
    [self initializeBeaverages];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data management
- (void)initializeBeaverages
{
    m_aBeaverages = [Beaverage findAll];    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)removeBeaverageAtIndex:(int)index
{
    NSManagedObjectContext *pContext = [NSManagedObjectContext defaultContext];
    Beaverage *pBeaverage = [m_aBeaverages objectAtIndex:index];
    [pBeaverage deleteEntity];
    [pContext save];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aBeaverages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeaverageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    // The Beaverage itself
    Beaverage *pBeaverage = (Beaverage *)[m_aBeaverages objectAtIndex:indexPath.row];
    
    // Beaverage Name
    UILabel *pNameLabel = (UILabel *)[cell viewWithTag:1];
    pNameLabel.text = [NSString stringWithFormat:@"%@", pBeaverage.name];
    
    // Beaverage Type
    UILabel *pTypeLabel = (UILabel *)[cell viewWithTag:2];
    pTypeLabel.text = [NSString stringWithFormat:@"%@", pBeaverage.type];
    
    // Beaverage Details
    UILabel *pDetailsLabel = (UILabel *)[cell viewWithTag:3];
    pDetailsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"beverage_details", nil),
                          [pBeaverage.volumeLiters doubleValue],
                          [pBeaverage.alcoholPercent doubleValue],
                          [pBeaverage.price doubleValue]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self removeBeaverageAtIndex:indexPath.row];
        [self initializeBeaverages];
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    BBEditBeaverageViewController *pEditBeaveragesViewController = segue.destinationViewController;

    if ([segue.identifier isEqualToString:kEditBeaverage])
    {
        pEditBeaveragesViewController.m_pBeaverage = [m_aBeaverages objectAtIndex:indexPath.row];
        pEditBeaveragesViewController.m_bBeaverageExisting = YES;
    }
    else if([segue.identifier isEqualToString:kAddBeaverage])
    {
        pEditBeaveragesViewController.m_bBeaverageExisting = NO;
    }
}

@end
