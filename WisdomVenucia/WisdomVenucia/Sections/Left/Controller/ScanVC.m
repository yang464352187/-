//
//  ScanVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/1.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "ScanVC.h"
#import <AVFoundation/AVFoundation.h>

static const CGFloat kBorderW = 60;
static const CGFloat kMargin = 50;

@interface ScanVC () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, weak  ) UIView           *maskView;

@property (strong, nonatomic) NSString         *notificationName;//扫码到之后推送的名字

@end

@implementation ScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    [self initData];
    [self initUI];
}


- (void)initData{
    self.notificationName = self.notificationDict[@"name"];
}

- (void)initUI{
    [self setSecLeftNavigation];
    
    [self setupScanWindowView];
    
    [self beginScanning];
}

- (void)setupScanWindowView
{
    CGFloat scanWindowW = SCREEN_WIDTH - kMargin * 2;
    CGFloat scanWindowH = scanWindowW;
    UIView *scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, (SCREEN_HIGHT-scanWindowH)/2, scanWindowW, scanWindowH)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    CGFloat scanNetImageViewH = 241;
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath = @"transform.translation.y";
    scanNetAnimation.byValue = @(scanWindowH);
    scanNetAnimation.duration = 2.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    CGFloat buttonWH = 18;
    
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.frame.origin.x, bottomLeft.frame.origin.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [scanWindow addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:metadataObject.stringValue];
        [self popGoBack];
    }
}

- (void)disMiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        self.navigationController.navigationBar.hidden = NO;
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self disMiss];
    } else if (buttonIndex == 1) {
        [_session startRunning];
    }
}

- (void)setSecLeftNavigation{
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationLeftBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(barbuttonAction)];
    self.navigationItem.leftBarButtonItem = bar;
}

- (void)barbuttonAction{
    [self popGoBack];
}

//- (void)viewWillDisAppear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = APP_COLOR_BASE_BAR;
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
