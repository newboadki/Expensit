//
//  BSStaticTableViewCellSectionProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 17/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSStaticTableViewCellInfo;


@protocol BSStaticTableViewSectionInfoProtocol <NSObject>

- (NSArray *)sectionsInfo;
- (BSStaticTableViewCellInfo *)cellInfoForIndexPath:(NSIndexPath *)indepath;

@end
