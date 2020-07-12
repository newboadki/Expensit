//
//  BSCoreDataFixturesManager.h
//  Expenses
//
//  Created by Borja Arias Drake on 12/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCoreDataFixturesManager : NSObject

/*!
 Checks the current version, looks for any pending fixture migrations and 
 fills the data base with the correspondingData.*/
- (BOOL)applyMissingFixturesOnManagedObjectModel:(NSManagedObjectModel *)model coreDataController:(BSCoreDataController *)coreDataController;

@end
