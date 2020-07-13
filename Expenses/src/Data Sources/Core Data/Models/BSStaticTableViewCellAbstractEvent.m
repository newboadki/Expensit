//
//  BSTableViewCellEvent.m
//  Expenses
//
//  Created by Borja Arias Drake on 09/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCellAbstractEvent.h"


@implementation BSStaticTableViewCellAbstractEvent

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    
    if (self)
    {
        _indexPath = indexPath;
    }
    
    return self;
}

@end
