//
//  NetAPIClient.m
//  PaperSource
//
//  Created by Yhoon on 15/10/15.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#import "NetAPIClient.h"

@interface NetAPIClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *netManager;

@end

@implementation NetAPIClient

static NetAPIClient *_sharedNetAPIClient = nil;
static dispatch_once_t oncePredicate;

#pragma mark - 初始化
// 单例初始化
+ (instancetype)shareNetAPIClient {
    dispatch_once(&oncePredicate, ^{
        _sharedNetAPIClient = [[NetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:APP_BASEURL]];
    });
    return _sharedNetAPIClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.netManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        self.netManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.netManager.requestSerializer =  [AFJSONRequestSerializer serializer];
        self.netManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    }
    return self;
}

#pragma mark - Interface Node
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(id)params
                 withMethodType:(NetworkType)networkType
                        success:(void (^)(id data))successBlock
                        failure:(void (^)(id data, NSError *error))failureBlock {
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:networkType autoShowError:YES success:successBlock failure:failureBlock];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(id)params
                 withMethodType:(NetworkType)networkType
                  autoShowError:(BOOL)autoShowError
                        success:(void (^)(id data))successBlock
                        failure:(void (^)(id data, NSError *error))failureBlock {
    
    if (!aPath || aPath.length <= 0) {
        return;
    }
    //打印请求数据
    DebugLog(@"\n===========request===========\n%@\n%@:\n%@", kNetworkTypeName[networkType], aPath, params);
    
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    switch ( networkType ) {
        case NetworkType_Get: {
            [self.netManager GET:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [NSObject handleResponse:responseObject autoShowError:autoShowError];
                
                if (error) {
                    failureBlock(nil,error);
                } else {
                    successBlock(responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                failureBlock(nil,error);
            }];
            break;
        }
        case NetworkType_Post: {
            [self.netManager POST:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, describe(responseObject));
                
                id error = [NSObject handleResponse:responseObject autoShowError:autoShowError];
                
                if (error) {
                    failureBlock(nil,error);
                } else {
                    successBlock(responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                NSLog(@"response : %@",operation.responseString);
                [NSObject showError:error];
//                NSString *str = @"{\"code\":1}";
//                NSRange range = [operation.responseString rangeOfString:str];
//                
//                if (range.location != NSNotFound) {
//                    NSLog(@"进入短信接口");
//                    NSDictionary *responseObject = @{@"code":@(1)};
//                    [MBProgressHUD showHudTipStr:@"短信发送成功"];
//                    successBlock(responseObject);
//                }else{
//                    NSLog(@"其他错误接口");
//                    
//                }
                failureBlock(nil,error);
            }];
            break;
        }
        default: {
            break;
        }
    }
}
- (void)uploadImage:(UIImage *)image
               path:(NSString *)aPath
             params:(NSDictionary *)params
       successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
       failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress {
    DebugLog(@"\n===========request===========\n%@:\n%@", aPath, params);
    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if ((float)imageData.length/1024 > 1000) {
        imageData = UIImageJPEGRepresentation(image, 1024*1000.0/(float)imageData.length);
    }
    
    AFHTTPRequestOperation *operation = [self.netManager POST:aPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"\n===========response===========\n%@: \n%@ \n%@", aPath, operation.responseString,describe(responseObject));
        
        id error = [self handleResponse:responseObject];
        if (error && failure) {
            failure(operation, error);
        }else{
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"\n===========response===========\n%@: \n%@ \n%@", aPath, operation.responseString,error);
        if (failure) {
            [NSObject showError:error];
            failure(operation, error);
        }
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat progressValue = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
        if (progress) {
            progress(progressValue);
            //DebugLog(@"\n===========response===========\n%f",progressValue);
        }
    }];
    [operation start];
}
@end
