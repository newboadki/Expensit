//
//  ContainmentEventsAPI.h
//  Expenses
//
//  Created by Borja Arias Drake on 19/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//



#import "ContainmentEvent.h"


@protocol ContainmentEventSource <NSObject>
@end


/**
 Conformer objects will know how to distribute a given event among instances confirming to ContainmentEventHandler.
 */
@protocol ContainmentEventsManager <NSObject>
- (void)raiseEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender;
@end



/**
 Implemented by objects that want to receive and send viewController containment-related events.
 */
@protocol ContainmentEventHandler <NSObject>

@property (nonatomic) id<ContainmentEventsManager> containmentEventsDelegate;
- (void)handleEvent:(ContainmentEvent *)event fromSender:(id<ContainmentEventSource>)sender;
@end
