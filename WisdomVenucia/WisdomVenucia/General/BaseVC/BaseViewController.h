//
//  BaseViewController.h
//  PaperSource
//
//  Created by Yhoon on 15/10/13.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoBackBlock)(void);// 返回Block
typedef void (^NavRightItemButtonBlock)(id obj);

@interface BaseViewController : UIViewController

// 广播使用字典,用来传值
@property (copy, nonatomic) NSDictionary *notificationDict;

/**
 *  当前登录用户数据模型,如果未登录为nil
 */
@property (nonatomic, strong) UserModel *currentLoginUser;

/**
 *  发送页面跳转通知,在继承的子类中使用
 *
 *  @param aName     跳转通知类型
 *  @param className 跳转到的目标控制器名称
 *  @param anObject  通知携带传递的对象,可为空
 *  @param info      通知携带传递的数据,字典或者数组或者是其他数据对象格式
 */
- (void)postViewControllerJumpNotificationByTypeName:(NSString *)aName className:(NSString *)className object:(id)anObject info:(id)info;

// 设置根据图片设置NavignonItem按钮
- (void)setRightNavigationItemWithImage:(UIImage *)image selectBlock:(NavRightItemButtonBlock)selectBlock;
- (void)setLeftNavigationItemWithImage:(UIImage *)image selectBlock:(GoBackBlock)selectBlock;

/*页面返回方式*/
- (void)popGoBack;     // pop
- (void)dismissGoback; // dismiss

// 弹出LoginVC
- (void)presentLoginViewConroller;
@end
