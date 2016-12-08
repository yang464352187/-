//
//  StopTimeVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "StopTimeVC.h"
#import "MsgPlaySound.h"
#import "MZTimerLabel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "GraphPreviewVC.h"

#define kSTOP_TIME       @"kstop_time"

@interface StopTimeVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MZTimerLabelDelegate,AMapLocationManagerDelegate>

@property (strong, nonatomic) UIScrollView   *scrollView;
@property (strong, nonatomic) UIPickerView   *pickerView;
@property (strong, nonatomic) UIView         *timeView;
@property (strong, nonatomic) UIView         *memoView;
@property (strong, nonatomic) UIButton       *start;
@property (strong, nonatomic) UITextField    *memoField;
@property (strong, nonatomic) UITextView     *placeField;
@property (strong, nonatomic) UIButton       *position;
@property (strong, nonatomic) UIButton       *camera;
@property (strong, nonatomic) UIButton       *imageView;
@property (strong, nonatomic) UILabel        *timeLabel;
@property (strong, nonatomic) UILabel        *remindLabel;
@property (assign, nonatomic) NSTimeInterval delaytime;
@property (strong, nonatomic) NSDate         *endDate;
@property (strong, nonatomic) NSTimer        *timer;
@property (strong, nonatomic) NSDateFormatter *dateformater;
@property (strong, nonatomic) MZTimerLabel   *mztimeLabel;
@property (nonatomic, strong) AMapLocationManager *locationManager; //后台定位管理对象

@end

@implementation StopTimeVC



#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
    self.title = @"停车计时";
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.scrollView];
//    [self.view addSubview:self.timeView];
//    [self.view addSubview:self.pickerView];
//    [self.view addSubview:self.memoView];
//    [self.view addSubview:self.start];
//    [self.view addSubview:self.memoField];
//    [self.view addSubview:self.placeField];
//    [self.view addSubview:self.camera];
//    [self.view addSubview:self.position];
//    [self.view addSubview:self.imageView];
//    [self.view addSubview:self.timeLabel];
//    [self.view addSubview:self.remindLabel];
    
    _weekSelf(weakSelf);
    
    [self.camera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.centerY.equalTo(_memoField.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(38, 31.3));
    }];
    
    [self.memoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.height.mas_equalTo(50);
        make.top.equalTo(_memoView.mas_bottom).offset(20);
        make.right.equalTo(_camera.mas_left).offset(-20);
    }];
    
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_memoField.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 60));
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 31.3));
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.centerY.equalTo(_placeField.mas_centerY);
    }];
    [self.start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(448.0/3, 56));
        make.top.equalTo(_placeField.mas_bottom).offset(40);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self setUIByData];
    
}



#pragma mark -- Data
- (void)initData{
    self.dateformater = [[NSDateFormatter alloc] init];
    [self.dateformater setDateFormat:@"hh:mm"];
    
    if (IsIOS8Later) {
        // iOS8注册本地通知类型
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    [AMapLocationServices sharedServices].apiKey = MAMapKey;
    self.locationManager                         = [[AMapLocationManager alloc]init];
    self.locationManager.delegate                = self;
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    
    //   逆地理请求超时时间，可修改，最小2s
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
    
}

#pragma mark -- event response

- (void)setUIByData{
    NSDictionary *dic = DEFAULTS_GET_OBJ(kSTOP_TIME);
    if (dic) {
        self.delaytime = [dic[@"endtime"] doubleValue];
        self.endDate = [NSDate dateWithTimeIntervalSince1970:self.delaytime];
        
        NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
        if (nowtime < self.delaytime) {
            [self.start setSelected:YES];
            [self.start setTitle:@"结束停车" forState:UIControlStateNormal];
            
            
            [self.mztimeLabel setCountDownToDate:self.endDate];
            [self.mztimeLabel start];
            
            
            //设置提醒时间
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSCalendarUnit calendarUnit = NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour|NSCalendarUnitMinute |NSCalendarUnitDay;
            NSDateComponents *startCom = [gregorian components:calendarUnit fromDate:self.endDate];
            NSDateComponents *endCom = [gregorian components:calendarUnit fromDate:[NSDate date]];
            NSString *remind = [self.dateformater stringFromDate:self.endDate];
            self.remindLabel.text = [NSString stringWithFormat:@"将于%@%@提醒",startCom.day == endCom.day?@"今天":@"明天",remind];
            
            self.memoField.text = dic[@"remind"]?dic[@"remind"]:@"";
            self.placeField.text = dic[@"place"]?dic[@"place"]:@"";
            [self setMemoViewEnabled:NO];
            
            if (dic[@"place"]) {
                self.placeField.text = dic[@"place"];
            }
            if (dic[@"remind"]) {
                self.memoField.text = dic[@"remind"];
            }
            NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                UIImage *image = [UIImage imageWithContentsOfFile:file];
                [self.imageView setImage:image forState:UIControlStateNormal];
                self.imageView.hidden = NO;
                self.placeField.frame = VIEWFRAME(20, 64+ 440,SCREEN_WIDTH-80, 50);
            }
            
        }else{
            self.timeLabel.hidden = YES;
            self.remindLabel.hidden = YES;
            DEFAULTS_REMOVE(kSTOP_TIME);
            DEFAULTS_SAVE;
            NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
            }
        }
        
        
    }else{
        self.timeLabel.hidden = YES;
        self.remindLabel.hidden = YES;
    }
}


- (void)buttonClick:(UIButton *)sender{
    NSInteger hour = [self.pickerView selectedRowInComponent:0];
    NSInteger minute = [self.pickerView selectedRowInComponent:1];
    if (hour ==  0 && minute == 0) {
        [MBProgressHUD showHudTipStr:@"必须先设置停车时间"];
        return;
    }
    [sender setSelected:!sender.isSelected];
    [sender setTitle:sender.isSelected?@"结束停车":@"开始停车" forState:UIControlStateNormal];
    if (sender.isSelected) {
        //开始停车
        NSInteger hour = [self.pickerView selectedRowInComponent:0];
        NSInteger minute = [self.pickerView selectedRowInComponent:1];
        MsgPlaySound *sound = [[MsgPlaySound alloc] initSystemShake];
        [sound play];
        
        
        NSTimeInterval lag = hour * 3600+ minute*60;
        self.endDate = [NSDate dateWithTimeIntervalSinceNow:lag];
        self.delaytime = [self.endDate timeIntervalSince1970];
        [self.mztimeLabel setup];
        [self.mztimeLabel setCountDownToDate:self.endDate];
        [self.mztimeLabel start];
        
        //设置提醒时间
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calendarUnit = NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour|NSCalendarUnitMinute |NSCalendarUnitDay;
        NSDateComponents *startCom = [gregorian components:calendarUnit fromDate:self.endDate];
        NSDateComponents *endCom = [gregorian components:calendarUnit fromDate:[NSDate date]];
        NSString *remind = [self.dateformater stringFromDate:self.endDate];
        self.remindLabel.text = [NSString stringWithFormat:@"将于%@%@提醒",startCom.day == endCom.day?@"今天":@"明天",remind];
        
        NSDictionary *dic = @{@"endtime" : @(self.delaytime),
                              @"remind"  : self.memoField.text,
                              @"place"   : self.placeField.text
                              };
        DEFAULTS_SET_OBJ(dic, kSTOP_TIME);
        DEFAULTS_SAVE;
        [self setMemoViewEnabled:NO];
        [self setPushNotification];
        
        
    }else{
        //结束停车
        [self setMemoViewEnabled:YES];
        DEFAULTS_REMOVE(kSTOP_TIME);
        [self.mztimeLabel pause];
        [self.mztimeLabel reset];
        [self removeNotification];
        NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
    }
    
}


- (void)setPushNotification{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    
    localNotif.fireDate = self.endDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"停车时间到了";
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertTitle = NSLocalizedString(@"智慧同致提醒您", nil);
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//    localNotif.userInfo = infoDict;
    
    //  设置好本地推送后必须调用此方法启动此推送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

- (void)removeNotification{
    //  取消所有的本地推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)setMemoViewEnabled:(BOOL)bo{
    self.memoField.userInteractionEnabled = bo;
    self.placeField.userInteractionEnabled = bo;
    self.camera.userInteractionEnabled = bo;
    self.position.userInteractionEnabled = bo;
    self.timeLabel.hidden = bo;
    self.remindLabel.hidden = bo;
    self.pickerView.hidden = !bo;
}


//时间倒计时完毕进入的回调
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    MsgPlaySound *sound = [[MsgPlaySound alloc] initSystemShake];
    [sound play];
    [self setMemoViewEnabled:YES];
    DEFAULTS_REMOVE(kSTOP_TIME);
    [self.mztimeLabel pause];
    [self.mztimeLabel reset];
    [self.start setSelected:NO];
    [self.start setTitle:@"开始停车" forState:UIControlStateNormal];
    self.placeField.text = @"";
    self.memoField.text = @"";
    self.imageView.hidden = YES;
    self.placeField.frame = VIEWFRAME(20, 64+380, SCREEN_WIDTH-80, 50);
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
    }
}


- (void)cameraAction{
//    if (!_imageView.hidden ) {
//        return;
//    }
    
    
    //判断用户是否有权限访问相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        if (IsIOS8Later) {
            UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:@"需要访问您的相机，请到设置里打开位置服务"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定",nil];
            alert.tag = 66;
            [alert show];
        } else {
            UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:@"您关闭了在线速运访问位置的权限，请在[设置]->[隐私]->[相机]里允许在线速运打开相机"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag = 67;
            [alert show];
        }
        return;
        
    }
    UIImagePickerController *pick=[[UIImagePickerController alloc]init];
    //判断相机是否可用,因为模拟机是不可以的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;//设置 pick 的类型为相机
        pick.allowsEditing = true;//设置是否可以编辑相片涂鸦
        pick.delegate = self;
        [self presentViewController:pick animated:true completion:nil];
    }
    else
    {
        NSLog(@"相机不可用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    //判断选择的是否是图片,这个 public.image和public.movie是固定的字段.
    if ([type isEqualToString:@"public.image"])
    {
        //        //设置图片  MARK: 上传头像在这里进行
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        //这一步主要是判断当是用相机拍摄的时候，保存到相册
//        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//        }
        NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
        
        BOOL resuelt = [UIImagePNGRepresentation(image) writeToFile:file atomically:YES];
        if (resuelt) {
            [self.imageView setImage:image forState:UIControlStateNormal];
            self.imageView.hidden = NO;
            self.placeField.frame = VIEWFRAME(20, 64+ 440,SCREEN_WIDTH-80, 50);
        }
        
        
    }
    [picker dismissViewControllerAnimated:false completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:false completion:nil];
}

- (void)positionAction{
    _weekSelf(weakSelf);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        if (regeocode)
        {
            weakSelf.placeField.text = regeocode.formattedAddress;
        }
    }];
}

#pragma mark --

- (void)imageviewClick{
    GraphPreviewVC *vc = [[GraphPreviewVC alloc] init];
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *file = [strUrl stringByAppendingFormat: @"/garsh.jpg"];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:file]];
    vc.images = @[image];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -- alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 66 && buttonIndex == 1) {
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }else{
        
    }
    
}



#pragma mark -- picker view delegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 24;
    }else{
        return 60;
    }
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%li",row] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark -- getters and setters

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:APP_BOUNDS];
        _scrollView.contentSize = CGSizeMake(0, 660);
        
        [_scrollView addSubview:self.timeView];
        [_scrollView addSubview:self.pickerView];
        [_scrollView addSubview:self.memoView];
        [_scrollView addSubview:self.start];
        [_scrollView addSubview:self.memoField];
        [_scrollView addSubview:self.placeField];
        [_scrollView addSubview:self.camera];
        [_scrollView addSubview:self.position];
        [_scrollView addSubview:self.imageView];
        [_scrollView addSubview:self.timeLabel];
        [_scrollView addSubview:self.remindLabel];

    }
    
    return _scrollView;
}


- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-150, 64 + 40, 300, 210)];
        _pickerView.delegate =self;
        _pickerView.dataSource = self;
        _pickerView.tintColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        
        
        
        UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(97, 95, 40, 20)
                                               andText:@"小时"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(18)
                                      andTextAlignment:NSTextAlignmentLeft];
        [_pickerView addSubview:label];
        UILabel *label1 = [UILabel createLabelWithFrame:VIEWFRAME(247, 95, 40, 20)
                                               andText:@"分钟"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(18)
                                      andTextAlignment:NSTextAlignmentLeft];
        [_pickerView addSubview:label1];
    }
    
    return _pickerView;
}

- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, 40)];
        _timeView.backgroundColor = CELL_COLOR_BACKGROUND;
        
        UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(20, 0, 200, 30)
                                               andText:@"预计停留时间"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(16)
                                      andTextAlignment:NSTextAlignmentLeft];
        [_timeView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeView.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 30));
            make.centerY.equalTo(_timeView.mas_centerY);
        }];

    }
    return _timeView;
}

- (UIView *)memoView{
    if (!_memoView) {
        _memoView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 64+250, SCREEN_WIDTH, 40)];
        _memoView.backgroundColor = CELL_COLOR_BACKGROUND;
        
        UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(20, 0, 200, 30)
                                               andText:@"预计停留时间"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(16)
                                      andTextAlignment:NSTextAlignmentLeft];
        [_memoView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_memoView.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 30));
            make.centerY.equalTo(_memoView.mas_centerY);
        }];
        
    }
    return _memoView;
}


- (UIButton *)start{
    if (!_start) {
        UIImage *Img = [UIImage imageNamed:@"BaseButton"];
        _start = [UIButton buttonWithType:UIButtonTypeCustom];
        _start.titleLabel.font = SYSTEMFONT(18);
        [_start setTitle:@"开始停车" forState:UIControlStateNormal];
        [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_start setBackgroundImage:Img forState:UIControlStateNormal];
        [_start setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
        [_start addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _start;
}

- (UIButton *)camera{
    if (!_camera) {
        _camera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_camera setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
        [_camera addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _camera;
}

- (UIButton *)position{
    if (!_position) {
        _position = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_position setImage:[UIImage imageNamed:@"MyInfoImage5"] forState:UIControlStateNormal];
        [_position setBackgroundImage:[UIImage imageNamed:@"MyInfoImage5"] forState:UIControlStateNormal];
        [_position addTarget:self action:@selector(positionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _position;
}

- (UITextField *)memoField{
    if (!_memoField) {
        _memoField = [[UITextField alloc] initWithFrame:VIEWFRAME(20, 64+260, SCREEN_WIDTH-40, 50)];
        _memoField.placeholder = @"请输入备忘信息";
        _memoField.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 10, 0)];
        _memoField.leftViewMode = UITextFieldViewModeAlways;
        _memoField.backgroundColor = [UIColor whiteColor];
        ViewRadius(_memoField, 5);
    }
    return _memoField;
}

- (UITextView *)placeField{
    if (!_placeField) {
        _placeField = [[UITextView alloc] initWithFrame:VIEWFRAME(20, 64+380, SCREEN_WIDTH-80, 50)];
//        _placeField.placeholder = @"";
//        _placeField.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 10, 0)];
//        _placeField.leftViewMode = UITextFieldViewModeAlways;
        _placeField.backgroundColor = [UIColor whiteColor];
        _placeField.font = SYSTEMFONT(16);
        ViewRadius(_placeField, 5);
    }
    return _placeField;
}


- (UIButton *)imageView{
    if (!_imageView) {
        _imageView = [[UIButton alloc] init];
        _imageView.hidden = YES;
        [_imageView addTarget:self action:@selector(imageviewClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _imageView;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel createLabelWithFrame:VIEWFRAME(30, 64+80 ,SCREEN_WIDTH-60, 100)
                                           andText:@"00:00:00"
                                      andTextColor:[UIColor whiteColor]
                                        andBgColor:APP_COLOR_BASE_BAR
                                           andFont:SYSTEMFONT(40)
                                  andTextAlignment:NSTextAlignmentCenter];
        ViewRadius(_timeLabel, 8);
        
    }
    return _timeLabel;
}
            

- (UILabel *)remindLabel{
    if (!_remindLabel) {
        _remindLabel = [UILabel createLabelWithFrame:VIEWFRAME(0, 64+180, SCREEN_WIDTH, 70)
                                           andText:@"将于今天00:00提醒"
                                      andTextColor:[UIColor yellowColor]
                                        andBgColor:[UIColor clearColor]
                                           andFont:SYSTEMFONT(17)
                                  andTextAlignment:NSTextAlignmentCenter];
        
    }
    return _remindLabel;
}

- (MZTimerLabel *)mztimeLabel{
    if (!_mztimeLabel) {
        _mztimeLabel = [[MZTimerLabel alloc] initWithLabel:self.timeLabel andTimerType:MZTimerLabelTypeTimer];
        
        _mztimeLabel.delegate = self;
    }
    return _mztimeLabel;
}

@end
