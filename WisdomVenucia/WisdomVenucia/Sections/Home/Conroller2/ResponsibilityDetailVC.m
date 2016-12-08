//
//  ResponsibilityDetailVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/15.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "ResponsibilityDetailVC.h"

@interface ResponsibilityDetailVC ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *respon;
@property (strong, nonatomic) UIImageView *imageview;

@end

@implementation ResponsibilityDetailVC


#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.imageview];
    [self.view addSubview:self.label];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.respon];
    _weekSelf(weakSelf);
//    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.view);
//        make.top.equalTo(weakSelf.view.mas_top).offset(40);
//        make.size.mas_equalTo(CGSizeMake(_imageview.image.size.width, _imageview.image.size.height));
//        
//    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageview.mas_bottom).offset(SCREEN_HIGHT==480?20:50);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.height.offset(20);
    }];
    [self.respon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.offset(20);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_respon.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
    }];
    
    
    
    
    
}



#pragma mark -- Data
- (void)initData{
    self.title = self.notificationDict[@"title"];
    
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
    
}

#pragma mark -- event response





#pragma mark -- getters and setters

- (UIImageView *)imageview{
    if (!_imageview) {
        UIImage *image = [UIImage imageNamed:self.notificationDict[@"image"]];
        CGFloat h = (SCREEN_WIDTH-40)*image.size.height/image.size.width;
        _imageview = [[UIImageView alloc] initWithFrame:VIEWFRAME(20, 64+40, SCREEN_WIDTH-40, h)];
        _imageview.image = image;
    }
    return _imageview;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel createLabelWithFrame:VIEWFRAME(10, 10, 10, 10)
                                            andText:[NSString stringWithFormat:@"%@:",self.title]
                                       andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:SYSTEMFONT(16)
                                   andTextAlignment:NSTextAlignmentLeft];
        
    }
    return _titleLabel;
}

- (UILabel *)respon{
    if (!_respon) {
        _respon = [UILabel createLabelWithFrame:VIEWFRAME(10, 10, 10, 10)
                                        andText:@"A车全责"
                                   andTextColor:[UIColor whiteColor]
                                     andBgColor:[UIColor clearColor]
                                        andFont:SYSTEMFONT(16)
                               andTextAlignment:NSTextAlignmentLeft];
    }
    return _respon;
}

- (UILabel *)label{
    if (!_label) {
        _label = [UILabel createLabelWithFrame:VIEWFRAME(10, 10, 10, 10)
                                       andText:self.notificationDict[@"string"]
                                  andTextColor:[UIColor whiteColor]
                                    andBgColor:[UIColor clearColor]
                                       andFont:SYSTEMFONT(16)
                              andTextAlignment:NSTextAlignmentLeft];
        _label.numberOfLines = 0;
        _label.lineBreakMode = NSLineBreakByTruncatingHead;
    }
    return _label;
}



@end
