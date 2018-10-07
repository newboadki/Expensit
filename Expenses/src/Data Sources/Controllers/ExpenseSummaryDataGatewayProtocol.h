//
//  ExpenseSummaryDataGatewayProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 17/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

@class BSExpenseEntry;

@protocol ExpenseSummaryDataGatewayProtocol
- (NSDictionary<NSString *, NSArray<BSExpenseEntry *> *> * _Nonnull)entriesGroupedByDay;
- (NSDictionary<NSString *, NSArray<BSExpenseEntry *> *> * _Nonnull)entriesGroupedByMonth;
- (NSDictionary<NSString *, NSArray<BSExpenseEntry *> *> * _Nonnull)entriesGroupedByYear;
- (NSArray<BSExpenseEntry *> * _Nonnull)allEntries;
@end
