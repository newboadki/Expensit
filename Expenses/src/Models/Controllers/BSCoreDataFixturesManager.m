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
    BOOL shouldApplyFixture = [self addVersionNumberToAppliedFixturesInUserDefaults:currentVersion]; // If it's been added is because it didn't exist, therefore we need to apply a fixture
    if (shouldApplyFixture)
    {
        self.coreDataController = coreDataController;
        [self applyFixtureForVersion:currentVersion];
    }
    
    return YES;
}

- (BOOL)applyFixtureForVersion:(NSNumber *)version
{
    NSString *selectorName = [NSString stringWithFormat:@"%@_%@", kApplyFixtureMethodName, [version stringValue]];
    [self performSelector:NSSelectorFromString(selectorName)];
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
    NSArray *tags = @[@"Other", @"Food", @"Bills", @"Travel", @"Cloth."];
    success = [self.coreDataController createTags:tags];
    
    // 2. Set a default tag for all existent entries.
    success = success && [self.coreDataController setTagForAllEntriesTo:[tags firstObject]];
    
    // 3. isAmountNegative was added to the Entry model and depends on an existent property value
    success = success && [self.coreDataController setIsAmountNegativeFromSignOfAmount];
    
    // 4. Save
    success = success && [self.coreDataController.coreDataHelper.managedObjectContext save:nil];
    
    return success;
}

@end
