//
//  BSPieChartViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 01/06/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPieChartView.h"



@interface BSPieChartViewController : UIViewController <BSPieChartDataSource, BSPieChartDelegate>

@property (nonatomic, weak) IBOutlet BSPieChartView *pieChartView;

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, weak) IBOutlet UICollectionView *legendsCollectionView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIButton *doneLabel;

@property (nonatomic, weak) IBOutlet UILabel *unitLabel;

@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) NSArray *categories;





- (IBAction) cancelButtonPressed:(id)sender;

@end
