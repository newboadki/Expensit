//
//  BSThemeManager.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUIThemeProtocol.h"
#import "BSThemeManager.h"
#import "BSStaticFormTableViewAppearanceDelegateProtocol.h"


typedef NS_ENUM(NSInteger, BSThemeStyles) {
    kThemeOverallStyle,
};

@interface BSThemeManager : NSObject <BSStaticFormTableViewAppearanceDelegateProtocol>

@property (strong, nonatomic) id<BSUIThemeProtocol> theme;

+ (BSThemeManager *)manager;

- (void)applyTheme;

- (void)themeTableViewCell:(UITableViewCell *)cell;

@end
