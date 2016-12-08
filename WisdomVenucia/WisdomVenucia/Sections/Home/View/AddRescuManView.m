//
//  AddRescuManView.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "AddRescuManView.h"

@interface AddRescuManView()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *nameTextFiled;
@property (nonatomic, strong) UITextField *phoneTextFiled;
@property (nonatomic, strong) UIButton *sumitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation AddRescuManView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backView = [[UIView alloc] initWithFrame:APP_BOUNDS];
    self.backView.backgroundColor = [UIColor blackColor];
    
    self.topView = [[UIView alloc] initWithFrame:VIEWFRAME(20, 64 + 80, SCREEN_WIDTH - 40, SCREEN_HIGHT / 3)];
    self.topView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.topView];
    
    self.bottomView = [[UIView alloc] initWithFrame:VIEWFRAME(20,
                                                              64 + 80 + SCREEN_WIDTH - 40 + SCREEN_HIGHT / 3,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HIGHT - SCREEN_HIGHT / 3 - 64 - 40)];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomView];
    
    self.headImageView = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH / 2 - 50, 64 + 80, 100, 100)];
    self.headImageView.image = [UIImage imageNamed:@"HeadImage"];
    [self addSubview:self.headImageView];
    ViewRadius(self.headImageView, 50);
    
    //topView
    UILabel *nameLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"姓        名:" andTextColor:[UIColor whiteColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:nameLabel];
    
    UILabel *phoneLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"手机号码:" andTextColor:[UIColor whiteColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self.topView addSubview:phoneLabel];
    
    self.nameTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextFiled.backgroundColor = [UIColor whiteColor];
    self.nameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextFiled.placeholder = @"姓名";
    [self.topView addSubview:self.nameTextFiled];
    
    self.phoneTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneTextFiled.backgroundColor = [UIColor whiteColor];
    self.phoneTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextFiled.placeholder = @"手机号码:";
    [self.topView addSubview:self.phoneTextFiled];
    
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView).offset(-20);
        make.right.equalTo(self.topView).offset(-20);
        make.height.equalTo(@35);
        make.left.equalTo(phoneLabel.mas_right).offset(10);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.centerY.equalTo(self.phoneTextFiled);
        make.right.equalTo(self.phoneTextFiled.mas_left).offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneTextFiled.mas_top).offset(-20);
        make.right.equalTo(self.topView).offset(-20);
        make.height.equalTo(@35);
        make.left.equalTo(nameLabel.mas_right).offset(10);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(10);
        make.centerY.equalTo(self.nameTextFiled);
        make.right.equalTo(self.nameTextFiled.mas_left).offset(-10);
        make.width.equalTo(@80);
    }];

    //bottomView
    self.sumitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.sumitButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.sumitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sumitButton setBackgroundImage:[UIImage imageNamed:@"BaseButton"] forState:UIControlStateNormal];
    [self.sumitButton setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [self.sumitButton addTarget:self action:@selector(sumitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sumitButton setTag:101];
    [self.bottomView addSubview:self.sumitButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"BaseButton"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [self.cancelButton setTag:102];
    [self.bottomView addSubview:self.cancelButton];
    
    UILabel *tipTitleLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"温馨提示:" andTextColor:[UIColor redColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:tipTitleLabel];
    
    UILabel *tipContentLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"最多可添加3组联系人" andTextColor:[UIColor redColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:tipContentLabel];
;
    
    [self.sumitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.width.equalTo(self.cancelButton);
        make.left.equalTo(self.cancelButton.mas_right).offset(20);
        make.right.equalTo(self.bottomView).offset(-20);
        make.height.equalTo(@60);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.width.equalTo(self.sumitButton);
        make.right.equalTo(self.sumitButton.mas_left).offset(-20);
        make.left.equalTo(self.bottomView).offset(20);
        make.height.equalTo(@60);
    }];
    
    [tipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.bottom.equalTo(tipContentLabel.mas_top).offset(-10);
    }];
    
    [tipContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.bottom.equalTo(self.bottomView).offset(-10);
    }];
    
}

- (void)showAddRescuManView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.backView];
    [keyWindow addSubview:self];
    
    self.backView.alpha = 1.0;
    self.topView.frame = VIEWFRAME(20, -64 - 80, SCREEN_WIDTH - 40, SCREEN_HIGHT / 3);
    self.bottomView.frame = VIEWFRAME(20,
                                      SCREEN_HIGHT,
                                      SCREEN_WIDTH - 40,
                                      SCREEN_HIGHT - SCREEN_HIGHT / 3 - 64 - 80);
    self.headImageView.center = CGPointMake(SCREEN_WIDTH / 2, -64 - 80 - 50);
    _weekSelf(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.backView.alpha = 0.8;
        weakSelf.topView.frame = VIEWFRAME(20, 64 + 80, SCREEN_WIDTH - 40, SCREEN_HIGHT / 3);
        weakSelf.bottomView.frame = VIEWFRAME(20,
                                          64 + 80 + SCREEN_HIGHT / 3,
                                          SCREEN_WIDTH - 40,
                                          SCREEN_HIGHT - SCREEN_HIGHT / 3 - 64 - 80);
        weakSelf.headImageView.center = CGPointMake(SCREEN_WIDTH / 2, 64 + 80);
    }];
}

- (void)hideRescuManView {
    [self performSelector:@selector(removeSubView) withObject:nil afterDelay:0.2];
    _weekSelf(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.backView.alpha = 1.0;
        weakSelf.topView.frame = VIEWFRAME(20, -64 - 80, SCREEN_WIDTH - 40, SCREEN_HIGHT / 3);
        weakSelf.bottomView.frame = VIEWFRAME(20,
                                          SCREEN_HIGHT,
                                          SCREEN_WIDTH - 40,
                                          SCREEN_HIGHT - SCREEN_HIGHT / 3 - 64 - 80);
        weakSelf.headImageView.center = CGPointMake(SCREEN_WIDTH / 2, -64 - 80 - 50);
    }];
}

- (void)removeSubView {
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)sumitButtonClicked:(UIButton *)sender {
    if (_buttonClickedBlock) {
        _buttonClickedBlock(sender.tag, self.nameTextFiled.text, self.phoneTextFiled.text);
    }
}

- (void)cancelButtonClicked:(UIButton *)sender {
    if (_buttonClickedBlock) {
        _buttonClickedBlock(sender.tag,self.nameTextFiled.text, self.phoneTextFiled.text);
    }
}

@end
