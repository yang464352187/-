//
//  FieldView.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "FieldView.h"

static NSString * const identifier = @"FieldCell";
static NSString * const NumAndLetter = @"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

@interface FieldView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton    *More;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView      *backgroundView;

@end

@implementation FieldView



- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image Placeholder:(NSString *)placeholder{
    if (self = [super initWithFrame:frame]) {
  
        ViewBorderRadius(self, frame.size.height/2, 1, [UIColor whiteColor]);
        self.backgroundColor = [UIColor whiteColor];
        
        //图标
        UIImageView *userImage = [[UIImageView alloc] initWithFrame:VIEWFRAME(10, (frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        userImage.image = image;
        userImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //分割线
        UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(image.size.width+17, 2, 1, frame.size.height-4)];
        cut.backgroundColor = HEXCOLOR(0x999999);
        //输入框
        self.textField = [[UITextField alloc] initWithFrame:VIEWFRAME(image.size.width+25, 5, frame.size.width-image.size.width-40, frame.size.height-10)];
        self.textField.delegate    = self;
        self.textField.placeholder = placeholder;
        self.textField.font        = SYSTEMFONT(14);
        [self.textField setValue:HEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:userImage];
        [self addSubview:cut];
        [self addSubview:self.textField];
        
    }
    return self;
}


//图片在右边
- (instancetype)initWithFrame:(CGRect)frame RightImage:(UIImage *)image Placeholder:(NSString *)placeholder{
    if (self = [super initWithFrame:frame]) {
        ViewBorderRadius(self, frame.size.height/2, 1, [UIColor whiteColor]);
        self.backgroundColor = [UIColor whiteColor];
        
        
        //图标
        UIButton *userImage = [[UIButton alloc] initWithFrame:VIEWFRAME(frame.size.width-frame.size.height/2-image.size.width, (frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
        [userImage addTarget:self action:@selector(ScanClick) forControlEvents:UIControlEventTouchUpInside];
        [userImage setImage:image forState:UIControlStateNormal];
        userImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
        //userImage.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //输入框
        self.textField = [[UITextField alloc] initWithFrame:VIEWFRAME(30, 5, frame.size.width-image.size.width-60, frame.size.height-10)];
        self.textField.placeholder = placeholder;
        self.textField.font        = SYSTEMFONT(13);
        [self.textField setValue:HEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:userImage];
        [self addSubview:self.textField];
        
    }
    
    return self;
}

//圆角矩形
- (instancetype)initRectWithFrame:(CGRect)frame RightImage:(UIImage *)image Placeholder:(NSString *)placeholder MoreButton:(BOOL)ismore{
    if (self = [super initWithFrame:frame]) {
        ViewBorderRadius(self, 7, 1, [UIColor whiteColor]);
        self.backgroundColor = [UIColor whiteColor];
        
        if (image) {
            //图标
            UIButton *userImage = [[UIButton alloc] initWithFrame:VIEWFRAME(frame.size.width-image.size.width-10, (frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
            [userImage addTarget:self action:@selector(ScanClick) forControlEvents:UIControlEventTouchUpInside];
            [userImage setImage:image forState:UIControlStateNormal];
            userImage.transform = CGAffineTransformMakeScale(0.9, 0.9);
            [self addSubview:userImage];
        }
        //输入框
        self.textField = [[UITextField alloc] initWithFrame:VIEWFRAME(10, 5, frame.size.width-image.size.width-20, frame.size.height-10)];
        self.textField.placeholder = placeholder;
        self.textField.font        = SYSTEMFONT(14);
        [self.textField setValue:HEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:self.textField];
        
        if(ismore){
//            UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(self.frame.size.width-self.frame.size.height/2-12, (self.frame.size.height-13)/2+2, 23, 13)];
//            [button setImage:[UIImage imageNamed:@"LoginMoreUser"] forState:UIControlStateNormal];
//            button.transform = CGAffineTransformMakeScale(0.9, 0.9);
//            [button addTarget:self action:@selector(MoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            [self initTableView];
//            [self addSubview:button];
            [self setMoreButton];
        }
    }
    
    return self;
}

#pragma  mark --设置下拉按钮
- (void)setMoreButton{
    
//    UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(self.frame.size.width-self.frame.size.height/2-18, (self.frame.size.height-13)/2+2, 23, 13)];
//    [button setImage:[UIImage imageNamed:@"LoginMoreUser"] forState:UIControlStateNormal];
//    button.transform = CGAffineTransformMakeScale(0.9, 0.9);
//    [button addTarget:self action:@selector(MoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [[UIButton alloc] initWithFrame:VIEWFRAME(0, 0, 30, self.textField.frame.size.height)];
    [button setImage:[UIImage imageNamed:@"LoginMoreUser"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(MoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.textField.rightView = button;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    [self initTableView];
    [self addSubview:button];
    
}

#pragma  mark -- 按钮点击
- (void)fieldViewbuttonClick:(FieldView *)fieldView{
    
}

- (void)setViewController:(UIViewController *)viewController{
    _viewController = viewController;
    
}

#pragma  mark -- 设置是否为密码模式
- (void)setTextFielWithSecureTextEntry{
    self.textField.secureTextEntry = YES;
}

#pragma  mark -- 获取输入框的值
- (NSString *)getText{
    return self.textField.text;
}

#pragma  mark -- 设置输入框的值
- (void)setText:(NSString *)test{
    self.textField.text = test;
}
#pragma  mark - 设置键盘
- (void)setKeyboard:(UIKeyboardType)type{
    self.textField.keyboardType = type;
}

#pragma  mark -- 下拉按钮点击  初始化tableview

- (void)initTableView{
    NSInteger h = 44*self.listData.count >= 300? 300 :  44*self.listData.count;
    
    CGRect frame = VIEWFRAME(self.textField.frame.origin.x, self.frame.origin.y+40,self.textField.frame.size.width-20 , h);
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
    //背景
    self.backgroundView = [[UIView alloc] initWithFrame:APP_BOUNDS];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapGestureAction)];
    [tap setNumberOfTouchesRequired:1];
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)TapGestureAction{
    [self.backgroundView removeFromSuperview];
    [self.tableView removeFromSuperview];
}

- (void)MoreButtonClick{
    if (self.tableView.superview) {
        [self.backgroundView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }else{
        if (self.listData.count == 0) {
            return;
        }
        if (self.viewController) {
            
            CGRect start = [self.textField convertRect:self.textField.frame toView:self.viewController.view];
            NSLog(@"frmae : %@",NSStringFromCGRect(start));
            CGFloat limit = SCREEN_HIGHT - start.origin.y - 80;
            NSInteger h = 44*self.listData.count >= limit? limit :  44*self.listData.count;

            self.tableView.frame = VIEWFRAME(start.origin.x - 20, start.origin.y+35, start.size.width, h);
            
            [self.viewController.view addSubview:self.backgroundView];
            [self.viewController.view addSubview:self.tableView];
        }else{
            UIView *view = [self superview];
            [view addSubview:self.backgroundView];
            [view addSubview:self.tableView];
        }
    }
    
}

#pragma mark - tableview dataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.backgroundView removeFromSuperview];
    [self.tableView removeFromSuperview];
    self.textField.text = self.listData[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(MoreButtonClick:)]) {
        [self.delegate MoreButtonClick:self.listData[indexPath.row]];
    }
    
}

- (void)reloadTableView{
    [self.tableView reloadData];
}

- (void)setListData:(NSArray *)listData{
    _listData = listData;
    NSInteger h = 44 * self.listData.count >= 300? 300 :  44 * self.listData.count;
    self.tableView.frame = VIEWFRAME(self.textField.frame.origin.x+45, self.frame.origin.y+40,self.textField.frame.size.width , h);
}

#pragma mark -- 扫码动作
- (void)ScanClick{
    if ([self.delegate respondsToSelector:@selector(ScanButtonClick:)]) {
        [self.delegate ScanButtonClick:self];
    }
}


#pragma mark -- field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([self.delegate respondsToSelector:@selector(changeString)]) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NumAndLetter] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else{
        return YES;
    }
}

@end
