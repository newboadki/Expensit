//
//  BSYearlyLayout.m
//  Expenses
//
//  Created by Borja Arias Drake on 12/04/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSYearlyLayout.h"

@implementation BSYearlyLayout

- (CGFloat) minimumInteritemSpacing
{
    return 0;
}

- (CGFloat) minimumLineSpacing
{
    return 0;
}


- (CGSize) itemSize {
    
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
}

@end
