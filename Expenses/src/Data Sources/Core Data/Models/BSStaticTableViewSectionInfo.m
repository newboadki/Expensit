//
//  BSStaticTableViewCellInfo.m
//  Expenses
//
//  Created by Borja Arias Drake on 17/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewSectionInfo.h"

@implementation BSStaticTableViewSectionInfo

- (instancetype)initWithSection:(NSInteger)section cellsInfo:(NSArray *)cellsInfo
{
    self = [super init];
    
    if (self)
    {
        _section = section;
        _cellClassesInfo = cellsInfo;
    }
    
    return self;
}

@end
