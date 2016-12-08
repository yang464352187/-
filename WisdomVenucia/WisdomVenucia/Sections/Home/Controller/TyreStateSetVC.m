//
//  TyreStateSetVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/19.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "TyreStateSetVC.h"
#import "SliderView.h"

#define kTyreLabelFont [UIFont systemFontOfSize:14]
#define kTyreSetData   @"kTyreSetData"


@interface TyreStateSetVC ()

@property (weak, nonatomic  ) UIButton   *TyreButton_Sel;
@property (weak, nonatomic  ) UIButton   *Temperature_Sel;
@property (weak, nonatomic  ) UIButton   *Pressure_Sel;
@property (strong, nonatomic) UIButton   *Temperature_SSD;
@property (strong, nonatomic) UIButton   *Temperature_HSD;
@property (strong, nonatomic) UIButton   *Pressure_PSI;
@property (strong, nonatomic) UIButton   *Pressure_KPA;
@property (strong, nonatomic) UIButton   *Pressure_BAR;

@property (strong, nonatomic) SliderView *Slider_Left;
@property (strong, nonatomic) SliderView *Slider_Right;
@property (strong, nonatomic) SliderView *Slider_Bottom;

@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSDictionary   *basicData;

@end

@implementation TyreStateSetVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self setData];
    self.title = @"胎压设定";
}

#pragma mark -- Data
- (void)initData{
    
    self.basicData = @{
                       @"Temperature"  :@(0),
                       @"Pressure"     :@(3),
                       @"Slider_Left"  :@(0.364),
                       @"Slider_Right" :@(0.143),
                       @"Slider_Bottom":@(1.00)
                       };
    NSArray *array =  DEFAULTS_GET_OBJ(kTyreSetData);
    self.listData = [NSMutableArray arrayWithArray:array];
    
    if (self.listData.count == 0) {
        for (int i = 0; i<4; i++) {
            NSDictionary *dic = [self.basicData copy];
            [self.listData addObject:dic];
        }
    }
    
}

- (void)setData{
    NSDictionary *dic = self.listData[0];
    [self HandlData:dic];

}

#pragma mark -- UI
- (void)initUI{
    [self initButtonAndLabel];
    [self initSliderAndLabel];
    
    [self setLeftNavigation];
}


#pragma mark -- 创建标签 和选中按钮
- (void)initButtonAndLabel{
    CGFloat w = (SCREEN_WIDTH - 80)/4;
    CGFloat s = (SCREEN_WIDTH-w)/3;
    NSArray *titleList = @[@"前轮  ",@"后轮  ",@"右后轮"];
    for (int i = 0; i < 2; i++) {
        CGRect frame = VIEWFRAME((i+1)*s, 64+15, w, 15);
        UIButton *button = [self CreateButtonWithTitle:titleList[i] Frame:frame];
        button.tag = 1301 + i;
        [button addTarget:self action:@selector(TyreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i == 0) {
            [button setSelected:YES];
            _TyreButton_Sel = button;
        }
    }
    
    
    UILabel *label1 = [UILabel createLabelWithFrame:VIEWFRAME(20, 64+45, 100, 15)
                                            andText:@"单位设定" andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:kTyreLabelFont
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label1];
    
    //温度单位设定 button
    UILabel *label2 = [UILabel createLabelWithFrame:VIEWFRAME(20, 64+80, 100, 15)
                                            andText:@"温度单位设定" andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:kTyreLabelFont
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label2];
    
    CGRect frame           = VIEWFRAME(SCREEN_WIDTH/2-20, 64+80, 40, 15);
    UIButton *Temperature1 = [self CreateButtonWithTitle:@"°C" Frame:frame];
    Temperature1.tag       = 1305;
    [Temperature1 setSelected:YES];
    _Temperature_Sel       = Temperature1;
    self.Temperature_SSD   = Temperature1;
    [Temperature1 addTarget:self action:@selector(TemperatureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Temperature1];

    
    frame.origin.x = SCREEN_WIDTH/2+40;
    UIButton *Temperature2 = [self CreateButtonWithTitle:@"°F" Frame:frame];
    Temperature2.tag       = 1306;
    self.Temperature_HSD   = Temperature2;
    [Temperature2 addTarget:self action:@selector(TemperatureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Temperature2];
    
    //压力单位设定
    UILabel *label3 = [UILabel createLabelWithFrame:VIEWFRAME(20, 64+115, 100, 15)
                                            andText:@"压力单位设定" andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:kTyreLabelFont
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label3];
    
    frame= VIEWFRAME(SCREEN_WIDTH/2-20, 64+115, 50, 15);
    UIButton *Pressure1 = [self CreateButtonWithTitle:@"psi" Frame:frame];
    Pressure1.tag       = 1307;
    [Pressure1 setSelected:YES];
    _Pressure_Sel       = Pressure1;
    self.Pressure_PSI   = Pressure1;
    
    [Pressure1 addTarget:self action:@selector(PressureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Pressure1];
    
    frame.origin.x += 60;
    UIButton *Pressure2 = [self CreateButtonWithTitle:@"kPa" Frame:frame];
    Pressure2.tag       = 1308;
    self.Pressure_KPA   = Pressure2;
    [Pressure2 addTarget:self action:@selector(PressureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Pressure2];
    
    frame.origin.x += 60;
    UIButton *Pressure3 = [self CreateButtonWithTitle:@"Bar" Frame:frame];
    Pressure3.tag       = 1309;
    self.Pressure_BAR   = Pressure3;
    [Pressure3 addTarget:self action:@selector(PressureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Pressure3];
    
    //
    UILabel *label4 = [UILabel createLabelWithFrame:VIEWFRAME(20, 64+150, 100, 15)
                                            andText:@"系统警示设定" andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:kTyreLabelFont
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label4];
    
    UILabel *label5 = [UILabel createLabelWithFrame:VIEWFRAME(20, 64+185, 140, 15)
                                            andText:@"胎压监测范围设定" andTextColor:[UIColor whiteColor]
                                         andBgColor:[UIColor clearColor]
                                            andFont:kTyreLabelFont
                                   andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:label5];
    
}

#pragma mark -- 创建滑动控件
- (void)initSliderAndLabel{
    CGFloat w = (SCREEN_WIDTH-70)/2;
    
    //
    self.Slider_Left = [[SliderView alloc] initWithFrame:VIEWFRAME(20,64+210, w, 55)];
    self.Slider_Left.valueDic = @{@"psimin":@(20),
                                  @"psimax":@(36),
                                  @"kpamin":@(140),
                                  @"kpamax":@(250),
                                  @"barmin":@(1.4),
                                  @"barmax":@(2.5)
                                  };
    self.Slider_Left.sliderType = SliderTypePSI;
    
    self.Slider_Right = [[SliderView alloc] initWithFrame:VIEWFRAME(50+w,64+210, w, 55)];
    self.Slider_Right.valueDic = @{@"psimin":@(41),
                                   @"psimax":@(61),
                                   @"kpamin":@(280),
                                   @"kpamax":@(420),
                                   @"barmin":@(2.8),
                                   @"barmax":@(4.2)
                                   };
    self.Slider_Right.sliderType = SliderTypePSI;
    
    self.Slider_Bottom = [[SliderView alloc] initWithFrame:VIEWFRAME(20,64+280, w, 55)];
    self.Slider_Bottom.valueDic = @{@"ssdmin":@(60),
                                    @"ssdmax":@(80),
                                    @"hsdmin":@(140),
                                    @"hsdmax":@(180)
                                    };
    self.Slider_Bottom.sliderType = SliderTypeSSD;
    
    [self.view addSubview:self.Slider_Right];
    [self.view addSubview:self.Slider_Bottom];
    [self.view addSubview:self.Slider_Left];
    
    //保存
    UIButton *save = [[UIButton alloc] initWithFrame:VIEWFRAME(20, 64+360, w, 40)];
    save.tag = 1320;
    save.titleLabel.font = kTyreLabelFont;
    ViewRadius(save, 8);
    [save setTitle:@"保存" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [save setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateHighlighted];
    [save addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //恢复原产值
    UIButton *resume = [[UIButton alloc] initWithFrame:VIEWFRAME(50+w, 64+360, w, 40)];
    resume.tag = 1321;
    resume.titleLabel.font = kTyreLabelFont;
    ViewRadius(resume, 8);
    [resume setTitle:@"原产设定值" forState:UIControlStateNormal];
    [resume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resume setBackgroundImage:[UIImage imageNamed:@"WVButtonImg"] forState:UIControlStateNormal];
    [resume setBackgroundImage:[UIImage imageNamed:@"WVButtonImg_Sel"] forState:UIControlStateHighlighted];
    [resume addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:save];
    [self.view addSubview:resume];
}


#pragma mark -- 轮胎位置按钮点击
- (void)TyreButtonClick:(UIButton *)sender{
    if (!sender.isSelected) {
        [_TyreButton_Sel setSelected:NO];
        [sender setSelected:YES];
        _TyreButton_Sel = sender;
        switch (sender.tag) {
            case 1301:{
                //左前轮
                NSDictionary *dic = self.listData[0];
                [self HandlData:dic];
                break;
            }
            case 1302:{
                //右前轮
                NSDictionary *dic = self.listData[1];
                [self HandlData:dic];
                break;
            }
            case 1303:{
                //左后轮
                NSDictionary *dic = self.listData[2];
                [self HandlData:dic];
                break;
            }
            case 1304:{
                //右后轮
                NSDictionary *dic = self.listData[3];
                [self HandlData:dic];
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark -- 温度设置按钮点击
- (void)TemperatureButtonClick:(UIButton *)sender{
    if (!sender.isSelected) {
        [_Temperature_Sel setSelected:NO];
        [sender setSelected:YES];
        _Temperature_Sel = sender;
        if (sender.tag == 1305) {
            //摄氏度
            self.Slider_Bottom.sliderType = SliderTypeSSD;
        }else{
            //华氏度
            self.Slider_Bottom.sliderType = SliderTypeHSD;
        }
    }
}

#pragma mark -- 压力设置按钮点击
- (void)PressureButtonClick:(UIButton *)sender{
    if (!sender.isSelected) {
        [_Pressure_Sel setSelected:NO];
        [sender setSelected:YES];
        _Pressure_Sel = sender;
        if (sender.tag == 1307) {
            //psi
            self.Slider_Left.sliderType = SliderTypePSI;
            self.Slider_Right.sliderType = SliderTypePSI;
        }else if(sender.tag == 1308){
            //kpa
            self.Slider_Left.sliderType = SliderTypeKPA;
            self.Slider_Right.sliderType = SliderTypeKPA;
        }else{
            //Bar
            self.Slider_Left.sliderType = SliderTypeBAR;
            self.Slider_Right.sliderType = SliderTypeBAR;
        }
    }
}


#pragma mark -- 保存和恢复原产动作
- (void)ButtonClick:(UIButton *)sender{
    if (sender.tag == 1320) {
        //保存
        NSDictionary *dic = @{
                              @"Temperature"  :@(_Temperature_Sel.tag-1305),
                              @"Pressure"     :@(_Pressure_Sel.tag-1305),
                              @"Slider_Left"  :@(self.Slider_Left.slier.value),
                              @"Slider_Right" :@(self.Slider_Right.slier.value),
                              @"Slider_Bottom":@(self.Slider_Bottom.slier.value)
                              };
        NSInteger index = _TyreButton_Sel.tag - 1301;
        [self.listData replaceObjectAtIndex:index withObject:dic];
        [MBProgressHUD showHudTipStr:@"保存成功"];
        
    }else{
        //恢复
        NSInteger index = _TyreButton_Sel.tag - 1301;
        [self.listData replaceObjectAtIndex:index withObject:[self.basicData copy]];
        [self HandlData:self.basicData];
    }
}





- (void)HandlData:(NSDictionary *)dic{
    self.Slider_Left.slier.value   = [dic[@"Slider_Left"]floatValue];
    self.Slider_Right.slier.value  = [dic[@"Slider_Right"]floatValue];
    self.Slider_Bottom.slier.value = [dic[@"Slider_Bottom"]floatValue];
    
    if ([dic[@"Temperature"] integerValue] == 0) {
        [self TemperatureButtonClick:self.Temperature_SSD];
        
        
    }else{
        [self TemperatureButtonClick:self.Temperature_HSD];
    }
    
    if ([dic[@"Pressure"] integerValue] == 2) {
        [self PressureButtonClick:self.Pressure_PSI];
    }else if ([dic[@"Pressure"] integerValue] == 3){
        [self PressureButtonClick:self.Pressure_KPA];
        
    }else{
        [self PressureButtonClick:self.Pressure_BAR];
    }
    self.Slider_Left.sliderType   = [dic[@"Pressure"] integerValue];
    self.Slider_Right.sliderType  = [dic[@"Pressure"] integerValue];
    self.Slider_Bottom.sliderType = [dic[@"Temperature"] integerValue];
    
}

#pragma mark -- 设置导航栏按钮
- (void)setLeftNavigation{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationLeftBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(barbuttonAction)];
    
    
    self.navigationItem.leftBarButtonItem = bar;
}

- (void)barbuttonAction{
    //返回后保存
    DEFAULTS_SET_OBJ(self.listData, kTyreSetData);
    DEFAULTS_SAVE;
    [self popGoBack];
}



/**
 *
 *
 *
 **/

- (UIButton *)CreateButtonWithTitle:(NSString *)title Frame:(CGRect)frame{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:@"TyreSet_Img"];
    
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeTop];
    [button setImage:[UIImage imageNamed:@"TyreSet_Img_Sel"] forState:UIControlStateSelected];
    
    [button.titleLabel setBackgroundColor:[UIColor clearColor] ];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0] ];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGFloat h = frame.size.height;
    CGFloat w = frame.size.width;
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0,
                                                0.0,
                                                0.0,
                                                w-h)];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                                0.0,
                                                0.0,
                                                5.0)];
    return button;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
