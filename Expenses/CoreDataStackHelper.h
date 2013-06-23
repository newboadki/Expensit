//
//  CoreDataStackHelper.h
//  I_will_test_my_apps
//
//  Created by Borja Arias Drake on 30/08/2010.
//  Copyright 2010 Borja Arias Drake. All rights reserved.
//

// This class intends to be a generic entry point to the CoreData Stack. No more accessing the context through
// the application delegate.


#import <CoreData/CoreData.h>

@interface CoreDataStackHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext         *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel           *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator   *persistentStoreCoordinator;
@property (nonatomic, strong)           NSString					   *storeType;
@property (nonatomic, strong)           NSString					   *resourceName;
@property (nonatomic, strong)           NSString					   *resourceExtension;

- (id) initWithPersitentStoreType:(NSString*)storeType
                     resourceName:(NSString*)name
                        extension:(NSString*)extension;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
