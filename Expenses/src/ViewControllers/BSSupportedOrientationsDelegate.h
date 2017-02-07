//
//  BSSupportedOrientationsDelegate.h
//  Expenses
//
//  Created by Borja Arias Drake on 06/02/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BSSupportedOrientationDelegate <NSObject>

- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForViewController:(UIViewController *)viewController;
- (BOOL)shouldAutorotateViewController:(UIViewController *)viewController;

@end
