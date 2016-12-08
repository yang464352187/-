//
//  FeedBackVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/30.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "FeedBackVC.h"

#define kButtonW SCREEN_WIDTH-40

@interface FeedBackVC ()

@property (strong, nonatomic) NSArray *titleList;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self initData];
    [self initUI];
}

#pragma mark -- Data
- (void)initData{
    self.titleList = @[@"车况查询异常",@"快捷控制异常",@"驾驶行为异常",@"位置共享异常",@"短信提醒异常",@"车辆警告异常",@"黑屏闪退重启",@"功能增加",@"其他问题"];
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:VIEWFRAME(20,  64+25, 100, 20)];
    label1.textColor = [UIColor whiteColor];
    label1.text = @"反馈类型:";
    label1.font = SYSTEMFONT(14);
    [self.view addSubview:label1];
    
    
    
    UIView *buttonView = [[UIView alloc] initWithFrame:VIEWFRAME(20, 64+60, kButtonW, 214)];
    buttonView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<self.titleList.count; i++) {
        UIButton * button = [self createButtonWithPlace:i];
        [buttonView addSubview:button];
    }
    [self.view addSubview:buttonView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:VIEWFRAME(20,  64+290, 100, 20)];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"意见建议:";
    label2.font = SYSTEMFONT(14);
    [self.view addSubview:label2];
    
    //意见反馈按钮
    
    UIButton *feedButton = [[UIButton alloc] initWithFrame:VIEWFRAME(0, 64+320, SCREEN_WIDTH, 50)];
    feedButton.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    feedButton.titleLabel.font = SYSTEMFONT(14);
    [feedButton setTitle:@"意见和反馈" forState:UIControlStateNormal];
    [feedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedButton setImage:[UIImage imageNamed:@"FeedBackImg"] forState:UIControlStateNormal];
    [feedButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0,SCREEN_WIDTH - 95)];
    [feedButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, SCREEN_WIDTH-45, 0.0, 0.0)];
    [feedButton addTarget:self action:@selector(SuggestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedButton];
    
    CGFloat s = SCREEN_HIGHT == 480? 30 : 60;
    UILabel *label3 = [[UILabel alloc] initWithFrame:VIEWFRAME(0,  SCREEN_HIGHT-s, SCREEN_WIDTH, 20)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor yellowColor];
    label3.text = @"Copyright @ 2015 , tungthin AllRights Reserved.";
    label3.font = SYSTEMFONT(12);
    [self.view addSubview:label3];
    
}


#pragma mark -- 创建意见类型按钮
- (UIButton *)createButtonWithPlace:(NSInteger)place{
    CGFloat w = (kButtonW-4)/3;
    CGRect frame = VIEWFRAME(1+place%3*(w+1), 1+place/3*(70+1), w, 70);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2080+place;
    
    button.titleLabel.font = SYSTEMFONT(14);
    [button setTitle:self.titleList[place] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = RGBCOLOR(0.01, 0.72, 0.93);
    
    UIImage *image = [UIImage imageNamed:@"FeedBack"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:VIEWFRAME(w-image.size.width, 70-image.size.height, image.size.width, image.size.height)];
    imageView.image = image;
    [button addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:VIEWFRAME(image.size.width/2-1, image.size.height/2-1, image.size.width/2, image.size.height/2)];
    label.text = [NSString stringWithFormat:@"%li",(long)place];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = SYSTEMFONT(10);
    [imageView addSubview:label];
    
    return button;
}

#pragma  mark -- 按钮动作
- (void)buttonClick:(UIButton *)sender{
    NSDictionary *dic = @{@"title":self.titleList[sender.tag-2080]};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"SuggestVC" object:nil info:dic];
    
}

- (void)SuggestClick{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"SuggestVC" object:nil info:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
