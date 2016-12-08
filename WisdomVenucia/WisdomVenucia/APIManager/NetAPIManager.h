//
//  NetAPIManager.h
//  PaperSource
//
//  Created by Yhoon on 15/10/16.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetAPIManager : NSObject

+ (instancetype)sharedManager;

// 通用接口
- (void)request_common_WithPath:(NSString *)aPath Params:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock;

// 登录请求接口
- (void)request_Login_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock;

// 注册请求接口
- (void)request_Register_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock;

//创建位置共享
- (void)request_CreateLocationShared_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock;

//创建联系人
- (void)request_CreateContact_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock;

//修改个人信息
- (void)request_ModifyUserInfo_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock ;

//上传头像
- (void)request_UploadHeadImage_WithImage:(UIImage *)image Params:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock progerssBlock:(void (^)(CGFloat progressValue))progress;

//车辆信息设置
- (void)request_SetCar_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock;




@end
