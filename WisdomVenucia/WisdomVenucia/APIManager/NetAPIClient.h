//
//  NetAPIClient.h
//  PaperSource
//
//  Created by Yhoon on 15/10/15.
//  Copyright © 2015年 yhoon. All rights reserved.
//
#define kNetworkTypeName @[@"Get", @"Post"]

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

// 网络请求类型
typedef NS_ENUM(NSInteger,NetworkType) {
    NetworkType_Get = 0,       // GET请求
    NetworkType_Post,          // POST请求
};

@interface NetAPIClient : NSObject

// 单例模式
+ (instancetype)shareNetAPIClient;

/**
 *  带自动提示error的请求接口
 *
 *  @param aPath        请求路径
 *  @param params       入参字典
 *  @param networkType  请求类型
 *  @param successBlock 成功回调Block
 *  @param failureBlock 失败回调Block
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(id)params
                 withMethodType:(NetworkType)networkType
                        success:(void (^)(id data))successBlock
                        failure:(void (^)(id data, NSError *error))failureBlock;

/**
 *  网络请求接口
 *
 *  @param aPath         请求路径
 *  @param params        入参字典
 *  @param networkType   请求类型
 *  @param autoShowError 是否自动弹窗提示error
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(id)params
                 withMethodType:(NetworkType)networkType
                  autoShowError:(BOOL)autoShowError
                        success:(void (^)(id data))successBlock
                        failure:(void (^)(id data, NSError *error))failureBlock;



/**
 *  网络请求接口－－图片上传
 *
 *  @param uploadImage   上传的图片
 *  @param params        入参字典
 *  @param aPath         请求路径
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *  @param progerssBlock 进度条
 */

- (void)uploadImage:(UIImage *)image
               path:(NSString *)aPath
             params:(NSDictionary *)params
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

@end
