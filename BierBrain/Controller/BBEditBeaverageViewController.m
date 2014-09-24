//
//  BBEditBeaverageViewController.m
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import "BBEditBeaverageViewController.h"

@interface BBEditBeaverageViewController () <UITextFieldDelegate>
{
    BOOL m_bBeaverageExisting;
    Beaverage *m_pBeaverage;
    Drink *m_pDrink;
}
@end

@implementation BBEditBeaverageViewController

@synthesize m_bBeaverageExisting;
@synthesize m_pBeaverage;
@synthesize m_pDrink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView addKeyboardPanningWithActionHandler:^(CGRect keyboardFrame){
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"isDrink = %@, isBeverage = %@", m_pDrink?@"YES":@"NO", m_pBeaverage?@"YES":@"NO");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set Title depending on Beaverage
    if(m_bBeaverageExisting)
    {
        [self setTitle:[NSString stringWithFormat:@"%@", m_pBeaverage?m_pBeaverage.name:m_pDrink.name]];
        
        // Fill in TextField with Name of Beaverage
        UITextField *pBeaverageName = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1];
        [pBeaverageName setText:m_pBeaverage?m_pBeaverage.name:m_pDrink.name];
        
        // Fill in TextField with Type of Beaverage
        UITextField *pBeaverageType = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:1];
        [pBeaverageType setText:m_pBeaverage?m_pBeaverage.type:m_pDrink.type];
        
        // Fill in TextField with Aolcohol of Beaverage
        UITextField *pBeaverageAlcohol = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:1];
        [pBeaverageAlcohol setText:[NSString stringWithFormat:@"%.2f", [m_pBeaverage?m_pBeaverage.alcoholPercent:m_pDrink.alcoholPercent doubleValue]]];
        
        // Fill in TextField with Volume of Beaverage
        UITextField *pBeaverageVolume = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] viewWithTag:1];
        [pBeaverageVolume setText:[NSString stringWithFormat:@"%.2f", [m_pBeaverage?m_pBeaverage.volumeLiters:m_pDrink.volumeLiters doubleValue]]];
        
        // Fill in TextField with Price of Beaverage
        UITextField *pBeaveragePrice = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] viewWithTag:1];
        [pBeaveragePrice setText:[NSString stringWithFormat:@"%.2f", [m_pBeaverage?m_pBeaverage.price:m_pDrink.price doubleValue]]];
    }
    else
        [self setTitle:NSLocalizedString(@"new_beverage", nil)];
    
    // Check if there is a stored beverage
    NSString *stBeverage = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kStoredBeverage];
    if([stBeverage length] > 0)
    {
        // Fill in TextField with Name of Beaverage
        UITextField *pBeaverageName = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1];
        [pBeaverageName setText:stBeverage];
        
        // Fill in TextField with Type of Beaverage
        UITextField *pBeaverageType = (UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:1];
        [pBeaverageType setText:NSLocalizedString(@"beer", nil)];
        
        [self setTitle:pBeaverageName.text];
        
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:kStoredBeverage];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 5)
    {
        [self saveBeaverage];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Actions
- (void)saveBeaverage
{
    if(m_pBeaverage || !m_bBeaverageExisting)
    {
        NSLog(@"NOW saving beverage!");
        NSManagedObjectContext *pContext = [NSManagedObjectContext defaultContext];
        Beaverage *pBeaverage;
        
        if(m_bBeaverageExisting)
            pBeaverage = m_pBeaverage;
        else
            pBeaverage = [Beaverage createEntity];
  
        pBeaverage.name = [(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1] text];
        
        pBeaverage.type = [(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:1] text];
        
        pBeaverage.alcoholPercent = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        pBeaverage.volumeLiters = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        pBeaverage.price = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        [pContext save];
    }
    else
    {
        NSLog(@"NOW saving drink!");
        NSManagedObjectContext *pContext = [NSManagedObjectContext defaultContext];
        Drink *pDrink;
        
        if(m_bBeaverageExisting)
                pDrink = m_pDrink;
        else
                pDrink = [Drink createEntity];
        
        pDrink.name = [(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] viewWithTag:1] text];
        
        pDrink.type = [(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] viewWithTag:1] text];
        
        pDrink.alcoholPercent = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        pDrink.volumeLiters = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        pDrink.price = [NSNumber numberWithDouble:[[(UITextField *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]] viewWithTag:1] text] doubleValue]];
        
        [pContext save];
    }
    
}

@end
