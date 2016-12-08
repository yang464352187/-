//
//  UnLockVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/10.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "UnLockVC.h"

@interface UnLockVC ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) UIImageView  *headImage;
@property (strong, nonatomic) UIView       *SwithView;
@property (strong, nonatomic) UISwitch     *switchCon;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton     *save;
@property (strong, nonatomic) UIButton     *cancel;
@property (strong, nonatomic) UILabel      *timeLabel;
@property (strong, nonatomic) UIImageView  *timeLogo;

@end

@implementation UnLockVC



#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
    self.title = @"未锁提醒";
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.SwithView];
    [self.view addSubview:self.timeLogo];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.save];
    [self.view addSubview:self.cancel];
    
    _weekSelf(weakSelf);
    
    [self.SwithView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH==320?60:80));
        make.left.equalTo(weakSelf.view.mas_left);
    }];
    CGFloat h = SCREEN_WIDTH == 320? 20 : 40;
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_SwithView.mas_bottom).offset(h);
        make.size.mas_equalTo(CGSizeMake(80, 120));
        make.right.equalTo(weakSelf.view.mas_right).offset(-h);
    }];
    
    [self.timeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 23));
        make.left.equalTo(weakSelf.view.mas_left).offset(h);
        make.centerY.equalTo(_pickerView.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(80, 33));
        make.left.equalTo(_timeLogo.mas_left).offset(20);
        make.centerY.equalTo(_pickerView.mas_centerY);
        make.right.equalTo(_pickerView.mas_left).offset(-20);
    }];
    
    NSDictionary *dic = DEFAULTS_GET_OBJ(mUnLook);
    if (dic) {
        [self.switchCon setOn:[dic[@"islook"] boolValue]];
        [self.pickerView selectRow:[dic[@"time"] integerValue] inComponent:0 animated:YES];
    }
    
}



#pragma mark -- Data
- (void)initData{
    

    
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
    
}

#pragma mark -- event response


- (void)ButtonClick:(UIButton *)sender{
    if (sender.tag == 105) {
        //确定
        NSInteger time = [self.pickerView selectedRowInComponent:0];
        NSDictionary *dic = @{@"islook" : @([self.switchCon isOn]),
                              @"time":@(time)};
        DEFAULTS_SET_OBJ(dic, mUnLook);
        DEFAULTS_SAVE;
        [self popGoBack];
    }else{
        //取消
        [self popGoBack];
    }
}

#pragma mark -- 打开未锁自动提醒
- (void)openUnLookTooth:(id *)sender{
    
}

#pragma mark -- picker view delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 60;
    }else{
        return 60;
    }
    
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li",row+1] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(0, 0, 40, 40)
//                                           andText:[NSString stringWithFormat:@"%li",row+1]
//                                      andTextColor:[UIColor whiteColor]
//                                        andBgColor:[UIColor clearColor]
//                                           andFont:SYSTEMFONT(20)
//                                  andTextAlignment:NSTextAlignmentLeft];
//    return label;
//}



#pragma mark -- getters and setters

- (UIImageView *)headImage{
    if (!_headImage) {
        CGFloat h = SCREEN_HIGHT == 480? SCREEN_HIGHT/3 : 180;
        _headImage = [[UIImageView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, h)];
        _headImage.image = [UIImage imageNamed:@"QuickControlBack"];
    }
    return _headImage;
}

- (UIView *)SwithView {
    if (!_SwithView) {
        _SwithView = [[UIView alloc] init];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"UnLockImg2"];
        
        
        UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(0, 0, 0, 0)
                                               andText:@"车辆未锁提醒"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(18)
                                      andTextAlignment:NSTextAlignmentCenter];
        
        UIView *cut = [[UIView alloc] init];
        cut.backgroundColor = CELL_COLOR_CUT;
        
        
        [_SwithView addSubview:label];
        [_SwithView addSubview:self.switchCon];
        [_SwithView addSubview:imageview];
        [_SwithView addSubview:cut];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 23));
            make.left.equalTo(_SwithView.mas_left).offset(20);
            make.centerY.equalTo(_SwithView.mas_centerY);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_left).offset(20);
            make.centerY.equalTo(_SwithView.mas_centerY);
            make.right.equalTo(_switchCon.mas_left).offset(0);
        }];
        
        [self.switchCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_SwithView.mas_right).offset(-20);
            make.centerY.equalTo(_SwithView.mas_centerY);
        }];
        
        [cut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.left.equalTo(_SwithView.mas_left);
            make.bottom.equalTo(_SwithView.mas_bottom);
        }];
        
    }
    return _SwithView;
}

- (UISwitch *)switchCon{
    if (!_switchCon) {
        _switchCon                 = [[UISwitch alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-80, 64+55, 30, 20)];
        ViewRadius(_switchCon, 15.5);
        _switchCon.thumbTintColor  = [UIColor whiteColor];
        //self.switchControl.tintColor = APP_COLOR_SWITCH_GRAY;
        _switchCon.backgroundColor = APP_COLOR_SWITCH_GRAY;
        [_switchCon addTarget:self action:@selector(openUnLookTooth:) forControlEvents:UIControlEventValueChanged];

    }
    return _switchCon;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:VIEWFRAME(0, 64 + 40, 300, 210)];
        _pickerView.delegate =self;
        _pickerView.dataSource = self;
        _pickerView.tintColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        
    }
    
    return _pickerView;
}


- (UIImageView *)timeLogo{
    if (!_timeLogo) {
        _timeLogo = [[UIImageView alloc] init];
        _timeLogo.image = [UIImage imageNamed:@"UnLockImg1"];
    }
    return _timeLogo;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel createLabelWithFrame:VIEWFRAME(0, 0, 0, 0)
                                           andText:@"时间设定"
                                      andTextColor:[UIColor whiteColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(18)
                                  andTextAlignment:NSTextAlignmentCenter];
    }
    return _timeLabel;
}


- (UIButton *)save{
    if (!_save) {
        _save  = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
        CGFloat s = (SCREEN_WIDTH - motifyImg.size.width*2)/4;
        _save.tag = 105;
        _save.frame = VIEWFRAME(s, SCREEN_HIGHT-motifyImg.size.height-30, motifyImg.size.width, motifyImg.size.height);
        
        //_save.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        _save.titleLabel.font = SYSTEMFONT(18);
        
        [_save setTitle:@"确定" forState:UIControlStateNormal];
        
        [_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_save setBackgroundImage:motifyImg forState:UIControlStateNormal];
        
        [_save setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
        
        [_save addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _save;
}

- (UIButton *)cancel{
    if (!_cancel) {
        
        _cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
        CGFloat s = (SCREEN_WIDTH - motifyImg.size.width*2)/4;
        _cancel.tag = 106;
        
        _cancel.frame = VIEWFRAME(SCREEN_WIDTH/2+s, SCREEN_HIGHT-motifyImg.size.height-30, motifyImg.size.width, motifyImg.size.height);
        
        //_cancel.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        _cancel.titleLabel.font = SYSTEMFONT(18);
        
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_cancel setBackgroundImage:motifyImg forState:UIControlStateNormal];
        
        [_cancel setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
        
        [_cancel addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
    return _cancel;
}


@end
