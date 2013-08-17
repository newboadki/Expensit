//
//  BSCoreDataController.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSCoreDataControllerDelegateProtocol.h"
#import "Entry.h"

@class CoreDataStackHelper;

@interface BSCoreDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CoreDataStackHelper *coreDataHelper;
@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (weak, nonatomic)   id <BSCoreDataControllerDelegateProtocol> delegate;

- (id)initWithEntityName:(NSString*)entityName delegate:(id<BSCoreDataControllerDelegateProtocol>)delegate coreDataHelper:(CoreDataStackHelper*)coreDataHelper;
- (void) insertNewEntryWithDate:(NSDate*)date description:(NSString*)description value:(NSString*)value;
- (Entry *) newEntry;
- (BOOL) saveEntry:(Entry *)entry withNegativeAmount:(BOOL)isNegative;
@end
