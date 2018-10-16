//
//  ExpenseSummaryDataGatewayProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 17/12/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

@class Expense;

@protocol ExpenseSummaryDataGatewayProtocol
- (NSDictionary<NSString *, NSArray<Expense *> *> * _Nonnull)entriesGroupedByDay;
- (NSDictionary<NSString *, NSArray<Expense *> *> * _Nonnull)entriesGroupedByMonth;
- (NSDictionary<NSString *, NSArray<Expense *> *> * _Nonnull)entriesGroupedByYear;
- (NSArray<Expense *> * _Nonnull)allEntries;
@end
