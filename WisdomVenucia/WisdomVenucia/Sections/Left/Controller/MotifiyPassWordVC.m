//
//  MotifiyPassWordVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MotifiyPassWordVC.h"
#import "FieldView.h"
#import "HomeVC.h"

@interface MotifiyPassWordVC ()<FieldViewDelegate>

@property (strong, nonatomic) FieldView   *cellPhone;
@property (strong, nonatomic) FieldView   *passWord;
@property (strong, nonatomic) FieldView   *apassWord;
@property (strong, nonatomic) FieldView   *oldPassWord;
@property (strong, nonatomic) UITextField *verifyField;
@property (strong, nonatomic) UIButton    *getVerifyBtn;
@property (strong, nonatomic) NSTimer     *timer;
@property (strong, nonatomic) NSDictionary *userInfo;
@property (strong, nonatomic) NSString    *random;


@end

@implementation MotifiyPassWordVC{
    NSInteger _buttontime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
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
    
    self.oldPassWord = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"PassWordImg"]
                                         Placeholder:@"请输入旧密码"];
    [self.oldPassWord setTextFielWithSecureTextEntry];
    self.oldPassWord.delegate = self;
    [self.view addSubview:self.oldPassWord];
    
    //忘记控制密码按钮
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-frame.origin.x-120, frame.origin.y+h, 120, 20)];
    [forgetBtn setTitle:@"忘记当前密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = SYSTEMFONT(10);
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                  30.0,
                                                  0.0,
                                                   0.0)];
    [forgetBtn addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    //密码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.passWord = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"PassWordMotify"]
                                         Placeholder:@"请输入新密码"];
    self.passWord.delegate = self;
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
    self.apassWord.delegate = self;
    [self.apassWord setTextFielWithSecureTextEntry];
    [self.view addSubview:self.apassWord];
    
//    //用户名输入框
//   frame.origin.y = frame.origin.y + 20 + h;
//    self.cellPhone = [[FieldView alloc] initWithFrame:frame
//                                                Image:[UIImage imageNamed:@"RegisteCellPhone"]
//                                          Placeholder:@"请输入手机号"];
//
//    [self.view addSubview:self.cellPhone];
    
    //验证码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    UIView *verifyBack = [[UIView alloc] initWithFrame:VIEWFRAME(frame.origin.x, frame.origin.y, 100, h)];
    verifyBack.backgroundColor = [UIColor whiteColor];
    ViewRadius(verifyBack, h/2);
    
    self.verifyField              = [[UITextField alloc] initWithFrame:VIEWFRAME(20, 10, 60, h-20)];

    self.verifyField.placeholder  = @"  验证码";
    self.verifyField.font         = SYSTEMFONT(14);
    self.verifyField.keyboardType = UIKeyboardTypeNumberPad;
    [self.verifyField setValue:HEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [verifyBack addSubview:self.verifyField];
    [self.view addSubview:verifyBack];
    
    //获取验证码按钮
    
    self.getVerifyBtn = [[UIButton alloc] initWithFrame:VIEWFRAME(frame.origin.x + 115, frame.origin.y, frame.size.width-115, h)];
    ViewRadius(self.getVerifyBtn, h/2);
    self.getVerifyBtn.titleLabel.font = SYSTEMFONT(14);
    self.getVerifyBtn.backgroundColor = [UIColor whiteColor];
    [self.getVerifyBtn addTarget:self action:@selector(getWithVerify) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark -- 完成按钮
- (void)ButtonClick:(UIButton *)sender{
    BOOL isOldPW = [self checkPassWordLenth:self.oldPassWord.getText];
    BOOL isPW = [self checkPassWordLenth:self.passWord.getText];
    BOOL isaPW = [self checkPassWordLenth:self.apassWord.getText];
    
    if (self.oldPassWord.getText.length == 0 || self.passWord.getText.length == 0||self.apassWord.getText.length == 0 ) {
        [MBProgressHUD showHudTipStr:@"请输入密码"];
    }else{
        if (isaPW && isOldPW && isPW) {
            if (![self.passWord.getText isEqualToString:self.apassWord.getText]) {
                [MBProgressHUD showHudTipStr:@"两次密码不一致"];
            }else{
                if ([self.oldPassWord.getText isEqualToString:self.passWord.getText]) {
                    [MBProgressHUD showHudTipStr:@"旧密码和新密码相同"];
                }else{
                    [self CheckVerify];
                }
            }
        }else{
            [MBProgressHUD showHudTipStr:@"密码格式错误"];
        }
    }
    
}

#pragma mark -- 修改密码操作
- (void)modifyPassWord{
    //修改密码 MARK: 修改密码操作在这里
    NSDictionary *dic = @{
                          @"token":self.currentLoginUser.token,
                          @"password": self.passWord.getText,
                          @"oldPassword":self.oldPassWord.getText
                          };
    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_modifyUserPwd Params:dic succesBlack:^(id data) {
        [MBProgressHUD showHudTipStr:@"修改成功，请重新登录"];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HomeVC class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LoginModel doLoginOut];
            [[RootViewController sharedRootVC] ChangeRootVC];
        });
    } failue:^(id data, NSError *error) {
        
    }];
}

#pragma mark --  判断密码位数是否正确

- (BOOL)checkPassWordLenth:(NSString *)text{
    if ((text.length<=16) && (text.length>=6)) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -- 忘记按钮
- (void)forgetButtonClick:(UIButton *)sender{
    NSDictionary *notify = @{@"username":self.userInfo[@"username"]};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ForgetPassWordVC" object:nil info:notify];
}


#pragma mark -- 验证验证码
- (void)CheckVerify{
    if (self.verifyField.text.length < 4) {
        [MBProgressHUD showHudTipStr:@"验证码格式错误"];
        return;
    }
    self.userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    if (!self.userInfo[@"username"]) {
        [MBProgressHUD showHudTipStr:@"个人信息获取中，请稍候再试"];
        return;
    }
    NSDictionary *u_Info = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    //验证验证码是否正确
//    NSDictionary *mobCheck = @{
//                               @"cellPhone":u_Info[@"username"],
//                               @"phoneVerify":@([self.verifyField.text integerValue])
//                               };
//    _weekSelf(weakSelf);
//    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_CheckMob Params:mobCheck succesBlack:^(id data) {
//        [weakSelf modifyPassWord];
//    } failue:^(id data, NSError *error) {
//        [MBProgressHUD showHudTipStr:@"验证码错误"];
//    }];
    
    if ([self.random isEqualToString: self.verifyField.text]) {
        //        [self registerWithData];
//        NSDictionary *notify = @{@"username":self.cellPhone.getText};
//        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ReplacePassWordVC" object:nil info:notify];
        [self modifyPassWord];
    }
}

#pragma mark -- alert delegate;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[RootViewController sharedRootVC] ChangeRootVC];
    if (buttonIndex == 0) {
        
        //[self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"AddCarsVC" object:nil info:nil];
    }else{
        
    }
}

//手机号码验证
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark -- 获取验证码
- (void)getWithVerify{
    //发送验证码
    
    
    
//    NSDictionary *dict = @{@"cellPhone":self.userInfo[@"username"],
//                           @"type":@"forgotpass"};
//    _weekSelf(weakSelf);
//    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_SendMob Params:dict succesBlack:^(id data) {
//        //发送成功
//        [MBProgressHUD showHudTipStr:@"短信发送成功"];
//        weakSelf.getVerifyBtn.userInteractionEnabled = NO;
//        _buttontime = 59;
//        [weakSelf.getVerifyBtn setTitle:@"已发送(60S)" forState:UIControlStateNormal];
//        [weakSelf.timer invalidate];
//        weakSelf.timer = nil;
//        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActtion) userInfo:nil repeats:YES];
//    } failue:^(id data, NSError *error) {
//        
//    }];
    
    self.random = @"";
    _weekSelf(weakSelf);
    NSDictionary *userDic = @{@"cellPhone":self.userInfo[@"username"],
                              @"type":@"forgotPass"};
//    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_SendMob Params:userDic succesBlack:^(id data) {
        //发送成功
    for(int i=0; i<4; i++)
    {
        self.random = [ self.random  stringByAppendingFormat:@"%d",(arc4random() % 9)];
    }
    
    NSString *str = [NSString stringWithFormat:@"account=001109&pswd=Sd123456&mobile=%@&msg=您好，您的验证码：%@&needstatus=true",self.cellPhone.getText,self.random ];
    NSLog(@"%@",str);
    NSData *data1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://send.18sms.com/msg/HttpBatchSendSM"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    [request setHTTPBody:data1];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        [MBProgressHUD showHudTipStr:@"短信发送成功"];
        weakSelf.getVerifyBtn.userInteractionEnabled = NO;
        _buttontime = 59;
        [weakSelf.timer invalidate];
        weakSelf.timer = nil;
        [weakSelf.getVerifyBtn setTitle:@"已发送(60S)" forState:UIControlStateNormal];
        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActtion) userInfo:nil repeats:YES];
//    } failue:^(id data, NSError *error) {
//
//    }];
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

#pragma mark -- FieldView delegate
- (BOOL)changeString{
    return YES;
}


@end
