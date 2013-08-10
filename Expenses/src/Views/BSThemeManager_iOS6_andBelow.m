//
//  BSThemeManager_iOS6_andBelow.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSThemeManager_iOS6_andBelow.h"
#import "BSThemeManager+Protected.h"

@implementation BSThemeManager_iOS6_andBelow


- (void)applyThemeToNavigationBar
{
    // Text
    [[UILabel appearanceWhenContainedIn:[UINavigationBar class], nil] setTextColor:self.theme.navigationBarTextColor];
    
    // Background
    [[UINavigationBar appearance] setTintColor:self.theme.navigationBarBackgroundColor];
}


@end
