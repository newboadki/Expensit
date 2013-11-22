//
//  BSEntryDetailCell.h
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSStaticTableViewCellInfo.h"
#import "BSStaticTableViewCellAbstractEvent.h"
#import "BSStaticTableViewComponentConstants.h"
#import "BSStaticTableCellValueConvertorProtocol.h"

@protocol BSTableViewExpandableCell <NSObject>

- (void)setUpForFoldedState;

- (void)setUpForUnFoldedState;

@end


@protocol BSStaticTableViewCellDelegateProtocol <NSObject>
- (void) cell:(UITableViewCell *)cell eventOccurred:(BSStaticTableViewCellAbstractEvent *)event;
- (void) textFieldShouldreturn;
@end

@interface BSStaticTableViewCell : UITableViewCell

@property (strong, nonatomic) id entryModel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSString *modelProperty;
@property (strong, nonatomic) id<BSStaticTableCellValueConvertorProtocol> valueConvertor;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (strong, nonatomic) IBOutlet id<BSStaticTableViewCellDelegateProtocol> delegate;


- (void) becomeFirstResponder;
- (void) resignFirstResponder;
- (void) reset;
- (void) configureWithCellInfo:(BSStaticTableViewCellInfo *)cellInfo andModel:(id)model;
- (void)updateValuesFromModel;

@end
