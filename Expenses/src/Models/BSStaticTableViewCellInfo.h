//
//  BSStaticTableViewCellInfo.h
//  Expenses
//
//  Created by Borja Arias Drake on 17/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSStaticTableCellValueConvertorProtocol.h"

@interface BSStaticTableViewCellInfo : NSObject

@property (nonatomic, assign) Class cellClass;

@property (nonatomic, copy) NSString *propertyName;

@property (nonatomic, copy) NSString *displayPropertyName;

@property (nonatomic, assign) BOOL shouldBecomeFirstResponderWhenNotEditing;

@property (nonatomic, assign) UIKeyboardType keyboardType;

@property (nonatomic, strong) id<BSStaticTableCellValueConvertorProtocol>valueConvertor;

@property (nonatomic, strong) NSDictionary *extraParams;

- (instancetype)initWithCellClass:(Class)cellClass
                     propertyName:(NSString *)propertyName
              displayPropertyName:(NSString *)displayPropertyName
shouldBecomeFirstResponderWhenNotEditing:(BOOL)firstResponder
                    keyboardType:(UIKeyboardType)keyboardType
                   valueConvertor:(id<BSStaticTableCellValueConvertorProtocol>)valueConvertor
                      extraParams:(NSDictionary *)extraParams;


@end
