//
//  RescuListCell.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 16/7/7.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "RescuListCell.h"

@interface RescuListCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UITextField *nameTextFiled;
@property (nonatomic, strong) UITextField *phoneTextFiled;
@property (nonatomic, strong) UISwitch *controlSwitch;

@end

@implementation RescuListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)initUI {
//    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    ViewRadius(self.headImageView, 40);
//    [self.contentView addSubview:self.headImageView];
    
    UILabel *nameLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"姓        名:" andTextColor:[UIColor whiteColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [UILabel createLabelWithFrame:CGRectZero andText:@"手机号码:" andTextColor:[UIColor whiteColor] andBgColor:[UIColor clearColor] andTextAlignment:NSTextAlignmentLeft];
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:phoneLabel];
    
    self.nameTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextFiled.backgroundColor = [UIColor whiteColor];
    self.nameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextFiled.placeholder = @"姓名";
    self.nameTextFiled.enabled = NO;
    [self.contentView addSubview:self.nameTextFiled];
    
    self.phoneTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneTextFiled.backgroundColor = [UIColor whiteColor];
    self.phoneTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextFiled.placeholder = @"手机号码:";
    self.phoneTextFiled.enabled = NO;
    [self.contentView addSubview:self.phoneTextFiled];
    
    self.controlSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [self.controlSwitch setOn:NO];
    [self.controlSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.controlSwitch];
    
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.equalTo(self).offset(10);
//        make.width.and.height.equalTo(@80);
//    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(20);
        make.width.equalTo(@80);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(30);
        make.left.equalTo(nameLabel);
        make.width.equalTo(@80);
    }];
    
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@35);
    }];
    
    [self.phoneTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneLabel);
        make.left.equalTo(phoneLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@35);
    }];
    
    [self.controlSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (void)configCellData:(id)data {
    
}

- (void)switchAction:(id)sender {
    if (_controlSwitchBlock) {
        _controlSwitchBlock();
    }
}

@end
