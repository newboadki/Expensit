//
//  BSBaseExpensesSummaryViewController+Protected.h
//  Expenses
//
//  Created by Borja Arias Drake on 18/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#ifndef Expenses_BSBaseExpensesSummaryViewController_Protected_h
#define Expenses_BSBaseExpensesSummaryViewController_Protected_h

#import "BSGraphViewController.h"

@interface BSBaseExpensesSummaryViewController (Protected)
- (NSFetchRequest*) fetchRequest;
- (NSFetchRequest *) graphFetchRequest;
//- (NSFetchRequest *) graphSurplusFetchRequest;
//- (NSFetchRequest *) graphExpensesFetchRequest;
- (NSArray *) dataForGraphWithFetchRequestResults:(NSArray*) results;
@end
#endif
