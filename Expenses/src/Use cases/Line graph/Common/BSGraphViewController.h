//
//  BSGraphViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineGraph.h"

@protocol BSGraphLinePresenterProtocol;

@interface BSGraphViewController : UIViewController <LineGraphDataSourceProtocol, LineGraphCurrencyFormatterProtocol>
@property (strong, nonatomic, nonnull) NSArray *moneyIn;
@property (strong, nonatomic, nonnull) NSArray *moneyOut;
@property (strong, nonatomic, nonnull) NSArray *xValues;
@property (strong, nonatomic, nullable) NSString *graphTitle;

@property (strong, nonatomic, nullable) id<BSGraphLinePresenterProtocol> lineGraphPresenter;
@end
