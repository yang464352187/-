//
//  HTMLVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/17.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "HTMLVC.h"

@interface HTMLVC ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation HTMLVC



#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
    self.title = @"车联智慧协议";
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.webView];
}



#pragma mark -- Data
- (void)initData{
    

    
}

#pragma mark -- UI
- (void)initUI{

    [self setSecLeftNavigation];
}

#pragma mark -- event response





#pragma mark -- getters and setters

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"smart" ofType:@"html"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [_webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];
        
//        NSString *str = @"<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t职业培训师\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t国内演讲口才领域实战型专家\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t福建省演讲与口才协会副秘书长、专家团成员\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t福建省培训师协会常务理事\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t第四．五、六届世界华语辩论赛福建赛区主评委\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t盛世龙腾口才教育机构执行董事、特级培训师\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t《高级演讲口才实战班》主讲导师\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t《实战培训师培训班（TST）》主讲导师\r\n</p>\r\n<p class=\"MsoNormal\" style=\"margin-left:0.0000pt;\">\r\n\t多家大型企业培训总监、培训咨询顾问 \r\n</p>" ;
//        
//        NSString *str2 = @"<p>\r\n\t阿斯顿发送到发送到发送到发生阿士大夫撒打算的发生的，已经修改了\r\n</p>\r\n<p>\r\n\t<img src=\"http://ycapp.oudewa.cn/Uploads/2016-03-10/56e0d8f2f2bfa.jpg\" alt=\"\" /><img src=\"http://ycapp.oudewa.cn/Uploads/2016-03-10/56e0d8ffa8ab8.jpg\" alt=\"\" />\r\n</p>\r\n<p>\r\n\t<br />\r\n</p>\r\n<p>\r\n\t<br />\r\n</p>";
//        [_webView loadHTMLString:str2 baseURL:nil];
        
    }
    
    return _webView;
}



@end
