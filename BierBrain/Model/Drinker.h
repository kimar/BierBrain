//
//  Drinkers.h
//  BierBrain
//
//  Created by Marcus Kida on 24.02.13.
//  Copyright (c) 2013 Marcus Kida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Drink;

@interface Drinker : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *drinks;
@end

@interface Drinker (CoreDataGeneratedAccessors)

- (void)addDrinksObject:(Drink *)value;
- (void)removeDrinksObject:(Drink *)value;
- (void)addDrinks:(NSSet *)values;
- (void)removeDrinks:(NSSet *)values;

@end
