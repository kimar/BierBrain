//
//  BBListDrinkersBeaveragesViewController.h
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Drink.h"
#import "Drinker.h"
#import "Beaverage.h"

#import "BBSelectBeaverageViewController.h"
#import "BBEditBeaverageViewController.h"

@interface BBListDrinkersBeaveragesViewController : UITableViewController

@property (nonatomic, retain) Drinker *m_pDrinker;

@end
