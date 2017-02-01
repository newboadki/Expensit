//
//  ContainmentEvent.m
//  Expenses
//
//  Created by Borja Arias Drake on 30/01/2017.
//  Copyright © 2017 Borja Arias Drake. All rights reserved.
//

#import "ContainmentEvent.h"

@implementation ContainmentEvent

- (instancetype)initWithType:(ContainmentEventType)type userInfo:(NSDictionary *)userInfo {
    if (self = [super init]) {
        _type = type;
        _userInfo = [userInfo copy];
    }
    
    return self;
}
@end
