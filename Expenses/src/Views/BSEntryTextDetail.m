//
//  BSEntryTextDetail.m
//  Expenses
//
//  Created by Borja Arias Drake on 10/08/2013.
//  Copyright (c) 2013 Borja Arias Drake. All rights reserved.
//

#import "BSEntryTextDetail.h"
#import <objc/runtime.h>
#import "BSAppDelegate.h"

@implementation BSEntryTextDetail

@synthesize entryModel = _entryModel;

- (IBAction) textFieldChanged:(UITextField *)textField
{
    Class modelClass = [self.entryModel class];
    objc_property_t theProperty = class_getProperty(modelClass, [self.modelProperty UTF8String]);
    const char * propertyAttrs = property_getAttributes(theProperty);
    
    NSString *propertyAttributesString = [NSString stringWithUTF8String:propertyAttrs];
    NSString *attributes = [propertyAttributesString substringFromIndex:1];
    NSString *typeName = [attributes componentsSeparatedByString:@","][0];
    NSString *safeTypeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    safeTypeName = [safeTypeName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    Class typeClass = NSClassFromString(safeTypeName);
    id value = [self instanceOfClass:typeClass withValueString:textField.text];
    [self.entryModel setValue:value forKey:self.modelProperty];
}


- (id) instanceOfClass:(Class)class withValueString:(NSString *)value
{
    if (class == [NSDecimalNumber class])
    {
        return [NSDecimalNumber decimalNumberWithString:value];
    }
    else if (class == [NSString class])
    {
        return value;
    }
    else
    {
        return nil;
    }
}


- (void) setEntryModel:(Entry *)entryModel
{
    if (_entryModel != entryModel)
    {
        _entryModel = entryModel;
        UITextField *textField = (UITextField *)self.control;
        id value = [self.entryModel valueForKey:self.modelProperty];
        NSString *stringValue = nil;
        if ([value isKindOfClass:[NSString class]])
        {
            stringValue = value;
        } else
        {
            if ([value isKindOfClass:[NSDecimalNumber class]])
            {
                NSDecimalNumber *number = value;
                
                switch ([number compare:@0])
                {
                    case NSOrderedSame:
                    case NSOrderedAscending:
                    {
                        number = [number decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
                        UITextField *textField = (UITextField *)self.control;
                        textField.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
                        break;
                    }
                    case NSOrderedDescending:
                    {
                        UITextField *textField = (UITextField *)self.control;
                        textField.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
                        break;
                    }
                    default:
                        break;
                }
                
                value = number;                
            }
            stringValue = [value stringValue];
        }
        
        if ([stringValue isEqualToString:@"0"])
        {
            stringValue = @"";
        }
        
        if (stringValue == nil)
        {
            stringValue = @"";
        }
        
        textField.text = stringValue;
    }
}


- (void) displayPlusSign
{
    //self.entryTypeSymbolLabel.text = @"+";
    UITextField *textField = (UITextField *)self.control;
    textField.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme greenColor];
}


- (void) displayMinusSign
{
//    self.entryTypeSymbolLabel.text = @"-";
    UITextField *textField = (UITextField *)self.control;
    textField.textColor = [((BSAppDelegate *)[[UIApplication sharedApplication] delegate]).themeManager.theme redColor];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate textFieldShouldreturn];
    return NO;
}

- (void) reset
{
    UITextField *textField = (UITextField *)self.control;
    textField.text = @"";
    
}


@end
