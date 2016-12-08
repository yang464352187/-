//
//  AppointmentVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/12/4.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "AppointmentVC.h"
#import "DatePickerView.h"

#define kAppointmentFont [UIFont systemFontOfSize:15]

@interface AppointmentVC ()<UITableViewDataSource,UITableViewDelegate,DatePickerViewDelegate>

@property (strong, nonatomic) NSArray        *titleList;
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) UIScrollView   *scrollView;
@property (strong, nonatomic) DatePickerView *datePicker;

@property (strong, nonatomic) UITextField *goMileage;
@property (strong, nonatomic) UITextField *careMileage;
@property (strong, nonatomic) UILabel  *carOwner;
@property (strong, nonatomic) UILabel  *buyTime;
@property (strong, nonatomic) UILabel  *careTime;
@property (assign, nonatomic) NSInteger index;

@end

@implementation AppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"保养预约";
}

#pragma mark -- Data
- (void)initData{
    
    self.titleList = @[@"车牌：闽D9110A",@"已行驶里程：",@"已保养里程：",@"购车时间：",@"上次保养时间："];
}

#pragma mark -- UI
- (void)initUI{
    
    [self initDatePickerView];
    [self initScrollViewAndLabel];
    [self setSecLeftNavigation];
    [self initTableView];
}

- (void)initDatePickerView{
    self.datePicker = [[DatePickerView alloc] initWithFrame:APP_BOUNDS];
    self.datePicker.delegate = self;
    //[self.datePicker setinitialDate:self.userInfo[@"birthday"]];
    [self.datePicker setMaxDate:[NSDate date]];
    [self.view addSubview:self.datePicker];
    [self.view sendSubviewToBack:self.datePicker];
}

- (void)initScrollViewAndLabel{
    self.scrollView = [[UIScrollView alloc] initWithFrame:APP_BOUNDS];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 650);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    
    
    //黄字
    UILabel *label1 =[UILabel createLabelWithFrame:VIEWFRAME(0,64+20 , SCREEN_WIDTH, 20)
                                           andText:@"请先设置保养相关数据,以保证软件给您提供"
                                      andTextColor:HEXCOLOR(0xe1b620)
                                        andBgColor:[UIColor clearColor]
                                           andFont:kAppointmentFont
                                  andTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:label1];
    
    UILabel *label2 =[UILabel createLabelWithFrame:VIEWFRAME(0,64+50 , SCREEN_WIDTH, 15)
                                           andText:@"更准确的保养提醒"
                                      andTextColor:HEXCOLOR(0xe1b620)
                                        andBgColor:[UIColor clearColor]
                                           andFont:kAppointmentFont
                                  andTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:label2];
    
    //虚线
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,64+78, SCREEN_WIDTH, 1)];
    [self.scrollView addSubview:imageView1];
    
    
    UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    CGFloat lengths[] = {3,2};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 1.0);    //开始画线
    CGContextAddLineToPoint(line, SCREEN_WIDTH, 1.0);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    //黄字
    UILabel *label3 =[UILabel createLabelWithFrame:VIEWFRAME(0,64+395 , SCREEN_WIDTH, 20)
                                           andText:@"提示:如果爱车还未保养过,上次保养时间"
                                      andTextColor:HEXCOLOR(0xe1b620)
                                        andBgColor:[UIColor clearColor]
                                           andFont:kAppointmentFont
                                  andTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:label3];
    
    UILabel *label4 =[UILabel createLabelWithFrame:VIEWFRAME(0,64+425 , SCREEN_WIDTH, 15)
                                           andText:@"可以设置与购车时间相同"
                                      andTextColor:HEXCOLOR(0xe1b620)
                                        andBgColor:[UIColor clearColor]
                                           andFont:kAppointmentFont
                                  andTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:label4];
    
    UIImage *motifyImg = [UIImage imageNamed:@"BaseButton"];
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = VIEWFRAME(SCREEN_WIDTH/2-motifyImg.size.width/2, 64+ 470, motifyImg.size.width, motifyImg.size.height);
    Button.transform = CGAffineTransformMakeScale(0.9, 0.9);
    Button.titleLabel.font = SYSTEMFONT(17);
    [Button setTitle:@"完成" forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Button setBackgroundImage:motifyImg forState:UIControlStateNormal];
    [Button setBackgroundImage:[UIImage imageNamed:@"BaseButton_Sel"] forState:UIControlStateHighlighted];
    [Button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:Button];
}

#pragma mark -- tabelview 初始化
- (void)initTableView{
    self.tableView                 = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64+80, SCREEN_WIDTH, 300)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled   = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:self.tableView];
}

#pragma mark -- table delegate source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"MyCell%li",(long)indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"MyCell%li",(long)indexPath.row]];
    }
    switch (indexPath.row) {
        case 0:{
            self.carOwner  = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/2, 10, 160, 40)
                                                   andText:@"车主：小明"
                                              andTextColor:[UIColor whiteColor]
                                                andBgColor:[UIColor clearColor]
                                                   andFont:kAppointmentFont
                                          andTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:self.carOwner];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 1:{
            self.goMileage         = [UITextField createTextFieldWithFrame:VIEWFRAME(SCREEN_WIDTH/2, 10, 100, 40)
                                                                   andName:@""
                                                            andPlaceholder:@"输入框"
                                                          andTextAlignment:NSTextAlignmentLeft
                                                               andFontSize:kAppointmentFont
                                                              andTextColor:[UIColor blackColor]
                                                               andDelegate:self];
            self.goMileage.leftViewMode =UITextFieldViewModeAlways;
            self.goMileage.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 5, 0)];
            self.goMileage.keyboardType = UIKeyboardTypeNumberPad;
            ViewRadius(self.goMileage, 6);
            [cell addSubview:self.goMileage];
            
            UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/2+110, 10, 160, 40)
                                                   andText:@"KM"
                                              andTextColor:[UIColor whiteColor]
                                                andBgColor:[UIColor clearColor]
                                                   andFont:kAppointmentFont
                                          andTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 2:{
            self.careMileage       = [UITextField createTextFieldWithFrame:VIEWFRAME(SCREEN_WIDTH/2, 10, 100, 40)
                                                                   andName:@""
                                                            andPlaceholder:@"输入框"
                                                          andTextAlignment:NSTextAlignmentLeft
                                                               andFontSize:kAppointmentFont
                                                              andTextColor:[UIColor blackColor]
                                                               andDelegate:self];
            self.careMileage.leftViewMode =UITextFieldViewModeAlways;
            self.careMileage.leftView = [[UIView alloc] initWithFrame:VIEWFRAME(0, 0, 5, 0)];
            self.careMileage.keyboardType = UIKeyboardTypeNumberPad;
            ViewRadius(self.careMileage, 6);
            [cell addSubview:self.careMileage];
            
            UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/2+110, 10, 160, 40)
                                                   andText:@"KM"
                                              andTextColor:[UIColor whiteColor]
                                                andBgColor:[UIColor clearColor]
                                                   andFont:kAppointmentFont
                                          andTextAlignment:NSTextAlignmentLeft];
            [cell addSubview:label];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 3:{
            self.buyTime   = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/2, 10, 160, 40)
                                                   andText:@"未设置"
                                              andTextColor:[UIColor whiteColor]
                                                andBgColor:[UIColor clearColor]
                                                   andFont:kAppointmentFont
                                          andTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:self.buyTime];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        }
        case 4:{
            self.careTime  = [UILabel createLabelWithFrame:VIEWFRAME(SCREEN_WIDTH/2, 10, 160, 40)
                                                   andText:@"未设置"
                                              andTextColor:[UIColor whiteColor]
                                                andBgColor:[UIColor clearColor]
                                                   andFont:kAppointmentFont
                                          andTextAlignment:NSTextAlignmentCenter];
            [cell addSubview:self.careTime];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
        }
        default:
            break;
    }
    
    //分割线
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 59, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    cell.backgroundColor     = [UIColor clearColor];
    cell.textLabel.font      = kAppointmentFont;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text      = self.titleList[indexPath.row];
    
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.index = indexPath.row;
    if (indexPath.row == 3) {
        if (![self.buyTime.text isEqualToString:@"未设置"]) {
           [self.datePicker setinitialDate:self.buyTime.text];
        }
        [self.datePicker setMinDate:nil];
        [self.datePicker bringSubviewToFrontAction];
    }else if (indexPath.row == 4){
        if ([self.buyTime.text isEqualToString:@"未设置"]) {
            [MBProgressHUD showHudTipStr:@"请先设置购车时间"];
        }else{
            [self.datePicker setMinStrDate:self.buyTime.text];
            if (![self.careTime.text isEqualToString:@"未设置"]){
                [self.datePicker setinitialDate:self.careTime.text];
            }else{
                [self.datePicker setinitialDate:self.buyTime.text];
            }
            [self.datePicker bringSubviewToFrontAction];
        }
        
        
    }
    
}

- (void)didSaveClick:(NSString *)date{
    if (self.index == 3) {
        self.buyTime.text = date;
        
    }else{
        self.careTime.text = date;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- button动作
- (void)buttonClick:(UIButton *)sender{
    [self popGoBack];
}

@end
