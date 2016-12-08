//
//  DatePickerView.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/27.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DatePickerView.h"



@interface DatePickerView ()

@property (strong, nonatomic) UIView          *mainView;
@property (strong, nonatomic) UIDatePicker    *datepicker;
@property (strong, nonatomic) NSDateFormatter *dateformatter;


@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [tap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tap];
        
        self.dateformatter = [[NSDateFormatter alloc] init];
        [self.dateformatter setDateFormat:@"yyyy-MM-dd"];
        
        [self initUI];
        
    }
    return self;
}

- (void)initUI{
    self.mainView = [[UIView alloc] initWithFrame:VIEWFRAME(0, SCREEN_HIGHT, SCREEN_WIDTH, 250)];
    self.mainView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:VIEWFRAME(80, 0, SCREEN_WIDTH-160, 50)];
    label.text = @"请选择日期";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SYSTEMFONT(16);
    [self.mainView addSubview:label];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:VIEWFRAME(0, 0, 80, 50)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 2010;
    [self.mainView addSubview:cancel];
    
    UIButton *save = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-80, 0, 80, 50)];
    [save setTitle:@"确定" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    save.tag = 2020;
    [self.mainView addSubview:save];
    
    
    self.datepicker = [[UIDatePicker alloc] initWithFrame:VIEWFRAME(0, 50, SCREEN_WIDTH, 200)];
    [self.datepicker setMaximumDate:[NSDate date]];
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    [self.mainView addSubview:self.datepicker];
    
    [self addSubview:self.mainView];
}

#pragma mark -- 设置初始日期
- (void)setinitialDate:(NSString *)date{
    self.datepicker.date = [self.dateformatter dateFromString:date];
}

#pragma mark -- 设置最大最小日期
- (void)setMaxDate:(NSDate *)date{
    [self.datepicker setMaximumDate:date];
}

- (void)setMinDate:(NSDate *)date{
    [self.datepicker setMinimumDate:date];
}

- (void)setMaxStrDate:(NSString *)date{
    [self.datepicker setMaximumDate:[self.dateformatter dateFromString:date]];
}

- (void)setMinStrDate:(NSString *)date{
    [self.datepicker setMinimumDate:[self.dateformatter dateFromString:date]];
}

#pragma mark -- 出现动作
- (void)bringSubviewToFrontAction{
    UIView *view = [self superview];
    
    
    [view bringSubviewToFront:self];
    _weekSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.mainView.frame = VIEWFRAME(0, SCREEN_HIGHT-250, SCREEN_WIDTH, 250);
        
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -- 设置上面按钮动作
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 2010) {
        //取消
        [self sendSubviewToBackAction];
    }else{
        //确定
        if ([self.delegate respondsToSelector:@selector(didSaveClick:)]) {
            [self.delegate didSaveClick:[self.dateformatter stringFromDate:self.datepicker.date]];
            [self sendSubviewToBackAction];
        }
        
    }
}

#pragma mark -- 退出动作
- (void)sendSubviewToBackAction{
    UIView *view = [self superview];
    
    _weekSelf(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.mainView.frame = VIEWFRAME(0, SCREEN_HIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        [view sendSubviewToBack:weakSelf];
    }];
    
}


#pragma mark -- 设置手势动作
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self];
    BOOL isX = ViewX(self.mainView)<point.x && (ViewX(self.mainView)+ViewWidth(self.mainView))>point.x;
    BOOL isY = ViewY(self.mainView)<point.y && (ViewY(self.mainView)+ViewHeight(self.mainView))>point.y;
    if (!isX || !isY) {
        [self sendSubviewToBackAction];
    }
}



@end
