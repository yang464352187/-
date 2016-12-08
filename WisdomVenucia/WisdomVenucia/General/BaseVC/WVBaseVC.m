//
//  WVBaseVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "WVBaseVC.h"

@interface WVBaseVC ()<UIGestureRecognizerDelegate>

@end

@implementation WVBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:APP_BOUNDS];
    imageview.image = [UIImage imageNamed:@"LeftBackground"];
    [self.view addSubview:imageview];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)setSecLeftNavigation{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationLeftBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(barbuttonAction)];
    
    self.navigationItem.leftBarButtonItem = bar;
    
}

- (void)barbuttonAction{
    [self popGoBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
