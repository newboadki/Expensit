//
//  BSPieChartViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 01/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPieChartView.h"


@protocol BSPieGraphPresenterProtocol;



@interface BSPieChartViewController : UIViewController <BSPieChartDataSource, BSPieChartDelegate>

@property (strong, nonatomic, nullable) id<BSPieGraphPresenterProtocol> pieGraphPresenter;

@property (nonatomic, weak, nullable) IBOutlet BSPieChartView *pieChartView;

@property (nonatomic, weak, nullable) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, weak, nullable) IBOutlet UICollectionView *legendsCollectionView;

@property (nonatomic, weak, nullable) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak, nullable) IBOutlet UIButton *doneLabel;

@property (nonatomic, weak, nullable) IBOutlet UILabel *unitLabel;


- (IBAction)cancelButtonPressed:(nonnull id)sender;

@end
