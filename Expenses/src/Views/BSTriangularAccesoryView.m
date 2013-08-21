//
//  BSTriangularAccesoryView.m
//  Expenses
//
//  Created by Borja Arias Drake on 18/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSTriangularAccesoryView.h"

@implementation BSTriangularAccesoryView


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, (self.bounds.size.height/2.0))];
    [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];
    [path fill];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}
@end
