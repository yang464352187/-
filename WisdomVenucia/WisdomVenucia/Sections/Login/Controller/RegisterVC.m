//
//  RegisterVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/20.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "RegisterVC.h"
#import "FieldView.h"
#import "RegisterModel.h"

static NSInteger _buttontime = 60;

@interface RegisterVC ()<UIAlertViewDelegate,FieldViewDelegate>

@property (strong, nonatomic) FieldView     *cellPhone;
@property (strong, nonatomic) FieldView     *passWord;
@property (strong, nonatomic) FieldView     *apassWord;
@property (strong, nonatomic) UITextField   *verifyField;
@property (strong, nonatomic) UIButton      *getVerifyBtn;
@property (strong, nonatomic) UIButton      *agreeButton;
@property (strong, nonatomic) NSTimer       *timer;
@property (strong, nonatomic) RegisterModel *registerModel;
@property (strong, nonatomic) NSString    *random;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户注册";
    
    [self initUI];
}


- (void)initUI{
    [self initTextFiledAndButton];
    [self setSecLeftNavigation];
    [self setSecRightNavigation];
}

- (void)initTextFiledAndButton{
    CGFloat h = SCREEN_WIDTH == 320? 40 : 50;
    CGRect frame = VIEWFRAME(0, 64 + 30, 0, h);
    
    frame.origin.x = SCREEN_WIDTH == 320? 40 : 50;
    frame.size.width = SCREEN_WIDTH-2*frame.origin.x;
    
    
    //用户名输入框
    self.cellPhone = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"RegisteCellPhone"]
                                          Placeholder:@"请输入手机号"];
    [self.view addSubview:self.cellPhone];
    
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
    [self.getVerifyBtn addTarget:self action:@selector(getVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.getVerifyBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.getVerifyBtn setTitle:@"免费获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:self.getVerifyBtn];
    
//    if (_buttontime < 60) {
//        [self getVerify];
//    }
    
    //密码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.passWord = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"PassWordMotify"]
                                         Placeholder:@"6-16位英文字母或数字"];
    [self.passWord setTextFielWithSecureTextEntry];
    self.passWord.delegate = self;
    [self.view addSubview:self.passWord];
    
    //确认密码
    frame.origin.y = frame.origin.y + 20 + h;
    self.apassWord = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"RegisterFirm"]
                                          Placeholder:@"确认密码"];
    [self.apassWord setTextFielWithSecureTextEntry];
    self.apassWord.delegate = self;
    [self.view addSubview:self.apassWord];
    
    //汽车协议 打挑按钮
    UIImage *delegateImg = [UIImage imageNamed:@"RegisterDelegate"];
    frame.origin.y = frame.origin.y + 15 + h;
    frame.origin.x = frame.origin.x + frame.size.width-120- delegateImg.size.width;
    frame.size.width = delegateImg.size.width;
    frame.size.height = delegateImg.size.height;
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreeButton.frame = frame;
    [self.agreeButton setBackgroundImage:delegateImg forState:UIControlStateNormal];
    [self.agreeButton setBackgroundImage:[UIImage imageNamed:@"RegisterDelegate_Sel"] forState:UIControlStateSelected];

    [self.agreeButton addTarget:self action:@selector(agreeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreeButton];
    
    [self.agreeButton setSelected:YES];
    
    //汽车协议 协议按钮
    frame.origin.x = frame.origin.x + delegateImg.size.width;
    frame.size.width = 120;
    frame.size.height = delegateImg.size.height;
    UIButton *carDelegate = [[UIButton alloc] initWithFrame:frame];
    carDelegate.tag = 1001;
    carDelegate.titleLabel.font = SYSTEMFONT(12);
    [carDelegate setTitle:@"我同意车联智慧协议" forState:UIControlStateNormal];
    [carDelegate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [carDelegate addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:carDelegate];
    
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(5, delegateImg.size.height-0.5, 110, 0.5)];
    cut.backgroundColor = [UIColor whiteColor];
    [carDelegate addSubview:cut];
    
    //注册按钮
    CGFloat s = SCREEN_HIGHT == 480 ? 15 : 50;
    CGFloat b_y = frame.origin.y + 40 + s - h;
    UIImage *registerImg = [UIImage imageNamed:@"RegisterButton"];
    UIButton *RegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RegisterButton.frame = VIEWFRAME(SCREEN_WIDTH/2-registerImg.size.width/2, b_y, registerImg.size.width, registerImg.size.height);
    RegisterButton.tag = 1000;
    CGFloat ttt = SCREEN_HIGHT == 480? 0.8:1.0;
    RegisterButton.transform = CGAffineTransformMakeScale(ttt, ttt);
    [RegisterButton setImage:registerImg selecetImage:[UIImage imageNamed:@"RegisterButton_Sel"] withTitle:nil];
    [RegisterButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    ViewBorderRadius(RegisterButton, registerImg.size.width/2, 2, [UIColor whiteColor]);
    
    [self.view addSubview:RegisterButton];
    
    
    
    //[self.cellPhone setText:@"18759209664"];
}

#pragma mark -- 按钮动作
- (void)ButtonClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //注册按钮
        BOOL isCellPhone = [self validateMobile:[self.cellPhone getText]];
        BOOL isPassWord = (self.passWord.getText.length>=6 && self.passWord.getText.length<=16);
        if (self.cellPhone.getText.length == 0) {
            [MBProgressHUD showHudTipStr:@"请输入用户名"];
        }else if (!isCellPhone) {
            [MBProgressHUD showHudTipStr:@"用户名格式错误"];
            
        }else if ([self.passWord getText].length == 0) {
            [MBProgressHUD showHudTipStr:@"请输入密码"];
        }else if (!isPassWord){
            [MBProgressHUD showHudTipStr:@"密码格式错误"];
        }else if (![self.passWord.getText isEqualToString:self.apassWord.getText]){
            [MBProgressHUD showHudTipStr:@"重新确认密码"];
        }else if (!self.agreeButton.isSelected){
            [MBProgressHUD showHudTipStr:@"请同意车联智慧协议"];
        }else{
            //
//            [self registerWithData];
            [self CheckVerify];
        }

        
        
    }else{
        //协议按钮
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"HTMLVC" object:nil info:nil];
        
    }
}

#pragma mark -- 注册
- (void)registerWithData{
    //注册
    self.registerModel = [[RegisterModel alloc] init];
    self.registerModel.username = self.cellPhone.getText;
    self.registerModel.password = self.passWord.getText;
    
    NSLog(@"%@    %@",self.cellPhone.getText,self.passWord.getText);
    
    _weekSelf(weakSelf);
    [[NetAPIManager sharedManager] request_Register_WithParams:self.registerModel succesBlack:^(id data) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"继续添加车辆?"
                                                        message:nil
                                                       delegate:weakSelf
                                              cancelButtonTitle:@"是"
                                              otherButtonTitles:@"否", nil];
        [alert show];
    
    } failue:^(id data, NSError *error) {
            NSLog(@"fault");
    }];
    
//    [[NetAPIManager sharedManager] request_Register_WithParams:self.registerModel succesBlack:^(id data) {
//        
//    } failue:^(id data, NSError *error) {
//        
//    }];
    
}

#pragma mark -- 验证验证码
- (void)CheckVerify{
//    if (self.verifyField.text.length < 4) {
//        [MBProgressHUD showHudTipStr:@"验证码格式错误"];
//        return;
//    }
//    
//    //验证验证码是否正确
//    NSDictionary *mobCheck = @{
//                               @"cellPhone":self.cellPhone.getText,
//                               @"phoneVerify":@([self.verifyField.text integerValue])
//                               };
//    _weekSelf(weakSelf);
//    [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_CheckMob Params:mobCheck succesBlack:^(id data) {
//        [weakSelf registerWithData];
//    } failue:^(id data, NSError *error) {
//        [MBProgressHUD showHudTipStr:@"验证码错误"];
//    }];
    
//    _weekSelf(weakSelf);
    NSLog(@"%@    %@",self.random,self.verifyField.text);
    if ([self.random isEqualToString: self.verifyField.text]) {
        [self registerWithData];
    }
}

#pragma mark -- alert delegate;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSDictionary *dic = @{@"type" : @"1"};
        [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"AddCarsVC" object:nil info:dic];
    }else{
        [[RootViewController sharedRootVC] ChangeRootVC];
    }
}

//手机号码验证
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])||(14[0-9])||(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


#pragma mark -- 同意协议打挑按钮
- (void)agreeClick:(UIButton *)sender{
    [self.agreeButton setSelected:!self.agreeButton.isSelected];
}


#pragma mark -- 获取验证码
- (void)getVerify{
    if ([self validateMobile:self.cellPhone.getText]) {
        //检查用户名是否被注册过
        self.random = @"";

        NSDictionary *userCheck = @{@"username":self.cellPhone.getText};
        _weekSelf(weakSelf);
        [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_Register_Check Params:userCheck succesBlack:^(id data) {
            //用户名未使用
            //发送成功
//            NSDictionary *userDic = @{@"cellPhone":self.cellPhone.getText,
//                                      @"type":@"register"};
//            [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_SendMob Params:userDic succesBlack:^(id data) {
//                //发送成功
         
//            } failue:^(id data, NSError *error) {
//                if (data) {
//                    [MBProgressHUD showHudTipStr:data[@"msg"]];
//                }
//            }];
            
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
            [weakSelf.getVerifyBtn setTitle:@"已发送(60S)" forState:UIControlStateNormal];
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerActtion) userInfo:nil repeats:YES];
            
            
        } failue:^(id data, NSError *error) {
            if (data) {
                [MBProgressHUD showHudTipStr:data[@"msg"]];
            }
        }];
        
       
//        NSURLConnection sendAsynchronousRequest:request queue:<#(nonnull NSOperationQueue *)#> completionHandler:<#^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError)handler#>
        
        
        
        
        

    }else{
        [MBProgressHUD showHudTipStr:@"用户名格式错误"];
    }

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
        _buttontime = 60;
    }
}

                             
                             
                             
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setSecRightNavigation{
//    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RegisterRightBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(RightButtonAction)];
//    self.navigationItem.rightBarButtonItem = barBtn;
}

#pragma mark -- 右按钮动作
- (void)RightButtonAction{
    
}


#pragma mark -- FieldView delegate
- (BOOL)changeString{
    return YES;
}

@end
