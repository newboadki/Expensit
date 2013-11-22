//
//  BSTagToSegmentedControlCellConvertor.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableCellValueConvertorProtocol.h"

@class BSCoreDataController;

@interface BSTagToSegmentedControlCellConvertor : NSObject <BSStaticTableCellValueConvertorProtocol>

@property (nonatomic, strong) BSCoreDataController *coreDataController;

@end
