//
//  BSStaticTableCellValueAdaptorProtocol.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/11/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!BSStaticCells can have any kind form, i.e. a segmented control, a text field, etc. Therefore, the kind of value the cell understands in order to
 programatically change its state is different. For example a segmented controller Cell to represent categories of an entity understands that
 needs to select the segment at index 4 but it will not understand what index to select if it's passed a particular instance of a Category.
 This protocol comes in to decouple the cell and it's internal values from the ones that a user of the cell might understand.*/
@protocol BSStaticTableCellValueConvertorProtocol <NSObject>

/*!
 @param propertyName
 @param indexPath
 @param modelValue
 @retun The value that the cell will understand for the given modelValue in order to update it's visual state.*/
- (id)cellValueForModelValue:(id)modelValue;

/*!
 @param propertyName
 @param indexPath
 @param modelValue
 @retun The value that the model will understand for the given cellValue.*/
- (id)modelValueForCellValue:(id)cellValue;

@end
