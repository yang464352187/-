//
//  FieldView.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldView;

@protocol FieldViewDelegate <NSObject>

@optional

- (void)MoreButtonClick:(NSString *)str;

- (void)ScanButtonClick:(FieldView *)fieldView;

- (BOOL)changeString;
@end


@interface FieldView : UIView



@property (weak,   nonatomic) UIViewController *viewController;

@property (weak , nonatomic) id<FieldViewDelegate> delegate;

/**
 * @pram frame 设置frame
 * @pram image 设置图标    图片在左边或右边
 * @pram placeholder 设置textfield的提示文字
 **/


- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image Placeholder:(NSString *)placeholder;
//图片在右边
- (instancetype)initWithFrame:(CGRect)frame RightImage:(UIImage *)image Placeholder:(NSString *)placeholder;
//圆角矩形
- (instancetype)initRectWithFrame:(CGRect)frame RightImage:(UIImage *)image Placeholder:(NSString *)placeholder MoreButton:(BOOL)ismore;


//设置更多按钮
- (void)setMoreButton;
//设置密码模式
- (void)setTextFielWithSecureTextEntry;
//得到输入框的字段
- (NSString *)getText;
//设置输入框的值
- (void)setText:(NSString *)test;
//刷新下拉框
- (void)reloadTableView;
//设置键盘
- (void)setKeyboard:(UIKeyboardType)type;

//下拉数组
@property (strong, nonatomic) NSArray *listData;

@end
