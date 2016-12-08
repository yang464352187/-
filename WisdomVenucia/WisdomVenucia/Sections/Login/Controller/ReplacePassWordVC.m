//
//  ReplacePassWordVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ReplacePassWordVC.h"
#import "FieldView.h"

@interface ReplacePassWordVC ()

@property (strong, nonatomic) FieldView    *passWord;
@property (strong, nonatomic) FieldView    *apassWord;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ReplacePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.title = @"重置密码";
}

- (void)initUI{
    [self setSecLeftNavigation];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:APP_BOUNDS];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 620);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    //logo
    CGFloat t = SCREEN_WIDTH == 320? 0.7 : 0.9;//缩放比例
    CGFloat s = SCREEN_WIDTH == 320? 0 : 10; //间隔大小
    UIImage *logo = [UIImage imageNamed:@"PassWordLogo"];
    CGRect frame = VIEWFRAME(SCREEN_WIDTH/2-logo.size.width/2, 64 + s, logo.size.width, logo.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.transform = CGAffineTransformMakeScale(t, t);
    imageView.image = logo;
    [self.scrollView addSubview:imageView];
    
    //用户名输入框
    CGFloat h = SCREEN_WIDTH == 320? 40 : 50;
    
    frame.origin.x = SCREEN_WIDTH == 320? 40 : 50;
    frame.size.width = SCREEN_WIDTH-2*frame.origin.x;
    frame.origin.y = frame.origin.y  + s + logo.size.height;
    frame.size.height  = h;
    self.passWord = [[FieldView alloc] initWithFrame:frame
                                                Image:[UIImage imageNamed:@"PassWordMotify"]
                                          Placeholder:@"6-16位英文字母或数字"];
    [self.passWord setTextFielWithSecureTextEntry];
    [self.scrollView addSubview:self.passWord];
    

    frame.origin.y = frame.origin.y + 20 + h;
    self.apassWord = [[FieldView alloc] initWithFrame:frame
                                             Image:[UIImage imageNamed:@"RegisterFirm"]
                                       Placeholder:@"确认密码"];
    [self.apassWord setTextFielWithSecureTextEntry];
    [self.scrollView addSubview:self.apassWord];
    
    
    
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
               withTitle:@"完成"];
    [nextButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    ViewBorderRadius(nextButton, login.size.width/2, 2, [UIColor whiteColor]);
    
    [self.scrollView addSubview:nextButton];
    
    
    //警告框

    UIImage *image = [UIImage imageNamed:@"PassWordWarn"];
    UIImageView *warn = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/4-image.size.width-5, b_y+login.size.height+30, image.size.width, image.size.height)];
    warn.image = image;
    [self.scrollView addSubview:warn];
    
    UILabel *label1 = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/4, b_y+login.size.height+30, SCREEN_WIDTH/2+50, image.size.height)
                                            andText:@"温馨提示："
                                       andTextColor:[UIColor yellowColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(14)
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:label1];
    
    UILabel *label2 = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/4, b_y+login.size.height+60, SCREEN_WIDTH/2+50, image.size.height)
                                            andText:@"1.请确认您的手机处于正常状态"
                                       andTextColor:[UIColor yellowColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(13)
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:label2];
    
    UILabel *label3 = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/4, b_y+login.size.height+90, SCREEN_WIDTH/2+50, image.size.height)
                                            andText:@"2.请您务必注意密码的保密"
                                       andTextColor:[UIColor yellowColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(13)
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.scrollView addSubview:label3];
    
    
}


#pragma mark -- 提交按钮
- (void)ButtonClick:(UIButton *)sender{
    BOOL isPW = [self checkPassWordLenth:self.passWord.getText];
    BOOL isaPW = [self checkPassWordLenth:self.apassWord.getText];
    _weekSelf(weakSelf);
    if (isaPW && isPW) {
        if (![self.passWord.getText isEqualToString:self.apassWord.getText]) {
            [MBProgressHUD showHudTipStr:@"两次密码不一致"];
        }else{
            //重置密码 MARK: 重置密码操作在这里
            NSDictionary *dic = @{
                                  @"username":self.notificationDict[@"username"],
                                  @"password": self.passWord.getText
                                  };
            [[NetAPIManager sharedManager] request_common_WithPath:APPINTERFACE_ForgetUserPwd Params:dic succesBlack:^(id data) {
                [MBProgressHUD showHudTipStr:@"修改成功"];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[LoginVC class]]) {
                        [weakSelf.navigationController popToViewController:controller animated:YES];
                    }
                }
            } failue:^(id data, NSError *error) {
                
            }];
        }
    }else{
        [MBProgressHUD showHudTipStr:@"密码格式错误"];
    }
    
}

#pragma mark --  判断密码位数是否正确

- (BOOL)checkPassWordLenth:(NSString *)text{
    if ((text.length<=16) && (text.length>=6)) {
        return YES;
    }else{
        return NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
