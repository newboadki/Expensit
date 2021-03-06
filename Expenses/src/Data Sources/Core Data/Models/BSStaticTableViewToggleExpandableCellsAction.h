//
//  BSStaticTableViewAction.h
//  Expenses
//
//  Created by Borja Arias Drake on 12/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewAbstractAction.h"

@interface BSStaticTableViewToggleExpandableCellsAction : BSStaticTableViewAbstractAction

@property (nonatomic, strong) NSArray *indexPaths;

- (instancetype)initWithIndexPaths:(NSArray *)indexPaths;

@end
