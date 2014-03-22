//
//  BSThemeManager.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSThemeManager+Protected.h"
#import "BSThemeManager_iOS6_andBelow.h"
#import "BSThemeManager_iOS7.h"

#import "BSCells.h"

@implementation BSThemeManager

+ (BSThemeManager *) manager
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSNumber *versionNumber = [NSDecimalNumber decimalNumberWithString:version];
    NSComparisonResult result = [versionNumber compare:@7];
    BSThemeManager *manager = nil;
    
    if (result == NSOrderedAscending)
    {
        // iOS6 or lower
        manager = [[BSThemeManager_iOS6_andBelow alloc] init];
    }
    else if (result == NSOrderedSame || result == NSOrderedDescending)
    {
        // iOs7
        manager = [[BSThemeManager_iOS7 alloc] init];
    }
    
    return manager;
    
}


- (void)applyTheme
{
    [self applyThemeToNavigationBar];
}


- (void)themeTableViewCell:(UITableViewCell *)cell
{
    if ([cell isKindOfClass:[BSEntryTextDetail class]])
    {
        ((BSEntryTextDetail *)cell).positiveSignColor = [self.theme greenColor];
        ((BSEntryTextDetail *)cell).negativeSignColor = [self.theme redColor];
    }
    else if ([cell isKindOfClass:[BSStaticTableViewCell class]])
    {
        ((BSStaticTableViewCell *)cell).selectedTintColor = [self.theme redColor];
        ((BSStaticTableViewCell *)cell).tintColor = [self.theme blueColor];
    }

}

@end
