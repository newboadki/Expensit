//
//  Header.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/10/16.
//  Copyright © 2016 Borja Arias Drake. All rights reserved.
//


@class BSExpenseCategory;

@protocol BSCategoryFilterDelegate <NSObject>

- (void)filterChangedToCategory:(BSExpenseCategory * _Nullable)category;

@end
