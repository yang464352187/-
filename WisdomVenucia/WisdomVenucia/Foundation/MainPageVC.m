//
//  MainPageVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/7.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MainPageVC.h"

@interface MainPageVC ()

@end

@implementation MainPageVC{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initImageView];
    
}

- (void)initImageView{
    // 预留遮罩层,作为加载页活其他预留功能使用
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:APP_BOUNDS];
    imageview.image = [UIImage imageNamed:@"WVPageImage"];
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    [self.view addSubview:imageview];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(disappearAction) userInfo:nil repeats:NO];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)swip{
    [self disappearAction];
}

- (void)disappearAction{
    [[RootViewController sharedRootVC] ChangeRootVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
