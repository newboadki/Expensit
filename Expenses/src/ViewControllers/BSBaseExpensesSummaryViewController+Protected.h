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
#import "BSAnimatedBlurEffectTransitioningDelegate.h"

@interface BSBaseExpensesSummaryViewController ()

@property (nonatomic, strong) BSAnimatedBlurEffectTransitioningDelegate *animatedBlurEffectTransitioningDelegate;

- (NSFetchRequest*)fetchRequest;
- (NSFetchRequest *)graphFetchRequest;
- (NSString*)sectionNameKeyPath;
- (NSArray *)graphSurplusResults;
- (NSArray *)graphExpensesResults;
- (NSArray *)dataForGraphWithFetchRequestResults:(NSArray*) results;
@end
#endif
