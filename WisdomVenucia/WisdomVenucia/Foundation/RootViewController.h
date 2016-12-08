//
//  RootViewController.h
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/17.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageVC.h"

@interface RootViewController : UIViewController

@property (nonatomic, strong) MainPageVC *mainPageVC; // 遮罩层VC

+(instancetype)sharedRootVC;

- (void)ChangeRootVC;

@end
