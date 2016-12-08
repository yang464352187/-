//
//  LoginVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "LoginVC.h"
#import "FieldView.h"
#import "AppDelegate.h"
#import "RootViewController.h"

@interface LoginVC ()<FieldViewDelegate>

@property (strong, nonatomic) FieldView *userName;
@property (strong, nonatomic) FieldView *passWord;
@property (strong, nonatomic) LoginModel *login;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.title = @"用户登录";
}

- (void)initUI{
    //logo
    CGFloat t = SCREEN_WIDTH == 320? 0.6 : 0.8;//缩放比例
    CGFloat s = SCREEN_HIGHT / 40; //间隔大小
    UIImage *logo = [UIImage imageNamed:@"LoginLogo"];
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
    self.userName = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"LoginUser"]
                                         Placeholder:@"请输入用户名"];
    [self.userName setMoreButton];
    self.userName.delegate = self;
    self.userName.listData =  DEFAULTS_GET_OBJ(mLOGINUSERLIST);
    [self.userName reloadTableView];
    [self.view addSubview:self.userName];
    
    //密码输入框
    frame.origin.y = frame.origin.y + 20 + h;
    self.passWord = [[FieldView alloc] initWithFrame:frame
                                               Image:[UIImage imageNamed:@"LoginPassWord"]
                                         Placeholder:@"请输入密码"];
    [self.passWord setTextFielWithSecureTextEntry];
    [self.view addSubview:self.passWord];
    
    //登录按钮
    s = SCREEN_HIGHT == 480 ? 5 : 40;
    CGFloat b_y = frame.origin.y + 40 + s;
    UIImage *login = [UIImage imageNamed:@"LoginButton"];
    UIButton *LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    LoginButton.frame = VIEWFRAME(SCREEN_WIDTH/2-login.size.width/2, b_y, login.size.width, login.size.height);
    LoginButton.tag = 1000;
    CGFloat ttt = SCREEN_HIGHT == 480? 0.8:1.0;
    LoginButton.transform = CGAffineTransformMakeScale(ttt, ttt);
    LoginButton.titleLabel.font = SYSTEMFONT(21);
    [LoginButton setImage:login
             selecetImage:[UIImage imageNamed:@"LoginButton_Sel"]
                withTitle:@"登录"];
    [LoginButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(LoginButton, login.size.width/2, 2, [UIColor whiteColor]);
    
    [self.view addSubview:LoginButton];
    
    
    //注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = VIEWFRAME((SCREEN_WIDTH-160)/4, SCREEN_HIGHT-70, 80, 30);
    registerButton.titleLabel.font = SYSTEMFONT(14);
    registerButton.tag = 1001;
    ViewRadius(registerButton, 6);
    [registerButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    
    //分割线
    UIView *cut = [[UIView alloc]initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-0.5, SCREEN_HIGHT-62.5, 1, 20)];
    cut.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cut];
    
    //忘记密码按钮
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = VIEWFRAME(SCREEN_WIDTH/2 + (SCREEN_WIDTH-160)/4, SCREEN_HIGHT-70, 80, 30);
    forgetButton.tag = 1002;
    ViewRadius(forgetButton, 6);
    forgetButton.titleLabel.font = SYSTEMFONT(14);
    [forgetButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [forgetButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [forgetButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateHighlighted];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:forgetButton];
    
    
    
    //测试数据
//    [self.userName setText:@"18759209664"];
//    [self.passWord setText:@"123456"];
}

- (void)ButtonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:{
            //登录

            BOOL isCellPhone = [self validateMobile:[self.userName getText]];
            BOOL isPassWord = (self.passWord.getText.length>=6 && self.passWord.getText.length<=16);
            if (self.userName.getText.length == 0) {
                [MBProgressHUD showHudTipStr:@"请输入用户名"];
            }else if (!isCellPhone) {
                [MBProgressHUD showHudTipStr:@"用户名格式错误"];
            
            }else if ([self.passWord getText].length == 0) {
                [MBProgressHUD showHudTipStr:@"请输入密码"];
            }else if (!isPassWord){
                [MBProgressHUD showHudTipStr:@"密码格式错误"];
            }else{
                //登录
                [self loginWithData];
            }
            break;
        }
        case 1001:{
            //注册
            
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"RegisterVC" object:nil info:nil];
            break;
        }
        case 1002:{
            //忘记密码
            [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"ForgetPassWordVC" object:nil info:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark -- 登录
- (void)loginWithData{
    
    self.login = [[LoginModel alloc] init];
    self.login.username = self.userName.getText;
    self.login.password = self.passWord.getText;
    [SVProgressHUD show];
    [[NetAPIManager sharedManager] request_Login_WithParams:self.login succesBlack:^(id data) {
        // 将RESideMenu作为根视图
        [SVProgressHUD dismiss];
        [[RootViewController sharedRootVC] ChangeRootVC];
        [MBProgressHUD showHudTipStr:@"登录成功"];
    } failue:^(id data, NSError *error) {
        NSLog(@"fault");
        [SVProgressHUD dismiss];
    }];

    
}

#pragma mark -- fieldView delegate
- (void)MoreButtonClick:(NSString *)str{
    [self.userName setText:str];
}


//手机号码验证
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])||(14[0-9])||(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
