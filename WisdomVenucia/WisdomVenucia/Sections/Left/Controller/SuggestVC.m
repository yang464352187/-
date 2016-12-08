//
//  SuggestVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/30.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "SuggestVC.h"

@interface SuggestVC ()<UITextViewDelegate>

@end

@implementation SuggestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见和建议";
    [self initData];
    [self initUI];
}

#pragma mark -- Data
- (void)initData{
    //self.title = self.notificationDict[@"title"]? self.notificationDict[@"title"]:@"意见和建议";
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, SCREEN_HIGHT-60)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 508);
    [self.view addSubview:scrollView];
    
    UITextField *titleField = [[UITextField alloc] initWithFrame:VIEWFRAME(25,64+25, SCREEN_WIDTH-50, 45)];
    titleField.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 12, 0)];
    titleField.leftViewMode = UITextFieldViewModeAlways;
    titleField.text = self.notificationDict[@"title"]? self.notificationDict[@"title"]:@"意见和建议";
    titleField.textColor = [UIColor whiteColor];
    titleField.font = SYSTEMFONT(15);
    titleField.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    ViewRadius(titleField, 8);
    [scrollView addSubview:titleField];
    
    UIView *view = [[UIView alloc] initWithFrame:VIEWFRAME(25, 64+85, SCREEN_WIDTH-50, 220)];
    ViewRadius(view, 8);
    view.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    
    
    UITextView *textView = [[UITextView alloc]initWithFrame:VIEWFRAME(10, 10, SCREEN_WIDTH-70, 200)];
    textView.textColor = [UIColor whiteColor];
    //textView.text = @"请输入具体问题描述";
    textView.font = SYSTEMFONT(15);
    textView.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    textView.delegate = self;
    [view addSubview:textView];
    [scrollView addSubview:view];
    
    UITextField *contact = [[UITextField alloc] initWithFrame:VIEWFRAME(25,64+320, SCREEN_WIDTH-50, 45)];
    contact.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 12, 0)];
    contact.leftViewMode = UITextFieldViewModeAlways;
    contact.placeholder = @"QQ或手机号码";
    [contact setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    contact.textColor = [UIColor whiteColor];
    contact.font = SYSTEMFONT(15);
    contact.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    ViewRadius(contact, 8);
    [scrollView addSubview:contact];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(25,64+380, SCREEN_WIDTH-50, 45)];
    button.titleLabel.font = SYSTEMFONT(17);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateHighlighted];
    ViewRadius(button, 8);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
    
    
    CGFloat s = SCREEN_HIGHT == 480? 40 : 60;
    UILabel *label3 = [[UILabel alloc] initWithFrame:VIEWFRAME(0,  SCREEN_HIGHT-s, SCREEN_WIDTH, 20)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor yellowColor];
    label3.text = @"Copyright @ 2015 , tungthin AllRights Reserved.";
    label3.font = SYSTEMFONT(12);
    [self.view addSubview:label3];
    
}



#pragma  mark -- 按钮动作
- (void)buttonClick:(UIButton *)sender{
    
    [self popGoBack];
    [MBProgressHUD showHudTipStr:@"反馈成功"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
