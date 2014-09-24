//
//  BBViewController.m
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import "BBDrinkersViewController.h"

@interface BBDrinkersViewController () <UIAlertViewDelegate>
{
    NSArray *m_aDrinkers;
    UITableViewCell *m_pLastSelectedCell;
}
@end

@implementation BBDrinkersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Initialize Drinkers
    [self initializeDrinkers];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Data management
- (void)initializeDrinkers
{
    m_aDrinkers = [Drinker findAll];
    NSLog(@"Found %d Drinkers!", [m_aDrinkers count]);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addDrinkerWithName:(NSString *)drinkerName
{
    NSManagedObjectContext *pContext = [NSManagedObjectContext defaultContext];
    Drinker *pDrinker = [Drinker createEntity];
    pDrinker.name = drinkerName;
    [pContext save];
}

- (void)removeDrinkerAtIndex:(int)index
{
    NSManagedObjectContext *pContext = [NSManagedObjectContext defaultContext];
    Drinker *pDrinker = [m_aDrinkers objectAtIndex:index];
    [pDrinker deleteEntity];
    [pContext save];
}

#pragma mark TableView Datasource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aDrinkers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stReuseIdentifier = @"DrinkerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stReuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:stReuseIdentifier];
    }
    
    Drinker *pDrinker = (Drinker *)[m_aDrinkers objectAtIndex:indexPath.row];
    NSNumber *numberOfDrinks = [NSNumber numberWithInt:[[pDrinker.drinks allObjects] count]];
    
    double ammountPrice = 0.0f;
    double ammountDrunk = 0.0f;
    for (Drink *pDrink in [pDrinker.drinks allObjects])
    {
        ammountDrunk += [pDrink.volumeLiters doubleValue];
        ammountPrice += [pDrink.price doubleValue];
    }
    
    // Show Drinker´s Name
    UILabel *pNameLabel = (UILabel *)[cell viewWithTag:1];
    pNameLabel.text = [NSString stringWithFormat:@"%@", pDrinker.name];
    
    // Show number Drinks
    UILabel *pDrinksLabel = (UILabel *)[cell viewWithTag:2];
    pDrinksLabel.text = [NSString stringWithFormat:NSLocalizedString(@"drink_details", nil), numberOfDrinks, ammountDrunk, ammountPrice];
    
    return cell;
}

#pragma mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    m_pLastSelectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *pAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"note", nil)
                                                         message:NSLocalizedString(@"what_would_you_like_to_do", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                               otherButtonTitles:NSLocalizedString(@"add_beverage", nil),
                                                                 NSLocalizedString(@"share", nil), nil];
    [pAlertView setTag:AlertViewDrinkersAccessory];
    [pAlertView show];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self removeDrinkerAtIndex:indexPath.row];
        [self initializeDrinkers];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case AlertViewAddDrinker:
        {
            if(buttonIndex == 1)
            {
                [self addDrinkerWithName:[[alertView textFieldAtIndex:0] text] ];
                [self initializeDrinkers];
            }
            
        }
            break;
            
        case AlertViewDrinkersAccessory:
        {
            if(buttonIndex == 1)
            {
                [self performSegueWithIdentifier:kShowBeaveragesToAdd sender:m_pLastSelectedCell];
            }
            else if (buttonIndex == 2)
            {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:m_pLastSelectedCell];
                Drinker *pDrinker = [m_aDrinkers objectAtIndex:indexPath.row];
                NSNumber *numberOfDrinks = [NSNumber numberWithInt:[[pDrinker.drinks allObjects] count]];
                
                double ammountPrice = 0.0f;
                double ammountDrunk = 0.0f;
                for (Drink *pDrink in [pDrinker.drinks allObjects])
                {
                    ammountDrunk += [pDrink.volumeLiters doubleValue];
                    ammountPrice += [pDrink.price doubleValue];
                }
#warning Implment sharing
//                SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@ hat schon %d Getränke (%.2fl) im Wert von %.2f € getrunken! Mach mit und lade dir die kostenfreie App #BierBrain!", pDrinker.name, [numberOfDrinks intValue], ammountDrunk, ammountPrice]];
//                SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
//                [actionSheet showFromToolbar:self.navigationController.toolbar];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IBActions
- (IBAction)addDrinker:(id)sender
{
    UIAlertView *pAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"new_drinker_title", nil)
                                                         message:NSLocalizedString(@"new_drinker_msg", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                               otherButtonTitles:NSLocalizedString(@"add", nil), nil];
    [pAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [pAlertView setTag:AlertViewAddDrinker];
    [pAlertView show];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if([segue.identifier isEqualToString:kShowDrunkBeaverages])
    {
        BBListDrinkersBeaveragesViewController *pDestinationViewController = segue.destinationViewController;
        pDestinationViewController.m_pDrinker = (Drinker *)[m_aDrinkers objectAtIndex:indexPath.row];
    }
    else if([segue.identifier isEqualToString:kShowBeaveragesToAdd])
    {
        BBListDrinkersBeaveragesViewController *pDestinationViewController = segue.destinationViewController;
        pDestinationViewController.m_pDrinker = (Drinker *)[m_aDrinkers objectAtIndex:indexPath.row];
    }
}

@end
