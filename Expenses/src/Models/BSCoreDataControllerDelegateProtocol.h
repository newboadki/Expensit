//
//  BSCoreDataControllerDelegateProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 22/06/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BSCoreDataControllerDelegateProtocol <NSObject>
- (void) configureFetchRequest:(NSFetchRequest*)request;
- (NSString*) sectionNameKeyPath;
@end
