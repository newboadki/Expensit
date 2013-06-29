//
//  BSCoreDataController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataController.h"
#import "Entry.h"
#import "DateTimeHelper.h"
#import "CoreDataStackHelper.h"

@interface BSCoreDataController ()
@property (strong, nonatomic) NSString *entityName;
@end

@implementation BSCoreDataController


- (id)initWithEntityName:(NSString*)entityName delegate:(id<BSCoreDataControllerDelegateProtocol>)delegate coreDataHelper:(CoreDataStackHelper*)coreDataHelper
{
    self = [super init];
    if (self)
    {
        _entityName = [entityName copy];
        _delegate = delegate;
        _coreDataHelper = coreDataHelper;
    }
    
    return self;
}


- (void)insertNewEntry:(NSString*)dateString description:(NSString*)description value:(NSString*)value
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure

    newManagedObject.date = [DateTimeHelper dateWithFormat:[DEFAULT_DATE_FORMAT copy] stringDate:dateString];
    
    
    NSArray *components = [dateString componentsSeparatedByString:@"/"];
    int scannedNumber;
    NSScanner *scanner = [NSScanner scannerWithString:components[0]];
    [scanner scanInt:&scannedNumber];
    NSNumber *number = [NSNumber numberWithInt:scannedNumber];
    newManagedObject.day = number;
    
    
    scanner = [NSScanner scannerWithString:components[1]];
    [scanner scanInt:&scannedNumber];
    number = [NSNumber numberWithInt:scannedNumber];
    newManagedObject.month = number;
    
    scanner = [NSScanner scannerWithString:components[2]];
    [scanner scanInt:&scannedNumber];
    number = [NSNumber numberWithInt:scannedNumber];
    newManagedObject.year = number;
    
    newManagedObject.desc = description;
    newManagedObject.value = [NSDecimalNumber decimalNumberWithString:value];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure    
    newManagedObject.date = date;
    newManagedObject.day = [NSNumber numberWithInt:[DateTimeHelper dayOfDateUsingCurrentCalendar:date]];
    newManagedObject.month = [NSNumber numberWithInt:[DateTimeHelper monthOfDateUsingCurrentCalendar:date]];;
    newManagedObject.year = [NSNumber numberWithInt:[DateTimeHelper yearOfDateUsingCurrentCalendar:date]];;    
    newManagedObject.desc = description;
    newManagedObject.value = [NSDecimalNumber decimalNumberWithString:value];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}



@end
