//
//  DiagnoseVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/21.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "DiagnoseVC.h"
#import <QuartzCore/QuartzCore.h>

@interface DiagnoseVC ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic)UIScrollView *scrollView;

@end

@implementation DiagnoseVC{
    CGFloat orign,random;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.title = @"车辆诊断";
}


- (void)initUI{
    [self setSecLeftNavigation];
    [self initImageAndButton];
}


- (void)initImageAndButton{
    self.scrollView = [[UIScrollView alloc] initWithFrame:APP_BOUNDS];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 620);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    
    //蓝色背景
    UIImageView *carBackground = [[UIImageView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, 280)];
    carBackground.image = [UIImage imageNamed:@"CarBackground"];
    [self.scrollView addSubview:carBackground];
    
    //状态标签
    UILabel *state = [[UILabel alloc] initWithFrame:VIEWFRAME(30, 64+10, 180, 20)];
    state.font = SYSTEMFONT(15);
    state.text = @"您的爱车健康状态:故障";
    state.textColor = RGBACOLOR(0.1, 0.84, 0.88, 1);
    [self.scrollView addSubview:state];
    
    //查看更多
    UIButton *getMore = [[UIButton alloc ]initWithFrame:VIEWFRAME(SCREEN_WIDTH-110, 64+10, 80, 20)];
    getMore.titleLabel.font = SYSTEMFONT(15);
    [getMore setTitle:@"查看详情" forState:UIControlStateNormal];
    [getMore setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [getMore addTarget:self action:@selector(getMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(10, 17, 60, 1)];
    cut.backgroundColor = [UIColor redColor];
    [getMore addSubview:cut];
    [self.scrollView addSubview:getMore];
    
    //转盘
    self.imageView = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-70, 64+45, 140, 140)];
    self.imageView.image = [UIImage imageNamed:@"DiagnoseImg_1"];
    [self.scrollView addSubview:self.imageView];
    
    //立即诊断按钮
    UIButton *diagButton = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-55, 64+204, 110, 32)];
    diagButton.backgroundColor = APP_COLOR_BASE_BACKGROUND;
    diagButton.titleLabel.font = SYSTEMFONT(15);
    ViewRadius(diagButton, 5);
    [diagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [diagButton setTitle:@"立即诊断" forState:UIControlStateNormal];
    [diagButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [diagButton setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateSelected];
    [diagButton addTarget:self action:@selector(diagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:diagButton];
    
    //标签
    UILabel *label = [[UILabel alloc] initWithFrame:VIEWFRAME(0, 64+250, SCREEN_WIDTH, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"立即获取体验最新车辆健康报告";
    label.font = SYSTEMFONT(14);
    [self.scrollView addSubview:label];
    
    //状态标签
    UIImage *image = [UIImage imageNamed:@"DiagnoseImg_2"];
    UIImageView *engineState = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-image.size.width/2, 64 + 295, image.size.width, image.size.height)];
    engineState.image = image;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:VIEWFRAME(0, 10, image.size.width/2, 30)];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentRight;
    label2.text = @"发动机状态";
    label2.font = SYSTEMFONT(14);
    [engineState addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:VIEWFRAME(image.size.width/2, 10, image.size.width/2, 30)];
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"优良";
    label3.font = SYSTEMFONT(14);
    [engineState addSubview:label3];
    [self.scrollView addSubview:engineState];
    
    //汽车logo
    //SCREEN_HIGHT - (64+255+image.size.height)
    CGFloat w = SCREEN_WIDTH*5/6;
    
    CGFloat h = w/2.26;
    
    UIImageView *carLogo = [[UIImageView alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/12, 64+330+image.size.height, w, h )];
    carLogo.image = [UIImage imageNamed:@"DiagnoseImg_3"];
    [self.scrollView addSubview:carLogo];
    
    
}


- (void)getMoreClick:(UIButton *)sender{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"DiagnoseMoreVC" object:nil info:nil];
}

- (void)diagButtonClick:(UIButton *)sender{
    
    [sender setSelected:![sender isSelected]];
    if ([sender.titleLabel.text isEqualToString:@"立即诊断"]) {
        //产生随机角度
//        srand((unsigned)time(0));  //不加这句每次产生的随机数不变
//        random = (rand() % 20) *10;
//        NSLog(@"%f",random);
        random = 50.000;
        [sender setTitle:@"停止" forState:UIControlStateNormal];
    } else {
        random = 0;
        [sender setTitle:@"立即诊断" forState:UIControlStateNormal];
    }
    
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+orign)]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * (0.0+random+orign)]];
    [spin setDuration:25];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    //[spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctione]];
    //添加动画
    [[self.imageView layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI * (10.0+random+orign));
    //锁定fromValue的位置
    orign = 0.0+random+orign;
    //orign = fmodf(orign, 2.0);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
