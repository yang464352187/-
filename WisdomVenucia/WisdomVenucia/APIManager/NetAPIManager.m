//
//  NetAPIManager.m
//  PaperSource
//
//  Created by Yhoon on 15/10/16.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "NetAPIManager.h"
#import "NetAPIClient.h"



@implementation NetAPIManager

+ (instancetype)sharedManager {
    static NetAPIManager *sharedManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

// 通用接口
- (void)request_common_WithPath:(NSString *)aPath Params:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock {
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:aPath withParams:params withMethodType:NetworkType_Post success:^(id data) {
        successBlock(data);
    } failure:^(id data, NSError *error) {
        failueBlock(data,error);
    }];
}

#pragma mark - Login
- (void)request_Login_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock {
    NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    NSString *pathString = APPINTERFACE_Login;
    
    DebugLog(@"%@",describe(requestDict));
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        UserModel *curLoginUser = [MTLJSONAdapter modelOfClass:[UserModel class]
                                            fromJSONDictionary:requestDict
                                                         error:nil];
        if (curLoginUser) {
            [LoginModel doLogin:data];
        }
        successBlock(curLoginUser);
    } failure:^(id data, NSError *error) {
        failueBlock(nil,error);
    }];
}

#pragma mark - UserInfo
- (void)request_UserInfo {
    
    
}

#pragma mark - Register
- (void)request_Register_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock {
    NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    NSString *pathString = APPINTERFACE_Register;
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        UserModel *curLoginUser = [MTLJSONAdapter modelOfClass:[UserModel class]
                                            fromJSONDictionary:requestDict
                                                         error:nil];
        if (curLoginUser) {
            [LoginModel doLogin:data];
        }
        successBlock(curLoginUser);
    } failure:^(id data, NSError *error) {
        failueBlock(nil,error);
    }];
}

#pragma mark - CreateLocationShared
- (void)request_CreateLocationShared_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock{
    NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    
    NSString *pathString      = APPINTERFACE_CreateLocationShared;
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        successBlock(data);
    } failure:^(id data, NSError *error) {
        failureBlock(nil,error);
    }];

}

#pragma mark - CrateContact
- (void)request_CreateContact_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock{
    NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    NSString *pathString      = APPINTERFACE_CreateContact;
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        successBlock(data);
    } failure:^(id data, NSError *error) {
        failureBlock(nil,error);
    }];

}

#pragma mark - ModifyUserInfo
- (void)request_ModifyUserInfo_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock {
    NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:params error:nil];
    NSString *pathString = APPINTERFACE__ModifyUserInfo;
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        DEFAULTS_SET_OBJ(requestDict, mLOGINUSERINFO);
        DEFAULTS_SAVE;
        successBlock(data);
    } failure:^(id data, NSError *error) {
        failueBlock(nil,error);
    }];
    
}

#pragma mark -- upload Image
- (void)request_UploadHeadImage_WithImage:(UIImage *)image Params:(id)params succesBlack:(void (^)(id data))successBlock failue:(void (^)(id data,NSError *error))failueBlock progerssBlock:(void (^)(CGFloat progressValue))progress{
    NSString *pathString = APPINTERFACE__SetAvatar;
    
    [[NetAPIClient shareNetAPIClient] uploadImage:image path:pathString params:params successBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        failueBlock(nil,error);
    } progerssBlock:^(CGFloat progressValue) {
        progress(progressValue);
    }];
}

#pragma mark -- 车辆信息设置
- (void)request_SetCar_WithParams:(id)params succesBlack:(void (^)(id data))successBlock failure:(void (^)(id data, NSError *error))failureBlock{

    
    NSMutableDictionary *requestDict = [[MTLJSONAdapter JSONDictionaryFromModel:params error:nil] mutableCopy];
    [requestDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == [NSNull null] || ([obj isKindOfClass:[NSString class]] && [obj  isEqualToString:@""])) {
            [requestDict removeObjectForKey:key];
        }
    }];
    NSString *pathString = APPINTERFACE__SetCar;
    
    [[NetAPIClient shareNetAPIClient] requestJsonDataWithPath:pathString withParams:requestDict withMethodType:NetworkType_Post success:^(id data) {
        successBlock(data);
    } failure:^(id data, NSError *error) {
        failureBlock(nil,error);
    }];
}


@end
