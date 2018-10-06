//
//  BSAppDelegate.h
//  Expenses
//
//  Created by Borja Arias Drake on 21/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSThemeManager.h"

@class CoreDataStackHelper;
@class BSCoreDataFetchController;

@interface BSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CoreDataStackHelper *coreDataHelper;
@property (strong, nonatomic) BSThemeManager *themeManager;
@property (strong, nonatomic) BSCoreDataFetchController *coreDataFetchController;
@end
 
