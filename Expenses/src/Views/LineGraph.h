//
//  MyView.h
//  lineCharts
//
//  Created by Borja Arias Drake on 02/05/2011.
//  Copyright 2011 Unboxed Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineGraphDataSourceProtocol
- (NSArray*) moneyIn;
- (NSArray*) moneyOut;
- (NSArray*) xValues;
@end


@interface LineGraph : UIView

@property (assign, nonatomic) IBOutlet id <LineGraphDataSourceProtocol> dataSource;

@end
