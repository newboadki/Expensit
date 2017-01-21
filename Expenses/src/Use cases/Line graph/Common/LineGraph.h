//
//  MyView.h
//  lineCharts
//
//  Created by Borja Arias Drake on 02/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineGraphDataSourceProtocol
- (nonnull NSArray*) moneyIn;
- (nonnull NSArray*) moneyOut;
- (nonnull NSArray*) xValues;
- (nullable NSString *) graphTitle;
@end

@protocol LineGraphCurrencyFormatterProtocol
- (nonnull NSString *)formattedStringForNumber:(nonnull NSNumber *)number;
@end


@interface LineGraph : UIView

@property (assign, nonatomic, nullable) IBOutlet id <LineGraphDataSourceProtocol> dataSource;
@property (assign, nonatomic, nullable) IBOutlet id <LineGraphCurrencyFormatterProtocol> currencyFormatter;

@end
