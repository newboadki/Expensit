//
//  BSTableViewCellChangeOfStateEvent.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewCellAbstractEvent.h"

/*! The cell has been interacted with in a way that should cause the unfolding or folding of it.
 This task is actually taken care of by a tableViewController.*/
@interface BSStaticTableViewCellFoldingEvent : BSStaticTableViewCellAbstractEvent

@end
