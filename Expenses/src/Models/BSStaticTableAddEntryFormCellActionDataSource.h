//
//  BSStaticTableAddEntryFormCellActionDataSource.h
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewCellActionDataSourceProtocol.h"

@class BSCoreDataController;

@interface BSStaticTableAddEntryFormCellActionDataSource : NSObject <BSStaticTableViewCellActionDataSourceProtocol>

@property (nonatomic, strong) BSCoreDataController *coreDataController;

@property (nonatomic, assign) BOOL isEditing;

- (instancetype)initWithCoreDataController:(BSCoreDataController *)coreDataController isEditing:(BOOL)isEditing;

@end
