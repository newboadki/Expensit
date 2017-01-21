//
//  BSCoreDataFixturesManager.m
//  Expenses
//
//  Created by Borja Arias Drake on 12/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataFixturesManager.h"
#import "CoreDataStackHelper.h"
#import "Tag.h"

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
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(selectorName)];
        #pragma clang diagnostic pop
    }

    return YES;
}

- (NSArray *)appliedFixturesVersionNumbersFromUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults arrayForKey:kAppliedFixturesVersionNumbersKey];
}

- (BOOL)addVersionNumberToAppliedFixturesInUserDefaults:(NSNumber *)version
{
    BOOL added = NO;

    NSArray *appliedVersionNumbers = [self appliedFixturesVersionNumbersFromUserDefaults];
    
        if (![appliedVersionNumbers containsObject:version])
        {
            NSMutableArray *extendedArray = [NSMutableArray arrayWithArray:appliedVersionNumbers];
            [extendedArray addObject:version];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:extendedArray forKey:kAppliedFixturesVersionNumbersKey];
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

    // Add the images for the existing categories
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
    
    
    // Create two new categories and set images for them
    success = [self.coreDataController createTags:@[@"Music", @"Books"]];
    Tag *music = [self.coreDataController tagForName:@"Music"];
    Tag *books = [self.coreDataController tagForName:@"Books"];
    music.iconImageName = @"filter_music.png";
    books.iconImageName = @"filter_books.png";
    
    // Save the changes
    success = success && [self.coreDataController.coreDataHelper.managedObjectContext save:nil];
    
    return success;
}


- (BOOL)applyFixtureForModelObjectVersion_3
{
    // On the version 3
    //   - We added a color property to the entity model
    //   - Also there was a bug that was making tag default to nil if the picker wasn't selected
    
    BOOL success = NO;
    
    // Add the images for the existing categories
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
    Tag *music = [self.coreDataController tagForName:@"Music"];
    Tag *books = [self.coreDataController tagForName:@"Books"];

    
    other.color = [UIColor colorWithRed:87.0/255.0 green:83.0/255.0 blue:93.0/255.0 alpha:1.0];
    food.color = [UIColor colorWithRed:250.0/255.0 green:178.0/255.0 blue:122.0/255.0 alpha:1.0];
    bills.color = [[UIColor colorWithRed:181.0/255.0 green:34.0/255.0 blue:40.0/255.0 alpha:1.0] colorWithAlphaComponent:0.8];
    travel.color = [UIColor colorWithRed:94.0/255.0 green:184.0/255.0 blue:192.0/255.0 alpha:1.0];
    clothing.color = [UIColor colorWithRed:104.0/255.0 green:77.0/255.0 blue:148.0/255.0 alpha:1.0];
    car.color = [UIColor colorWithRed:158.0/255.0 green:50.0/255.0 blue:12.0/255.0 alpha:1.0];
    drinks.color = [UIColor colorWithRed:253.0/255.0 green:235.0/255.0 blue:1.0/255.0 alpha:1.0];
    work.color = [UIColor colorWithRed:55.0/255.0 green:72.0/255.0 blue:98.0/255.0 alpha:1.0];
    house.color = [UIColor colorWithRed:133.0/255.0 green:105.0/255.0 blue:104.0/255.0 alpha:1.0];
    gadgets.color = [UIColor colorWithRed:236.0/255.0 green:110.0/255.0 blue:69.0/255.0 alpha:1.0];
    gifts.color = [UIColor colorWithRed:162.0/255.0 green:124.0/255.0 blue:165.0/255.0 alpha:1.0];
    music.color = [UIColor colorWithRed:232.0/255.0 green:94.0/255.0 blue:120.0/255.0 alpha:1.0];
    books.color = [UIColor colorWithRed:166.0/255.0 green:120.0/255.0 blue:105.0/255.0 alpha:1.0];
    
    
    // Set categories without tag to Other Tag
    success = [self.coreDataController setOtherTagForAllEntriesWithoutTag];
    
    
    // Create new category
    success = success && [self.coreDataController createTags:@[@"Income"]];
    Tag *income = [self.coreDataController tagForName:@"Income"];
    income.color = [[UIColor colorWithRed:75.0/255.0 green:99.0/255.0 blue:51.0/255.0 alpha:1.0] colorWithAlphaComponent:0.8];
    income.iconImageName = @"filter_bills.png";
    
    // Save the changes
    success = success && [self.coreDataController.coreDataHelper.managedObjectContext save:nil]; // use [self.coreDataController save:nil] instead;
    
    return success;
}



@end
