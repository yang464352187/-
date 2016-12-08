//
//  RescueVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 16/3/11.
//  Copyright © 2016年 苏凡. All rights reserved.
//

#import "RescueVC.h"

@interface RescueVC ()<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>

@property (strong, nonatomic) UITableView         *tableView;
@property (strong, nonatomic) NSMutableDictionary *totalData;
@property (strong, nonatomic) NSMutableArray      *listData;
@property (strong, nonatomic) NSXMLParser         *par;
@property (strong, nonatomic) NSString            *name;
@property (strong, nonatomic) NSMutableArray      *items;
@property (strong, nonatomic) NSString            *province;

@end

@implementation RescueVC


#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    [self Adds];
    self.title = @"救援电话";
}

#pragma mark -- addSubView
- (void)Adds{
    [self.view addSubview:self.tableView];
}

#pragma mark -- Data
- (void)initData{
    //获取事先准备好的XML文件
    NSBundle *b = [NSBundle mainBundle];
    NSString *path = [b pathForResource:@"arrays" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.par = [[NSXMLParser alloc]initWithData:data];
    
    //添加代理
    self.par.delegate = self;
    //初始化数组，存放解析后的数据
    self.listData = [NSMutableArray array];
    self.totalData = [NSMutableDictionary dictionary];
    [self.par parse];
}

#pragma mark -- UI
- (void)initUI{
    [self setSecLeftNavigation];
}

#pragma mark -- event response

//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    _name = elementName;
    if ([elementName isEqualToString:@"string-array"]) {
        self.province = [attributeDict objectForKey:@"name"];
        self.items = [NSMutableArray array];
    }
    //NSLog(@"name : %@",elementName);
    
    
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string  = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
    
    if ([_name isEqualToString:@"item"]) {
        [self.items addObject:string];
    }
    
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    if ([elementName isEqualToString:@"string-array"] && ![self.province isEqualToString:@"brand"] ) {
        NSArray *array = self.items;
        [self.totalData setObject:array forKey:self.province];
    }
    
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidEndDocument...");
    self.listData = self.totalData[@"province"];
    [self.tableView reloadData];
}

//外部调用接口
-(void)parse{
    [self.par parse];
    
}

#pragma mark -- UITabelViewDelegate And DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RescueCell"];
    
    cell.accessoryType       = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text      = self.listData[indexPath.row];
    cell.textLabel.font      = SYSTEMFONT(16);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor     = [UIColor clearColor];
    
    //背景色和分割线
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = CELL_COLOR_BACKGROUND;
    cell.selectedBackgroundView = back;
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, 60, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];

    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = self.listData[indexPath.row];
    NSDictionary *notify = @{@"title"    : name,
                             @"listData" : self.totalData[name]};
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"RescueDetailVC" object:nil info:notify];
    
}

#pragma mark -- getters and setters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64, SCREEN_WIDTH, SCREEN_HIGHT-64)];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator   = NO;
        
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RescueCell"];
        UILabel *label = [UILabel createLabelWithFrame:VIEWFRAME(0, 0, SCREEN_WIDTH, 50)
                                               andText:@"全国统一救援服务电话：12122"
                                          andTextColor:[UIColor whiteColor]
                                            andBgColor:[UIColor clearColor]
                                               andFont:SYSTEMFONT(16)
                                      andTextAlignment:NSTextAlignmentCenter];
        _tableView.tableHeaderView = label;
    }
    return _tableView;
}

@end
