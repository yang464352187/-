//
//  ForgetPassWordVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ForgetPassWordVC.h"
#import "FieldView.h"

@interface ForgetPassWordVC ()

@property (strong, nonatomic) FieldView   *cellPhone;
@property (strong, nonatomic) UITextField *verifyField;
@property (strong, nonatomic) UIButton    *getVerifyBtn;
@property (strong, nonatomic) NSTimer     *timer;
@property (strong, nonatomic) NSString    *random;


@end

@implementation ForgetPassWordVC{
    NSInteger _buttontime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"忘记密码";
}

- (void)initData{
    
}

- (void)initUI{
    [self setSecLeftNavigation];
    //logo
    CGFloat t = SCREEN_WIDTH == 320? 0.7 : 0.9;//缩放比例
    CGFloat s = SCREEN_WIDTH == 320? 0 : 10; //间隔大小
    UIImage *logo = [UIImage imageNamed:@"PassWordLogo"];
    CGRect frame = VIEWFRAME(SCREEN_WIDTH/2-logo.size.width/2, 64 + s, logo.size.width, logo.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.transform = CGAffineTransformMakeScale(t, t);
    imageView.image = logo;
    [self.view addSubview:imageView];
    
    //用户名输入框
    CGFloat h = SCREEN_WIDTH == 320? 40 : 50;
    
    frame.origin.x = SCREEN_WIDTH == 320? 40 : 50;
    frame.size.width = SCREEN_WIDTH-2*frame.origin.x;
    frame.origin.y = frame.origin.y  + s + logo.size.height;
    frame.size.height  = h;
    self.cellPhone = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"RegisteCellPhone"]
                                         Placeholder:@"请输入手机号"];
    NSString *text = self.notificationDict? self.notificationDict[@"username"]:@"";
    [self.cellPhone setText:text];
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
    self.verifyField.keyboardType = UIKeyboardTypeNumberPad;
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
    
    
    //登录按钮
    s = SCREEN_HIGHT == 480 ? 5 : 40;
    CGFloat b_y = frame.origin.y + 40 + s;
    UIImage *login = [UIImage imageNamed:@"LoginButton"];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = VIEWFRAME(SCREEN_WIDTH/2-login.size.width/2, b_y, login.size.width, login.size.height);
    CGFloat ttt = SCREEN_HIGHT == 480? 0.8:1.0;
    nextButton.transform = CGAffineTransformMakeScale(ttt, ttt);
    nextButton.titleLabel.font = SYSTEMFONT(22);
    [nextButton setImage:login
             selecetImage:[UIImage imageNamed:@"LoginButton_Sel"]
                withTitle:@"下一步"];
    [nextButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(nextButton, login.size.width/2, 2, [UIColor whiteColor]);
    
    [self.view addSubview:nextButton];
    
    //
    //  [self.cellPhone setText:@"18759209664"];
    

}

- (void)ButtonClick:(UIButton *)sender{
    if (self.cellPhone.getText.length == 0) {
        [MBProgressHUD showHudTipStr:@"请输入用户名"];
    }else{
        if ([self validateMobile:self.cellPhone.getText]) {
            [self CheckVerify];
            
        }else{
            [MBProgressHUD showHudTipStr:@"用户名格式错误"];
        }
    }
}


#pragma mark -- 获取验证码
- (void)getVerify{
    if ([self validateMobile:self.cellPhone.getText]) {
        _weekSelf(weakSelf);
        NSDictionary *userDic = @{@"cellPhone":self.cellPhone.getText,
                                  @"type":@"forgotPass"};
//        [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_SendMob Params:userDic succesBlack:^(id data) {
            //发送成功
        
        self.random = @"";

            [MBProgressHUD showHudTipStr:@"短信发送成功"];
            weakSelf.getVerifyBtn.userInteractionEnabled = NO;
            _buttontime = 59;
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            [weakSelf.getVerifyBtn setTitle:@"已发送(60S)" forState:UIControlStateNormal];
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActtion) userInfo:nil repeats:YES];
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

        
//        } failue:^(id data, NSError *error) {
//            if (data) {
//                [MBProgressHUD showHudTipStr:data[@"msg"]];
//            }
//        }];

    
    }else if (self.cellPhone.getText.length == 0){
        [MBProgressHUD showHudTipStr:@"请输入用户名"];
    }else{
        [MBProgressHUD showHudTipStr:@"用户名格式错误"];
    }
}

#pragma mark -- 验证验证码
- (void)CheckVerify{
    if (self.verifyField.text.length < 4) {
        [MBProgressHUD showHudTipStr:@"验证码格式错误"];
        return;
    }
    
    if ([self.random isEqualToString: self.verifyField.text]) {
//        [self registerWithData];
        NSDictionary *notify = @{@"username":self.cellPhone.getText};
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ReplacePassWordVC" object:nil info:notify];
    }
    
    //验证验证码是否正确
//    NSDictionary *mobCheck = @{
//                               @"cellPhone":self.cellPhone.getText,
//                               @"phoneVerify":@([self.verifyField.text integerValue])
//                               };
//    _weekSelf(weakSelf);
//    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_CheckMob Params:mobCheck succesBlack:^(id data) {
//        NSDictionary *notify = @{@"username":self.cellPhone.getText};
//        [weakSelf postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ReplacePassWordVC" object:nil info:notify];
//    } failue:^(id data, NSError *error) {
//        [MBProgressHUD showHudTipStr:@"验证码错误"];
//    }];

}


//手机号码验证
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])||(14[0-9])||(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
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
