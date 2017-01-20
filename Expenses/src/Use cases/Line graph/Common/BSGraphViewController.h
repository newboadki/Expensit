//
//  BSGraphViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineGraph.h"
#import "ContainmentEventsAPI.h"

@protocol BSGraphLinePresenterProtocol;

@interface BSGraphViewController : UIViewController <LineGraphDataSourceProtocol, LineGraphCurrencyFormatterProtocol, ContainmentEventSource, ContainmentEventHandler>
@property (strong, nonatomic, nonnull) NSArray *moneyIn;
@property (strong, nonatomic, nonnull) NSArray *moneyOut;
@property (strong, nonatomic, nonnull) NSArray *xValues;
@property (strong, nonatomic, nullable) NSString *graphTitle;

@property (strong, nonatomic, nullable) id<BSGraphLinePresenterProtocol> lineGraphPresenter;
@property (nonatomic, nullable) id<ContainmentEventsManager> containmentEventsDelegate;
@end
