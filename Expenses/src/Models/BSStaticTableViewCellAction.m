//
//  BSStaticTableViewCellAction.m
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCellAction.h"

@implementation BSStaticTableViewCellAction

- (instancetype)initWithIndexPaths:(NSArray *)indexPaths action:(SEL)action withObject:(id)object
{
    self = [super init];
    
    if (self)
    {
        _selector = action;
        _object = object;
        _indexPathsOfCellsToPerformActionOn = indexPaths;
    }
    
    return self;
}
@end
