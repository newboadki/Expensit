//
//  ContainmentEvent.h
//  Expenses
//
//  Created by Borja Arias Drake on 30/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ChildControlledContentChanged
} ContainmentEventType;



/**
 Possible events to be distributed by conformers of ContainmentEventsManager.
 */
@interface ContainmentEvent : NSObject
@property (nonatomic, assign) ContainmentEventType type;
@property (nonatomic, copy) NSDictionary *userInfo;

- (instancetype)initWithType:(ContainmentEventType)type userInfo:(NSDictionary *)userInfo;
@end
