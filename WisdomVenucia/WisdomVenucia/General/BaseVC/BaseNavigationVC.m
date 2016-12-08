//
//  BaseNavigationVC.m
//  PaperSource
//
//  Created by Yhoon on 15/10/19.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "BaseNavigationVC.h"

@interface BaseNavigationVC ()

@end

@implementation BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor    = [UIColor whiteColor];// 修改的是文字HEXCOLOR(0x3f51b5)
    self.navigationBar.barTintColor = APP_COLOR_BASE_BAR;
    
    // 修改NavigationBar中title字体和颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                   NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
