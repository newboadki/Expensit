//
//  BSDailySummanryEntryCell.m
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailySummanryEntryCell.h"

@implementation BSDailySummanryEntryCell


- (void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor);
    CGContextSetLineWidth(ctx, 0.5);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [path stroke];
}

@end
