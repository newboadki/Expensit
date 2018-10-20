//
//  BSVisualEffects.m
//  Expenses
//
//  Created by Borja Arias Drake on 29/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import "BSVisualEffects.h"
#import "UIImage+ImageEffects.h"

@implementation BSVisualEffects

+ (UIImage *)blurredViewImageFromView:(UIView *)originalView
{
    UIImage *image =[[self screenshotFromView:originalView] applyLightEffect];
    return image;
}


+ (UIImage *)screenshotFromView:(UIView *)originalView
{
    CGSize size = originalView.frame.size;
    CGRect rect = originalView.frame;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    [originalView drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshot;
}


@end
