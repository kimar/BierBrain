//
//  BBRemoteSearchDrinkViewController.m
//  BierBrain
//
//  Created by Marcus Kida on 28.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import "BBRemoteSearchDrinkViewController.h"

@interface BBRemoteSearchDrinkViewController () <UITextFieldDelegate>
{
    IBOutlet UITextField *m_pSearchTextField;
    NSArray *m_aSearchResults;
}
@end

@implementation BBRemoteSearchDrinkViewController

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
    
    [self.tableView addKeyboardPanningWithActionHandler:^(CGRect keyboardFrame){
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_aSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BeverageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UITextField *pNameTextField = (UITextField *)[cell viewWithTag:1];
    UITextField *pTypeTextField = (UITextField *)[cell viewWithTag:2];
    UITextField *pDescriptionTextField = (UITextField *)[cell viewWithTag:3];

    double alcohol = [[[m_aSearchResults objectAtIndex:indexPath.row] objectForKey:@"name"] doubleValue];
    pNameTextField.text = [[m_aSearchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
    pTypeTextField.text = NSLocalizedString(@"beer", nil);//[[m_aSearchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
    pDescriptionTextField.text = [NSString stringWithFormat:NSLocalizedString(@"beverage_details", nil), 0.0f, alcohol, 0.0f];

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
    
    // Store selected beverage in UserDefaults
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    [[NSUserDefaults standardUserDefaults] setObject:[(UITextField *)[cell viewWithTag:1] text] forKey:kStoredBeverage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self doSearch:nil];
    return YES;
}

#pragma mark - IBActions
- (IBAction)doSearch:(id)sender
{
    NSLog(@"doSearch");
    
    // Show statusbar overlay
    [self showStatusbarOverlay];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/search?key=%@&q=%@", kBreweryDbApiBaseUrl, kBreweryDbApiKey, [m_pSearchTextField.text urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(@"BreweryDB /search API-Response: %@", JSON);
        
        m_aSearchResults = [JSON objectForKey:@"data"];
        NSLog(@"aBeer count = %d", [m_aSearchResults count]);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        // Dismiss statusbar overlay
        [self dismissStatusbarOverlay];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"BreweryDB /search API-Failed: %@", [error localizedDescription]);

        // Dismiss statusbar overlay
        [self dismissStatusbarOverlay];
        
        // Show Alert if something fails here
        UIAlertView *pAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil)
                                                             message:[NSString stringWithFormat:NSLocalizedString(@"brewerydb_api_failed", nil), [error localizedDescription]]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                                   otherButtonTitles:nil];
        [pAlertView show];

    }];
    [operation start];
}

#pragma mark - Statusbar Overlay
- (void) showStatusbarOverlay
{
    // Show aniamted statusbar overlay
    BWStatusBarOverlay *pStatusBarOverlay = [BWStatusBarOverlay shared];
    [pStatusBarOverlay setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [pStatusBarOverlay showWithMessage:@"Suche nach Bieren..." loading:YES animated:YES];
}

- (void) dismissStatusbarOverlay
{
    // Dismiss statusbar overlay
    BWStatusBarOverlay *pStatusBarOverlay = [BWStatusBarOverlay shared];
    [pStatusBarOverlay dismissAnimated:YES];
}

@end
