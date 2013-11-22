//
//  BSTableViewCellChangeOfValueEvent.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewCellAbstractEvent.h"

@interface BSStaticTableViewCellChangeOfValueEvent : BSStaticTableViewCellAbstractEvent

/*! This property should be ignored for types different than BSTableViewCellChangedStateEvent.*/
@property (nonatomic, strong) id value;

- (instancetype)initWithNewValue:(id)value forPropertyName:(NSString *)propertyName;

@end