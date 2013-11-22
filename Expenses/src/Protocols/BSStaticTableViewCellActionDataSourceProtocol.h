//
//  BSStaticTableViewCellActionDataSourceProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 05/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableCellValueConvertorProtocol.h"

@class BSStaticTableViewCellAction;
@class BSStaticTableViewCellInfo;
@class BSStaticTableViewCellAbstractEvent;
@class BSStaticTableViewAbstractAction;

@protocol BSStaticTableViewCellActionDataSourceProtocol <NSObject>

/*! @return an array of BSStaticTableViewAbstractAction that describe
 what the table view needs to do when an event occurs.
 */
- (NSArray *)actionsForEvent:(BSStaticTableViewCellAbstractEvent *)event inCellAtIndexPath:(NSIndexPath *)indexPath;

/*! 
 @return An array of BSStaticTableViewSectionInfo instances.
 */
- (NSArray *)sectionsInfo;

/*!
 This is a convenience method that should be consistent with sectionsForInfo.
 */
- (BSStaticTableViewCellInfo *)cellInfoForIndexPath:(NSIndexPath *)indepath;

/*!
 The class conforming to this protocol, has a deep knowledge about what the cells are.
 Therefore, it also needs to provide data convertors between the model property that the cell modifies and the cell's own internal representation of the data.
 This method needs to be consistent with what sectionsInfo returns.
 */
- (id<BSStaticTableCellValueConvertorProtocol>)valueConvertorForCellAtIndexPath:(NSIndexPath *)indexPath;

//- (NSIndexPath *)indexPathForCellWithPropertyName:(NSString *)propertyName;

@end
