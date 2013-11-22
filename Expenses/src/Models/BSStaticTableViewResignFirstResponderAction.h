//
//  BSStaticTableViewResignFirstResponderAction.h
//  Expenses
//
//  Created by Borja Arias Drake on 13/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewAbstractAction.h"

@interface BSStaticTableViewResignFirstResponderAction : BSStaticTableViewAbstractAction
@property (nonatomic, strong) NSArray *indexPathsToResignFirstResponder;
@end
