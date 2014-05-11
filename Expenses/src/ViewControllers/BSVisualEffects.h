//
//  BSVisualEffects.h
//  Expenses
//
//  Created by Borja Arias Drake on 29/03/2014.
//  Copyright (c) 2014 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tag;

@interface BSVisualEffects : NSObject

+ (UIImage *)blurredViewImageFromView:(UIView *)originalView;

+ (UIImage *)imageForCategory:(Tag *)tag;

@end
