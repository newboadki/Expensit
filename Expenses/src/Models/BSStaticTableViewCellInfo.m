//
//  BSStaticTableViewCellInfo.m
//  Expenses
//
//  Created by Borja Arias Drake on 17/10/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSStaticTableViewCellInfo.h"

@implementation BSStaticTableViewCellInfo

- (instancetype)initWithCellClass:(Class)cellClass
                     propertyName:(NSString *)propertyName
              displayPropertyName:(NSString *)displayPropertyName
shouldBecomeFirstResponderWhenNotEditing:(BOOL)firstResponder
                     keyboardType:(UIKeyboardType)keyboardType
                   valueConvertor:(id<BSStaticTableCellValueConvertorProtocol>)valueConvertor
                      extraParams:(NSDictionary *)extraParams
{
    self = [super init];
    
    if (self)
    {
        _cellClass = cellClass;
        _propertyName = [propertyName copy];
        _displayPropertyName = [displayPropertyName copy];
        _shouldBecomeFirstResponderWhenNotEditing = firstResponder;
        _keyboardType = keyboardType;
        _valueConvertor = valueConvertor;
        _extraParams = extraParams;
    }
    
    return self;

}

@end
