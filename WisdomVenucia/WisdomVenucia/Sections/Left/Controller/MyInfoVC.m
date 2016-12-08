//
//  MyInfoVC.m
//  WisdomVenucia
//
//  Created by 苏凡 on 15/11/18.
//  Copyright © 2015年 苏凡. All rights reserved.
//

#import "MyInfoVC.h"

static NSString * const identifier = @"MyInfoCell";

@interface MyInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIButton *HeadImage;
@property (strong, nonatomic) NSArray *imagelist;
@property (strong, nonatomic) NSArray *titleList;
@property (strong, nonatomic) NSArray *valueList;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation MyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    self.title = @"个人信息";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
    if (self.userInfo) {
        NSString *str = [self.userInfo[@"sex"] integerValue] == 0? @"男":@"女";
        self.valueList = @[self.userInfo[@"username"],self.userInfo[@"nickname"],str,self.userInfo[@"birthday"],self.userInfo[@"address"],self.userInfo[@"introduction"]];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",APP_BASEURL,self.userInfo[@"avatar"]];
        [self.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:strUrl]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"HeadImage"]];
    }else{
        self.valueList = @[@"",@"",@"",@"",@"",@""];
    }
    [self.tableView reloadData];
}

#pragma mark -- 初始化数据
- (void)initData{
    self.titleList = @[@"帐号",@"昵称",@"性别",@"出生日期",@"地区",@"个性签名"];
    self.imagelist = @[@"MyInfoImage1",@"SetImage1",@"MyInfoImage3",@"MyInfoImage4",@"MyInfoImage5",@"MyInfoImage6"];
    
//    self.userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
//    if (self.userInfo) {
//        NSString *str = [self.userInfo[@"sex"] integerValue] == 0? @"男":@"女";
//        self.valueList = @[self.userInfo[@"username"],self.userInfo[@"nickname"],str,self.userInfo[@"birthday"],self.userInfo[@"address"],self.userInfo[@"introduction"]];
//    }else{
//        self.valueList = @[@"",@"",@"",@"",@"",@""];
//    }

}

#pragma mark --设置UI
- (void)initUI{
    [self initHeadView];
    [self initTableView];
    [self setSecLeftNavigation];
    [self setSecRightNavigation];
}

#pragma mark --设置头像和标签
- (void)initHeadView{
    
    self.HeadImage = [[UIButton alloc] initWithFrame:VIEWFRAME(SCREEN_WIDTH/2-40, 64 + 20, 80, 80)];
    ViewRadius(self.HeadImage, 40);

    [self.HeadImage addTarget:self action:@selector(headImageClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.userInfo) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",APP_BASEURL,self.userInfo[@"avatar"]];
        [self.HeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:strUrl]
                                             forState:UIControlStateNormal
                                     placeholderImage:[UIImage imageNamed:@"HeadImage"]];

    }
    
    [self.view addSubview:self.HeadImage];
    
    UIImageView *BaseLogo= [[UIImageView alloc] initWithFrame:VIEWFRAME(15, 64+100, 21, 26)];
    BaseLogo.image = [UIImage imageNamed:@"MyInfoBase"];
    [self.view addSubview:BaseLogo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:VIEWFRAME(50, 64+100, 100, 26)];
    label.text = @"基本资料";
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    //虚线
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,64+140, SCREEN_WIDTH, 1)];
    [self.view addSubview:imageView1];

    
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
    
}

#pragma mark --设置表视图
- (void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:VIEWFRAME(0, 64+141, SCREEN_WIDTH, SCREEN_HIGHT-147-64)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    
}

#pragma mark -- table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.detailTextLabel.text      = self.valueList[indexPath.row];
    cell.detailTextLabel.font      = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text            = self.titleList[indexPath.row];
    cell.textLabel.font            = SCREEN_HIGHT > 600? SYSTEMFONT(16) : SYSTEMFONT(14);
    cell.imageView.image           = [UIImage imageNamed:self.imagelist[indexPath.row]];
    cell.textLabel.textColor       = [UIColor whiteColor];
    cell.backgroundColor           = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    //分割线
    UIView *cut = [[UIView alloc] initWithFrame:VIEWFRAME(0, SCREEN_HIGHT/12, SCREEN_WIDTH, 1)];
    cut.backgroundColor = CELL_COLOR_CUT;
    [cell addSubview:cut];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HIGHT/12;
}

#pragma mark -- 头像点击动作
- (void)headImageClick:(UIButton *)sender{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *pick=[[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        NSLog(@"相机");
        //判断相机是否可用,因为模拟机是不可以的
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            pick.sourceType=UIImagePickerControllerSourceTypeCamera;//设置 pick 的类型为相机
            pick.allowsEditing=true;//设置是否可以编辑相片涂鸦
            pick.delegate=self;
            [self presentViewController:pick animated:true completion:nil];
        }
        else
        {
            NSLog(@"相机不可用");
        }
    }
    else if (buttonIndex==1)
    {
        NSLog(@"相册");
        //判断相册是否可用
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            pick.allowsEditing=true;
            pick.delegate=self;
            [self presentViewController:pick animated:true completion:nil];
        }
        else
        {
            NSLog(@"相册不可用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    //判断选择的是否是图片,这个 public.image和public.movie是固定的字段.
    if ([type isEqualToString:@"public.image"])
    {
        //设置图片  MARK: 上传头像在这里进行
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
        //这一步主要是判断当是用相机拍摄的时候，保存到相册
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
        
        NSDictionary *dic = @{@"token":self.currentLoginUser.token};
        
        
        NSLog(@"token   %@",self.currentLoginUser.token);

        [SVProgressHUD show];
        _weekSelf(weakSelf);
        [[NetAPIManager sharedManager] request_UploadHeadImage_WithImage:image Params:dic succesBlack:^(id data) {
            
            
            NSDictionary *userInfo = DEFAULTS_GET_OBJ(mLOGINUSERINFO);
            UserInfoModel *model = [MTLJSONAdapter modelOfClass:[UserInfoModel class]
                                             fromJSONDictionary:userInfo
                                                          error:nil];
            model.avatar = data[@"imgPath"];
            model.token = self.currentLoginUser.token;
            [[NetAPIManager sharedManager] request_ModifyUserInfo_WithParams:model succesBlack:^(id data) {
                [SVProgressHUD dismiss];
                [MBProgressHUD showHudTipStr:@"上传成功"];
                [weakSelf.HeadImage setImage:image forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLeftVC object:nil];
            } failue:^(id data, NSError *error) {
                [SVProgressHUD dismiss];
            }];
            
        } failue:^(id data, NSError *error) {
            [SVProgressHUD dismiss];
        } progerssBlock:^(CGFloat progressValue) {
            
        }];
        
        //这里再加个写入到本地的方案
        //获取写入的文件夹
//        NSString *documents=[NSHomeDirectory() stringByAppendingString:@"/Documents"];
//        //也可以用下面这个,区别就是加不加/
//        //NSString *documents=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //将 image 转换为 data
//        NSData *data;
//        if (UIImagePNGRepresentation(image)) {
//            data=UIImagePNGRepresentation(image);
//        }
//        else
//            data=UIImageJPEGRepresentation(image, 1.0);
//        NSFileManager *filemanager=[NSFileManager defaultManager];
//        //避免覆盖
//        static int i=0;
//        i++;
//        [filemanager createFileAtPath:[documents  stringByAppendingFormat:@"/%d.png",i] contents:data attributes:nil];
        
    }
    [picker dismissViewControllerAnimated:false completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:false completion:nil];
}

#pragma mark -- 设置右按钮
- (void)setSecRightNavigation{
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CarInfoRightBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(RightButtonAction)];
    self.navigationItem.rightBarButtonItem = barBtn;

}

#pragma mark -- 右按钮动作
- (void)RightButtonAction{
    [self postViewControllerJumpNotificationByTypeName:Notification_PUSH_VIEWCONTROLLER className:@"MotifyMyInfoVC" object:nil info:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
