//
//  ContainmentEventsAPI.h
//  Expenses
//
//  Created by Borja Arias Drake on 19/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//


/// Possible events to be distributed by conformers of ContainmentEventsManager
@protocol ContainmentEvent <NSObject>
@end

@protocol ContainmentEventSource <NSObject>
@end

/// Conformer objects will know how to distribute a given event among instances confirming to ContainmentEventHandler
@protocol ContainmentEventsManager <NSObject>
- (void)raiseEvent:(id<ContainmentEvent>)event fromSender:(id<ContainmentEventSource>)sender;
@end


/// Implemented by objects that want to receive and send viewController containment-related events
@protocol ContainmentEventHandler <NSObject>

@property (nonatomic) id<ContainmentEventsManager> containmentEventsDelegate;
- (void)handleEvent:(id<ContainmentEvent>)event fromSender:(id<ContainmentEventSource>)sender;
@end
