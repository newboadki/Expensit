//
//  BSStaticTableViewCellInfo.h
//  Expenses
//
//  Created by Borja Arias Drake on 17/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableViewSectionInfoProtocol.h"

/*! The purpose of this class is to wrap the information about the kind of cells
 in a section for an instance of BSStaticTableViewController class*/
@interface BSStaticTableViewSectionInfo : NSObject

/*! Index of the section in the tableView.*/
@property (nonatomic, assign) NSInteger section;

/*! List of instances of BSStaticTableViewCellInfo.*/
@property (nonatomic, strong) NSArray *cellClassesInfo;


- (instancetype)initWithSection:(NSInteger)section cellsInfo:(NSArray *)cellsInfo;

@end

