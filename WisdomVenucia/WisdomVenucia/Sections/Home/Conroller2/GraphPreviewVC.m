//
//  GraphPreviewVC.m
//  SuperMusic
//
//  Created by 苏凡 on 16/2/3.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import "GraphPreviewVC.h"
#import "ImgScrollView.h"

@interface GraphPreviewVC ()<ImgScrollViewDelegate,UIScrollViewDelegate>

@end

@implementation GraphPreviewVC{
    UIScrollView *_myScrollView;
    UILabel      *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}


#pragma mark -- Data
- (void)initData{
    
    
    
}


#pragma mark -- UI
- (void)initUI{
    self.view.backgroundColor = [UIColor blackColor];
    if (self.type == 1) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:APP_BOUNDS];
        imageView.image = self.images[0];
        [self.view addSubview:imageView];
        
    }else{
        [self initScrollView];
        [self addSubImgView];
    }
    
    
}



- (void)initScrollView{
    _myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    _myScrollView.pagingEnabled = YES;
    _myScrollView.delegate = self;
    CGSize contentSize = _myScrollView.contentSize;
    contentSize.height = self.view.bounds.size.height;
    contentSize.width = SCREEN_WIDTH * self.images.count;
    _myScrollView.contentSize = contentSize;
    _myScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*self.currentIndex, 0);
    [self.view addSubview:_myScrollView];
}

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView;
{
//    for (UIView *tmpView in myScrollView.subviews)
//    {
//        [tmpView removeFromSuperview];
//    }
    UIImage *img = self.images[0];
    CGFloat p = img.size.height/img.size.width;
    CGRect convertRect = VIEWFRAME(0, (SCREEN_HIGHT-p*SCREEN_WIDTH)/2, SCREEN_WIDTH, p*SCREEN_WIDTH);
    CGFloat h = (SCREEN_HIGHT+p*SCREEN_WIDTH)/2 + 50;
    _label = [UILabel createLabelWithFrame:VIEWFRAME(0, h, SCREEN_WIDTH, 30)
                                   andText:[NSString stringWithFormat:@"%li/%li",self.currentIndex+1,self.images.count]
                              andTextColor:[UIColor whiteColor]
                                andBgColor:[UIColor clearColor]
                                   andFont:SYSTEMFONT(16)
                          andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_label];
    for (int i = 0; i < self.images.count; i ++)   
    {
//        if (i == currentIndex)
//        {
//            continue;
//        }
//        
        //转换后的rect
        UIImage *image = self.images[i];
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*_myScrollView.bounds.size.width,0,_myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:image];
        [_myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    self.currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _label.text = [NSString stringWithFormat:@"%li/%li",self.currentIndex+1,self.images.count];
    
}

- (void)tapImageViewTappedWithObject:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc{
    NSLog(@"delloc ::  previewVC");
}

@end
