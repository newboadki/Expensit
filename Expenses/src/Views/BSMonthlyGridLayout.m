//
//  BSMonthlyGridLayout.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSMonthlyGridLayout.h"

@implementation BSMonthlyGridLayout

- (CGFloat) minimumInteritemSpacing
{
    return 0;
}

- (CGSize) itemSize {
    // We want a section of 4 rows by 3 columns to fill 90% of the screen
    NSInteger numberOfColumns = 3;
    CGFloat numberOfRows = 4;
    CGFloat sectionHeight = self.collectionView.bounds.size.height * 0.90;
    CGFloat cellWidth = (self.collectionView.bounds.size.width / numberOfColumns);
    CGFloat cellHeight = (sectionHeight / numberOfRows);
    return CGSizeMake(cellWidth, cellHeight);

}

@end
