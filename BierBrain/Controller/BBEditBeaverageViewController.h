//
//  BBEditBeaverageViewController.h
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Beaverage.h"
#import "Drink.h"

@interface BBEditBeaverageViewController : UITableViewController

@property (nonatomic, assign) BOOL m_bBeaverageExisting;
@property (nonatomic, retain) Beaverage *m_pBeaverage;
@property (nonatomic, retain) Drink *m_pDrink;

@end
