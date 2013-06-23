//
//  BSCoreDataController.m
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSCoreDataController.h"
#import "Entry.h"
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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create the request
    NSFetchRequest *fetchRequest = [self fetchRequest];
    
    // FetchedResultsController
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.coreDataHelper.managedObjectContext
                                                                      sectionNameKeyPath:self.delegate.sectionNameKeyPath
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    // Execute the request
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error fetching results. %@, %@", error, [error userInfo]);
	    abort();
	}
    else
    {
        
    }
    
    return _fetchedResultsController;
}

- (void)insertNewEntry:(NSString*)desc
{
    NSManagedObjectContext *context = self.coreDataHelper.managedObjectContext;
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Entry *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // Configure
    newManagedObject.date = [NSDate date];
    newManagedObject.desc = desc;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (NSFetchRequest*) fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.coreDataHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Configure the request
    [self.delegate configureFetchRequest:fetchRequest];
    
    return fetchRequest;
}

@end
