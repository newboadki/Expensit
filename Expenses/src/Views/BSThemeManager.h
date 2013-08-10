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

@interface BSThemeManager : NSObject

@property (strong, nonatomic) id<BSUIThemeProtocol> theme;

+ (BSThemeManager *)manager;

- (void)applyTheme;

@end
