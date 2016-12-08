//
//  UITextField+Handy.h
//  PaperSource
//
//  Created by Yhoon on 15/10/19.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Handy)

// 创建TextField
+ (UITextField*)createTextFieldWithFrame:(CGRect)rect
                            andName:(NSString*)tfText
                     andPlaceholder:(NSString*)placeholder
                   andTextAlignment:(NSTextAlignment)textAlignment
                        andFontSize:(UIFont*)font
                       andTextColor:(UIColor*)textColor
                        andDelegate:(id)delegate;

@end
