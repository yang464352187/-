//
//  MotifyQuickVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MotifyQuickVC.h"
#import "FieldView.h"

@interface MotifyQuickVC ()

@property (strong, nonatomic) FieldView   *cellPhone;
@property (strong, nonatomic) FieldView   *passWord;
@property (strong, nonatomic) FieldView   *apassWord;
@property (strong, nonatomic) FieldView   *controlpw;
@property (strong, nonatomic) UITextField *verifyField;
@property (strong, nonatomic) UIButton    *getVerifyBtn;
@property (strong, nonatomic) NSTimer     *timer;

@end

@implementation MotifyQuickVC{
    NSInteger _buttontime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改快捷控制密码";
    [self initUI];
}




- (void)initUI{
    [self initTextFiledAndButton];
    [self setSecLeftNavigation];
}

- (void)initTextFiledAndButton{
    CGFloat h = SCREEN_WIDTH == 320? 40 : 50;
    CGRect frame = VIEWFRAME(0, 64 + 30, 0, h);
    
    frame.origin.x = SCREEN_WIDTH == 320? 40 : 50;
    frame.size.width = SCREEN_WIDTH-2*frame.origin.x;
    
    self.controlpw = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"PassWordImg"]
                                          Placeholder:@"请输入当前控制密码"];
    [self.controlpw setTextFielWithSecureTextEntry];
    [self.view addSubview:self.controlpw];
    
    //忘记控制密码按钮
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-frame.origin.x-120, frame.origin.y+h, 120, 20)];
    [forgetBtn setTitle:@"忘记当前控制密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = SYSTEMFONT(10);
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                   30.0,
                                                   0.0,
                                                   0.0)];
    [self.view addSubview:forgetBtn];
    //密码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.passWord = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"PassWordMotify"]
                                         Placeholder:@"请输入新密码"];
    [self.passWord setTextFielWithSecureTextEntry];
    [self.view addSubview:self.passWord];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-frame.origin.x-160, frame.origin.y+h, 160, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"密码为6-16位英文字母或数字";
    label.textAlignment = NSTextAlignmentRight;
    label.font = SYSTEMFONT(10);
    [self.view addSubview:label];
    
    //确认密码
    frame.origin.y = frame.origin.y + 20 + h;
    self.apassWord = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"RegisterFirm"]
                                          Placeholder:@"确认新密码"];
    [self.apassWord setTextFielWithSecureTextEntry];
    [self.view addSubview:self.apassWord];
    
    //用户名输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.cellPhone = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"RegisteCellPhone"]
                                          Placeholder:@"请输入手机号"];
    [self.view addSubview:self.cellPhone];
    
    //验证码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    UIView *verifyBack = [[UIView alloc] initWithFrame:VIEWFRAME(frame.origin.x, frame.origin.y, 100, h)];
    verifyBack.backgroundColor = [UIColor whiteColor];
    ViewRadius(verifyBack, h/2);
    
    self.verifyField = [[UITextField alloc] initWithFrame:VIEWFRAME(20, 10, 60, h-20)];
    
    self.verifyField.placeholder = @"  验证码";
    self.verifyField.font = SYSTEMFONT(14);
    [self.verifyField setValue:HEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [verifyBack addSubview:self.verifyField];
    [self.view addSubview:verifyBack];
    
    //获取验证码按钮
    
    self.getVerifyBtn = [[UIButton alloc] initWithFrame:VIEWFRAME(frame.origin.x + 115, frame.origin.y, frame.size.width-115, h)];
    ViewRadius(self.getVerifyBtn, h/2);
    self.getVerifyBtn.titleLabel.font = SYSTEMFONT(14);
    self.getVerifyBtn.backgroundColor = [UIColor whiteColor];
    [self.getVerifyBtn addTarget:self action:@selector(getVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerifyBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.getVerifyBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:self.getVerifyBtn];
    
    
    
    
    //修改密码按钮
    CGFloat s = SCREEN_HIGHT == 480 ? 20 : 50;
    CGFloat b_y = frame.origin.y + 40 + s;
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    UIButton *MotifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    MotifyButton.frame = VIEWFRAME(SCREEN_WIDTH/2-motifyImg.size.width/2, b_y, motifyImg.size.width, motifyImg.size.height);
    MotifyButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    MotifyButton.titleLabel.font = SYSTEMFONT(16);
    [MotifyButton setTitle:@"完成" forState:UIControlStateNormal];
    [MotifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MotifyButton setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [MotifyButton setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [MotifyButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //ViewBorderRadius(MotifyButton, registerImg.size.width/2, 2, [UIColor whiteColor]);
    
    [self.view addSubview:MotifyButton];
    
    
}


- (void)ButtonClick:(UIButton *)sender{
    
}

- (void)getVerify{
    
    self.getVerifyBtn.userInteractionEnabled = NO;
    _buttontime = 59;
    [self.getVerifyBtn setTitle:@"已发送(60S)" forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActtion) userInfo:nil repeats:YES];
    
}

- (void)timerActtion{
    if (_buttontime != 0) {
        [self.getVerifyBtn setTitle:[NSString stringWithFormat:@"已发送(%liS)",(long)_buttontime] forState:UIControlStateNormal];
        _buttontime --;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        [self.getVerifyBtn setTitle:@"免费获取手机验证码" forState:UIControlStateNormal];
        self.getVerifyBtn.userInteractionEnabled = YES;
    }
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
