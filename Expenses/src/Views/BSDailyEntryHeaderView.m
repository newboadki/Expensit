//
//  BSDailyEntryHeaderView.m
//  Expenses
//
//  Created by Borja Arias Drake on 23/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSDailyEntryHeaderView.h"

@implementation BSDailyEntryHeaderView

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw a gradient
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(0.0, self.bounds.size.height);
    CGContextDrawLinearGradient(context, [self backgroundGradient], startPoint, endPoint, 0);
    
    UIBezierPath *stripePath = [UIBezierPath bezierPath];
    [stripePath moveToPoint:CGPointMake(0, 0)];
    [stripePath addLineToPoint:CGPointMake(2, 0)];
    [stripePath addLineToPoint:CGPointMake(-5, self.bounds.size.height)];
    [stripePath addLineToPoint:CGPointMake(-7, self.bounds.size.height)];
    [stripePath addLineToPoint:CGPointMake(0, 0)];

    
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:83.0/255 green:130.0/255 blue:61.0/255 alpha:1.0].CGColor);
    
    
    CGContextSaveGState(context);
    for (int i = 0; i<120; i++) {
        [stripePath fill];
        CGContextTranslateCTM(context, 4, 0);
    }
    
    CGContextRestoreGState(context);
    
    // Draw a Mask
    CGPoint maskStartPoint = CGPointMake(0.0, self.bounds.size.height/2.0);
    CGPoint maskEndPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height/2.0);
    CGContextDrawLinearGradient(context, [self maskGradient], maskStartPoint, maskEndPoint, 0);

    
    
}


- (CGGradientRef) backgroundGradient
{
    
    CGFloat colors[16] = {
        137.0/255, 178.0/255, 102.0/255, 1.0,
        137.0/255, 178.0/255, 102.0/255, 1.0,

        150.0/255, 229.0/255, 41.0/255, 0.3,
        150.0/255, 229.0/255, 41.0/255, 0.3
    };

    
//    CGFloat colors[16] = {
//        150.0/255, 229.0/255, 110.0/255, 0.3,
//        127.0/255, 194.0/255, 93.0/255, 0.3,
//        105.0/255, 161.0/255, 77.0/255, 0.3,
//        83.0/255, 130.0/255, 61.0/255, 0.3
//        };

    CGFloat locations[4] = {0.0, 0.5f, 0.5f, 0.75f};
//    CGFloat locations[2] = {0.0f, 0.5f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    

    
    return gradient;
}


- (CGGradientRef) maskGradient
{
    CGFloat colors[16] = {
        137.0/255, 178.0/255, 102.0/255, 1.0,
        137.0/255, 178.0/255, 102.0/255, 0.5,
        
        150.0/255, 229.0/255, 41.0/255, 0.3,
        150.0/255, 229.0/255, 41.0/255, 0.3
    };
    
    CGFloat locations[4] = {0.0, 0.25f, 0.5f, 0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}






@end
