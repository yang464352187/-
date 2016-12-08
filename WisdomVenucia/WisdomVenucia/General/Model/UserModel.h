//
//  UserModel.h
//  PaperSource
//
//  Created by Yhoon on 15/10/26.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, copy) NSNumber *uid;               //用户id

+ (UserModel *)readCurLoginUser;        // 读取当前登录用户信息
+ (void)writeUser:(UserModel *)user;    // 将用户数据写入系统本地数据库



@end
