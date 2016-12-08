//
//  PresetMsgView.m
//  WisdomVenucia
//
//  Created by 魏初芳 on 15/12/9.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "PresetMsgView.h"

@interface PresetMsgView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *presetMsgs;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PresetMsgView

- (instancetype)init{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PresetMsgView" owner:nil options:nil] lastObject];
    }
    ViewRadius(self, 4.0);
    return self;
}

- (void)drawRect:(CGRect)rect{
    [self initData];
    [self initUI];
}

- (void)initData{
    self.presetMsgs = @[@"车子到达目的地",@"车子启动准备出发",@"车子",@"发酵阿卡丽根据阿卡",@"放假啊开发家阿哥"];
}

- (void)initUI{
    self.textFile.placeholder = @"请选择预设消息";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(GetViewMinX(self), GetViewMaxY(self), ViewWidth(self), 0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.superview addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presetMsgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    cell.textLabel.text = self.presetMsgs[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.textFile.text = self.presetMsgs[indexPath.row];
    [self resetTableViewHeight:0];
}

#pragma mark - buttonClike
- (IBAction)buttonClike:(UIButton *)sender {
    sender.selected = !sender.selected;
    CGFloat height = 0;
    if (sender.selected) {
        height = 120;
    }else{
        height = 0;
    }
    [self resetTableViewHeight:height];
}

- (void)resetTableViewHeight:(CGFloat)height{
    CGRect frame = self.tableView.frame;
    frame.size.height = height;
    self.tableView.frame = frame;
}
@end
