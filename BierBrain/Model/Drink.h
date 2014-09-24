//
//  Drinks.h
//  BierBrain
//
//  Created by Marcus Kida on 24.02.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Drinker;

@interface Drink : NSManagedObject

@property (nonatomic, retain) NSNumber * alcoholPercent;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * volumeLiters;
@property (nonatomic, retain) Drinker *drinker;

@end
