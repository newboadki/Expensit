//
//  BSGreenTheme.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSGreenTheme.h"

@implementation BSGreenTheme



- (UIColor *)navigationBarBackgroundColor
{
    return [UIColor colorWithRed:12.0/256.0 green:34.0/256.0 blue:11.0/256.0 alpha:1.0];
}


- (UIColor *)navigationBarTextColor
{
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (UIColor *)redColor
{
    return [UIColor colorWithRed:199.0/255.0 green:43.0/255.0 blue:49.0/255.0 alpha:1.0];
}

- (UIColor *)greenColor
{
    return [UIColor colorWithRed:86.0/255.0 green:130.0/255.0 blue:61.0/255.0 alpha:1.0];
}

- (UIColor *)blueColor
{
    return [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (UIColor *)selectedCellColor
{
    return [UIColor colorWithRed:86.0/255.0 green:130.0/255.0 blue:61.0/255.0 alpha:0.2];
}

@end
