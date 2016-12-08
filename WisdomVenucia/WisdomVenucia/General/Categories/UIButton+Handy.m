//
//  UIButton+Handy.m
//  PaperSource
//
//  Created by Yhoon on 15/10/23.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "UIButton+Handy.h"

@implementation UIButton (Handy)

+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                                 andFont:(UIFont *)font
                           andTitleColor:(UIColor *)titleColor
                      andBackgroundColor:(UIColor *)backgroundColor{
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.frame = frame;
    button.backgroundColor = backgroundColor;
    button.titleLabel.font = font;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}

+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                           andTitleColor:(UIColor *)titleColor {
    
    UIButton *button = [UIButton createButtonWithButtonType:buttonType andFrame:frame andTitle:title andTitleColor:titleColor andBackgroundColor:[UIColor whiteColor]];
    
    return button;
}

+ (UIButton *)createButtonWithButtonType:(UIButtonType)buttonType
                                andFrame:(CGRect)frame
                                andTitle:(NSString *)title
                           andTitleColor:(UIColor *)titleColor
                      andBackgroundColor:(UIColor *)backgroundColor {
    UIButton *button = [UIButton createButtonWithButtonType:buttonType andFrame:frame andTitle:title andFont:nil andTitleColor:titleColor andBackgroundColor:backgroundColor];
    
    return button;
}

- (void)setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height-10,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    ViewRadius(self.imageView, image.size.width/2);
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor] ];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0] ];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height ,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
    
    //float sw = 70 / image.size.width;
    //float sh = 70 / image.size.height;
    //self.imageView.transform = CGAffineTransformMakeScale(sw,sh);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void) setImage:(UIImage *)image selecetImage:(UIImage *)image_sel withTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image_sel forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
