//
//  BSNavigationControllerViewController.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainmentEventsAPI.h"

@interface BSNavigationControllerViewController : UINavigationController <ContainmentEventHandler>

@property (nonatomic) id<ContainmentEventsManager> containmentEventsDelegate;

@end
