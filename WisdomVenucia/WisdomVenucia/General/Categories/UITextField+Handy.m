//
//  UITextField+Handy.m
//  PaperSource
//
//  Created by Yhoon on 15/10/19.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UITextField+Handy.h"

@implementation UITextField (Handy)

// 创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                            andName:(NSString*)tfText
                     andPlaceholder:(NSString*)placeholder
                   andTextAlignment:(NSTextAlignment)textAlignment
                        andFontSize:(UIFont*)font
                       andTextColor:(UIColor*)textColor
                        andDelegate:(id)delegate {
    
    UITextField* textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.borderStyle              = UITextBorderStyleRoundedRect;
    textField.returnKeyType            = UIReturnKeyDefault;
    textField.text                     = tfText;
    textField.placeholder              = placeholder;
    textField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    textField.textAlignment            = textAlignment;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate                 = delegate;
    textField.keyboardType             = UIKeyboardTypeDefault;
    textField.keyboardAppearance       = UIKeyboardAppearanceDefault;
    textField.autocapitalizationType   = UITextAutocapitalizationTypeAllCharacters;
    textField.autocorrectionType       = UITextAutocorrectionTypeNo;
    textField.font                     = font;
    textField.textColor                = textColor;
    
    UIView *paddingView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    textField.leftView                 = paddingView;
    textField.leftViewMode             = UITextFieldViewModeAlways;
    
    return textField;
}
@end
