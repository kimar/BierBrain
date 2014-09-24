//
//  BBConstants.h
//  BierBrain
//
//  Created by Marcus Kida on 27.10.12.
//  Copyright (c) 2012 Marcus Kida. All rights reserved.
//

#define kDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]
#define kCoreDataSqlite @"BierBrain.sqlite"

// Seagues
#define kEditBeaverage @"EditBeaverage"
#define kAddBeaverage @"AddBeaverage"
#define kShowBeaveragesToAdd @"ShowBeaveragesToAdd"
#define kShowDrunkBeaverages @"ShowDrunkBeaverages"
#define kShowWebView @"ShowWebView"

// UserDefaults Keys
#define kAlreadyStarted @"alreadyStarted"
#define kStoredBeverage @"storedBeverage"

// Enums
typedef enum
{
    AlertViewAddDrinker = 100,
    AlertViewDrinkersAccessory
} AlertViewTags;

// Brewery DB Api
#define kBreweryDbApiBaseUrl @"http://api.brewerydb.com/v2"
#error Add BreweryDB.com API Key Below and remove this line!!
#define kBreweryDbApiKey @""