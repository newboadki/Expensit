//
//  BSTableViewCellEvent.h
//  Expenses
//
//  Created by Borja Arias Drake on 09/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BSStaticTableViewCellAbstractEvent : NSObject

@property (nonatomic, strong) NSIndexPath *indexPath;

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath;

@end
