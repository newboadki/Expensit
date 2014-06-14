//
//  BSDailyEntryHeaderView.h
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSHeaderButton.h"

@interface BSDailyEntryHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet BSHeaderButton *pieChartButton;

@end
