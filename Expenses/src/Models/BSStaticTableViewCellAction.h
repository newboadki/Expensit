//
//  BSStaticTableViewCellAction.h
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewAbstractAction.h"

@interface BSStaticTableViewCellAction : BSStaticTableViewAbstractAction

@property (nonatomic, strong) NSArray *indexPathsOfCellsToPerformActionOn;

@property (nonatomic, assign) SEL selector;

@property (nonatomic, strong) id object;

- (instancetype)initWithIndexPaths:(NSArray *)indexPaths action:(SEL)action withObject:(id)object;

@end
