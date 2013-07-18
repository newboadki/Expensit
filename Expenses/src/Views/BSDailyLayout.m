//
//  BSDailyLayout.m
//  Expenses
//
//  Created by Borja Arias Drake on 11/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailyLayout.h"

@implementation BSDailyLayout

- (CGFloat) minimumInteritemSpacing
{
    return 0;
}

- (CGFloat) minimumLineSpacing
{
    return 0;
}


- (CGSize) itemSize {
    
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 6.0, 60);
}

@end
