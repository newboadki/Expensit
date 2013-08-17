//
//  BSUIThemeProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BSUIThemeProtocol <NSObject>
- (UIColor *)navigationBarBackgroundColor;
- (UIColor *)navigationBarTextColor;
- (UIColor *)redColor;
- (UIColor *)greenColor;
- (UIColor *)blueColor;
@end
