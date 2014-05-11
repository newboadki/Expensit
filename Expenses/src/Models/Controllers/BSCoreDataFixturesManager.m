//
//  BSCoreDataFixturesManager.m
//  Expenses
//
//  Created by Borja Arias Drake on 12/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataFixturesManager.h"
#import "CoreDataStackHelper.h"

static NSString * const kAppliedFixturesVersionNumbersKey = @"appliedFixturesVersionNumbersKey";
static NSString * const kApplyFixtureMethodName = @"applyFixtureForModelObjectVersion";

@interface BSCoreDataFixturesManager ()
@property (strong, nonatomic) BSCoreDataController *coreDataController;
@end

@implementation BSCoreDataFixturesManager

- (BOOL)applyMissingFixturesOnManagedObjectModel:(NSManagedObjectModel *)model coreDataController:(BSCoreDataController *)coreDataController
{
    
    NSNumber *currentVersion = [NSDecimalNumber decimalNumberWithString:[model.versionIdentifiers anyObject]];
    
    for (int i = 0; (i <= [currentVersion intValue]); i++)
    {
        BOOL shouldApplyFixture = [self addVersionNumberToAppliedFixturesInUserDefaults:@(i)]; // If it's been added is because it didn't exist, therefore we need to apply a fixture
        if (shouldApplyFixture)
        {
            self.coreDataController = coreDataController;
            [self applyFixtureForVersion:@(i)];
        }
    }
    
    return YES;
}

- (BOOL)applyFixtureForVersion:(NSNumber *)version
{
    NSString *selectorName = [NSString stringWithFormat:@"%@_%@", kApplyFixtureMethodName, [version stringValue]];
    if ([self respondsToSelector:NSSelectorFromString(selectorName)])
    {
        [self performSelector:NSSelectorFromString(selectorName)];
    }

    return YES;
}

- (NSMutableArray *)appliedFixturesVersionNumbersFromUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults mutableArrayValueForKey:kAppliedFixturesVersionNumbersKey];
}

- (BOOL)addVersionNumberToAppliedFixturesInUserDefaults:(NSNumber *)version
{
    BOOL added = NO;

    NSMutableArray *appliedVersionNumbers = [self appliedFixturesVersionNumbersFromUserDefaults];
    
        if (![appliedVersionNumbers containsObject:version])
        {
            [appliedVersionNumbers addObject:version];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:appliedVersionNumbers forKey:kAppliedFixturesVersionNumbersKey];
            added = YES;
        }

    return added;
}


#pragma mark - Fixture methods

- (BOOL)applyFixtureForModelObjectVersion_1
{
    // On the version 1 of the model, the tag entity was added, and an Entry has one tag.

    BOOL success = NO;
    
    // 1. Populate tags entry in the data base
    NSArray *tags = @[@"Other", @"Food", @"Bills", @"Travel", @"Clothing", @"Car", @"Drinks", @"Work", @"House", @"Gadgets", @"Gifts"];
    success = [self.coreDataController createTags:tags];
    
    // 2. Set a default tag for all existent entries.
    success = success && [self.coreDataController setTagForAllEntriesTo:[tags firstObject]];
    
    // 3. isAmountNegative was added to the Entry model and depends on an existent property value
    success = success && [self.coreDataController setIsAmountNegativeFromSignOfAmount];
    
    // 4. Save
    success = success && [self.coreDataController.coreDataHelper.managedObjectContext save:nil];
    
    return success;
}


- (BOOL)applyFixtureForModelObjectVersion_2
{
    // On the version 2 of the model, the tag's imageName was added. Here we populate it
    
    BOOL success = NO;
    
    Tag *other = [self.coreDataController tagForName:@"Other"];
    Tag *food = [self.coreDataController tagForName:@"Food"];
    Tag *bills = [self.coreDataController tagForName:@"Bills"];
    Tag *travel = [self.coreDataController tagForName:@"Travel"];
    Tag *clothing = [self.coreDataController tagForName:@"Clothing"];
    Tag *car = [self.coreDataController tagForName:@"Car"];
    Tag *drinks = [self.coreDataController tagForName:@"Drinks"];
    Tag *work = [self.coreDataController tagForName:@"Work"];
    Tag *house = [self.coreDataController tagForName:@"House"];
    Tag *gadgets = [self.coreDataController tagForName:@"Gadgets"];
    Tag *gifts = [self.coreDataController tagForName:@"Gifts"];
    
    other.iconImageName = @"filter_gifts.png";
    food.iconImageName = @"filter_food.png";
    bills.iconImageName = @"filter_bills.png";
    travel.iconImageName = @"filter_travel.png";
    clothing.iconImageName = @"filter_clothing.png";
    car.iconImageName = @"filter_car.png";
    drinks.iconImageName = @"filter_drinks.png";
    work.iconImageName = @"filter_work.png";
    house.iconImageName = @"filter_house.png";
    gadgets.iconImageName = @"filter_gadgets.png";
    gifts.iconImageName = @"filter_gifts.png";
    
    
    success = [self.coreDataController createTags:@[@"Music", @"Books"]];
    Tag *music = [self.coreDataController tagForName:@"Music"];
    Tag *books = [self.coreDataController tagForName:@"Books"];
    music.iconImageName = @"filter_music.png";
    books.iconImageName = @"filter_books.png";
    
    success = success && [self.coreDataController.coreDataHelper.managedObjectContext save:nil];
    
    return success;
}



@end
