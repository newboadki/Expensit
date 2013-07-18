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


    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 4.0, 94);
}
@end
