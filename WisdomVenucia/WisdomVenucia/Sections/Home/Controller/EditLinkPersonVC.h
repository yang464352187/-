//
//  EditLinkPersonVC.h
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/11/25.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "WVBaseVC.h"
#import "CreateLocationSharedVC.h"
#import "RQCreateLocationSharedModel.h"
#import "RPContactModel.h"


@interface EditLinkPersonVC : WVBaseVC

@property (nonatomic, copy) void(^checkBlock)(ContactInfo *contact); // 把创建的联系人回调回去

@property (nonatomic, copy) void(^reGetContactBlock)(void); // 重新获取联系人列表回调

@property (nonatomic, strong) ContactInfo *contactInfo; //修改联系人时

@end
