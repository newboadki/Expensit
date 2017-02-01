//
//  BSNavigationControllerViewController.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/07/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSNavigationControllerViewController.h"

@interface BSNavigationControllerViewController ()

@end

@implementation BSNavigationControllerViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)handleEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender {
    
    // Simply pass it down to the top view controller if pertinent.
    if ([self.topViewController conformsToProtocol:@protocol(ContainmentEventHandler)]) {
        id <ContainmentEventHandler> handler = (id<ContainmentEventHandler>)self.topViewController;
        handler.containmentEventsDelegate = self.containmentEventsDelegate;
        [handler handleEvent:event fromSender:sender];
    }
}

@end
