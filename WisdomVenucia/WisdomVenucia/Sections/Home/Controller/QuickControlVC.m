//
//  QuickControlVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "QuickControlVC.h"
#import "BTManager.h"

@interface QuickControlVC ()<BTManagerDelegate>

@property (strong,nonatomic ) UIImage   *centerImg;
@property (strong,nonatomic ) UIImage   *centerImg_Sel;
@property (strong, nonatomic) BTManager *btmanager;

@end

@implementation QuickControlVC{
    BOOL _isFirstSel;
    BOOL _isSecSel;
    UIButton *_Left2;
    UIButton *_Right2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"快捷控制";
}

#pragma mark -- data
- (void)initData{
    self.btmanager = [BTManager sharedManager];
    self.btmanager.delegate = self;
    
    _isFirstSel = NO;
    _isSecSel   = NO;
}

#pragma mark -- UI
- (void)initUI{
    CGFloat h = SCREEN_HIGHT == 480? SCREEN_HIGHT/3 : 180;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, h)];
    imageView.image = [UIImage imageNamed:@"QuickControlBack"];
    [self.view addSubview:imageView];
    
    [self initButton];
    [self setSecLeftNavigation];
    [self setSecRightNavigation];
}


#pragma mark -- 创建圆形界面
- (void)initButton{
    CGFloat h = SCREEN_HIGHT == 480? SCREEN_HIGHT/3 : 200;
    CGFloat t = SCREEN_HIGHT/775;//缩放倍数
    CGFloat s = SCREEN_HIGHT == 480? 5 : 20;  //间隔
    UIView *circleview = [[UIView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-185, 64+h*t+s, 370, 370)];
    circleview.backgroundColor = [UIColor clearColor];
    
        //上边
    UIImage *topImg = [UIImage imageNamed:@"QuickTop"];
    UIButton *Top = [[UIButton alloc] initWithFrame:VIEWFRAME(184.5-topImg.size.width/2, 0, topImg.size.width, topImg.size.height)];
    Top.tag = 201;
    [Top addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Top setBackgroundImage:topImg forState:UIControlStateNormal];
    [Top setBackgroundImage:[UIImage imageNamed:@"QuickTop_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:Top Title:nil setImage:[UIImage imageNamed:@"QuickTop_Img"] type:2];
    
    
    //左边第一个
    UIButton *Left1 = [[ UIButton alloc] initWithFrame:VIEWFRAME(2, 30, 140, 150)];
    Left1.tag = 202;
    [Left1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Left1 setBackgroundImage:[UIImage imageNamed:@"QuickLeft1"] forState:UIControlStateNormal];
    [Left1 setBackgroundImage:[UIImage imageNamed:@"QuickLeft1_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:Left1 Title:@"解锁" setImage:[UIImage imageNamed:@"QuickRight1_Img"] type:3];
    
    
    //左边第二个
    _Left2 = [[ UIButton alloc] initWithFrame:VIEWFRAME(2, 183.5, 140, 150)];
    _Left2.tag = 203;
    [_Left2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Left2 setBackgroundImage:[UIImage imageNamed:@"QuickLeft2"] forState:UIControlStateNormal];
    [_Left2 setBackgroundImage:[UIImage imageNamed:@"QuickLeft2_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:_Left2 Title:nil setImage:[UIImage imageNamed:@"QuickLeft2_Img"] type:2];

    //右边第一个
    UIButton *Right1 = [[ UIButton alloc] initWithFrame:VIEWFRAME(228, 30, 140, 150)];
    Right1.tag = 204;
    [Right1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Right1 setBackgroundImage:[UIImage imageNamed:@"QuickRight1"] forState:UIControlStateNormal];
    [Right1 setBackgroundImage:[UIImage imageNamed:@"QuickRight1_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:Right1 Title:@"闭锁" setImage:[UIImage imageNamed:@"QuickLeft1_Img"] type:3];
    
    //右边第二个
    _Right2 = [[ UIButton alloc] initWithFrame:VIEWFRAME(228, 183.5, 140, 150)];
    _Right2.tag = 205;
    [_Right2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_Right2 setBackgroundImage:[UIImage imageNamed:@"QuickRight2"] forState:UIControlStateNormal];
    [_Right2 setBackgroundImage:[UIImage imageNamed:@"QuickRight2_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:_Right2 Title:nil setImage:[UIImage imageNamed:@"QuickRight2_Img"] type:2];
    
    //下边
    UIButton *Foot = [[UIButton alloc] initWithFrame:VIEWFRAME(185-topImg.size.width/2, 363-topImg.size.height, topImg.size.width, topImg.size.height)];
    Foot.tag = 206;
    [Foot addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Foot setBackgroundImage:[UIImage imageNamed:@"QuickFoot"] forState:UIControlStateNormal];
    [Foot setBackgroundImage:[UIImage imageNamed:@"QuickFoot_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:Foot Title:@"后背门" setImage:[UIImage imageNamed:@"QuickFoot_Img"] type:2];
    
    //中心
    self.centerImg = [UIImage imageNamed:@"QuickCenter2_Img"];
    self.centerImg_Sel = [UIImage imageNamed:@"QuickCenter2_Img"];
    
    
    UIButton *Center = [UIButton buttonWithType:UIButtonTypeCustom];
    Center.tag = 207;
    [Center addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [Center setBackgroundImage:[UIImage imageNamed:@"QuickCenter"] forState:UIControlStateNormal];
    [Center setBackgroundImage:[UIImage imageNamed:@"QuickCenter_Sel"] forState:UIControlStateHighlighted];
    [self SetButtonWithButton:Center Title:nil setImage:self.centerImg_Sel  type:2];
    [Center setImage:self.centerImg forState:UIControlStateHighlighted];
    UIImage *centerImg = [UIImage imageNamed:@"QuickCenter"];
    Center.frame= VIEWFRAME(185-centerImg.size.width/2-0.7, 185-centerImg.size.height/2-3, centerImg.size.width, centerImg.size.height);
    
    
    
    
    
//    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotateGesture:)];
//
//    [circleview addGestureRecognizer:pinchGesture];//imageView添加手势识别
    
    
    
    circleview.transform = CGAffineTransformMakeScale(t, t);
    [circleview addSubview:Left1];
    [circleview addSubview:_Left2];
    [circleview addSubview:Right1];
    [circleview addSubview:_Right2];
    [circleview addSubview:Top];
    [circleview addSubview:Foot];
    [circleview addSubview:Center];
    [self.view addSubview:circleview];
    
    UIImage *nextImg = [UIImage imageNamed:@"QuickNextBtn"];
    UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH-nextImg.size.width, 64+h+10, nextImg.size.width, nextImg.size.height)];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    button.titleLabel.font = SYSTEMFONT(16);
    [button setBackgroundImage:nextImg forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(RightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

- (void)buttonClick:(UIButton *)sender{
    NSData *data = nil;
    switch (sender.tag) {
        case 201:{
            //双闪
            if (!_isFirstSel) {
                Byte b[] = {0x5A, 0xA5, 0x05, 0x2B, 0x01, 0x00,0x01, 0x2D};//开
                data = [NSData dataWithBytes:&b length:sizeof(b)];
                _isFirstSel = YES;
            } else {
                Byte b[] = {0x5A, 0xA5, 0x05, 0x2B, 0x01, 0x00,0x00, 0x2C};//关
                data = [NSData dataWithBytes:&b length:sizeof(b)];
                _isFirstSel = NO;
            }
            break;
        }
        case 202:{
            //解锁{0x5A, 0xA5, 0x05, 0x2D, 0x01, 0x00,0x01, 0x2F};
            Byte b[] = {0x5A, 0xA5, 0x05, 0x2D, 0x01, 0x00,0x01, 0x2F};
            data = [NSData dataWithBytes:&b length:sizeof(b)];
            break;
        }
        case 203:{
            //近光灯开
            [sender setSelected:YES];
            Byte b[] = {0x5A, 0xA5, 0x05, 0x2A, 0x01, 0x00,0x01, 0x2C};//开
            data = [NSData dataWithBytes:&b length:sizeof(b)];
            break;
        }
        case 204:{
            // 闭锁
            
            Byte b[] = {0x5A, 0xA5, 0x05, 0x2D, 0x01, 0x00,0x00, 0x2E };
            data = [NSData dataWithBytes:&b length:sizeof(b)];
            break;
        }
        case 205:{
            //近光灯关
            [_Left2 setSelected:NO];
            Byte b[] = {0x5A, 0xA5, 0x05, 0x2A, 0x01, 0x00,0x00, 0x2B};//关
            data = [NSData dataWithBytes:&b length:sizeof(b)];
            break;
        }
        case 206:{
            //后辈门
            Byte b[] = {0x5A, 0xA5, 0x05, 0x2D, 0x01, 0x00,0x03, 0x31};//开
            data = [NSData dataWithBytes:&b length:sizeof(b)];
            break;
        }
        case 207:{
            //喇叭
            if (!_isSecSel) {
                Byte b[] = {0x5A, 0xA5, 0x05, 0x2C, 0x01, 0x00,0x01, 0x2E};//开
                data = [NSData dataWithBytes:&b length:sizeof(b)];
                _isSecSel = YES;
            } else {
                Byte b[] = {0x5A, 0xA5, 0x05, 0x2C, 0x01, 0x00,0x00, 0x2D};//关
                data = [NSData dataWithBytes:&b length:sizeof(b)];
                _isSecSel = NO;
            }
            
//            if ([sender.imageView.image isEqual:self.centerImg_Sel]) {
//                [sender setImage:self.centerImg_Sel forState:UIControlStateNormal];
//                [sender setImage:self.centerImg forState:UIControlStateHighlighted];
//            }else {
//                [sender setImage:self.centerImg forState:UIControlStateNormal];
//                [sender setImage:self.centerImg_Sel forState:UIControlStateHighlighted];
//            }
            break;
        }
            
        default:
            break;
    }
    [self.btmanager writeDataToPeripheral:data];
}



/**
 *   1 为偏上
 *   2 为偏中
 *   3 为偏下
 **/

- (void)SetButtonWithButton:(UIButton *)button Title:(NSString *)title setImage:(UIImage *)image type:(NSInteger)type{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeTop];
    [button setTintColor:[UIColor redColor]];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateHighlighted];
    [button setImage:image forState:UIControlStateSelected];
    
    [button.titleLabel setBackgroundColor:[UIColor clearColor] ];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0] ];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    if (type == 1) {
        [button setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height -10,
                                                    0.0,
                                                    0.0,
                                                    -titleSize.width)];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 10,
                                                    -image.size.width,
                                                    0.0,
                                                    0.0)];
    }else if (type == 2){
        [button setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height -10,
                                                    0.0,
                                                    0.0,
                                                    -titleSize.width)];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + 10,
                                                    -image.size.width,
                                                    0.0,
                                                    0.0)];
        
    }else if (type == 3){
        [button setImageEdgeInsets:UIEdgeInsetsMake(titleSize.height +10,
                                                    0.0,
                                                    titleSize.height +10,
                                                    -titleSize.width)];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height+titleSize.height +20,
                                                    -image.size.width,
                                                    0.0,
                                                    0.0)];
    }
    
    
}

- (void)setSecRightNavigation{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(RightButtonAction)];
    self.navigationItem.rightBarButtonItem = barBtn;
}

#pragma mark -- 右按钮动作
- (void)RightButtonAction{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"QuickControlNextVC" object:nil info:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
