//
//  AppMacro.h
//  PaperSource
//
//  Created by Yhoon on 15/10/13.
//  Copyright © 2015年 yhoon. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#pragma mark - BaseUrl
// 接口链接地址
#define APP_BASEURL @"http://115.159.86.102"

#pragma mark - BaseColor
// 基本颜色
#define APP_COLOR_BASE_BAR              [UIColor colorWithRed:0.24 green:0.32 blue:0.71 alpha:1.00]



#define APP_COLOR_BASE_BACKGROUND       [UIColor colorWithRed:0.16 green:0.64 blue:0.99 alpha:1.00]
#define APP_COLOR_BASE_TABBAR           [UIColor colorWithRed:0.16 green:0.64 blue:0.99 alpha:1.00]
#define APP_COLOR_BASE_LINE             [UIColor colorWithRed:0.16 green:0.64 blue:0.99 alpha:1.00]

// 开关 灰色
#define APP_COLOR_SWITCH_GRAY           [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00]


//分割线  背景色
#define CELL_COLOR_CUT                  HEXCOLOR(0x0d4d92)
#define CELL_COLOR_BACKGROUND           [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.30]


#define CELL_BASE_FONT                  [UIFont systemFontOfSize:14]
#define TEXTFIELD_BASE_FONT             [UIFont systemFontOfSize:12]

#pragma mark - Define Name


// APP内部使用宏定义名称
#define mLOGINSTATE      @"Login_state"
#define mLOGINUSERDICT   @"User_dict"
#define mLOGINUSERINFO   @"User_info"
#define mLOGINUSERLIST   @"User_list"
#define mBTNAME          @"mbt_name"
#define mBTAUTOCONNECT   @"mbt_autoconnect"
#define mAPPFIRSTFIX     @"appfirstfix"
#define mCARINFOID       @"mcar_infoID"
#define mUnLook          @"munlook"


/******************************************************************************/
#pragma mark - Url Path

#define MAMapKey                                @"ccda70c62020ef6081369574394d28f4"

// 登录注册相关
#define APPINTERFACE_Register           @"/zhihuiqichen/userlogin/userRegisterPost"             // 注册
#define APPINTERFACE_Register_Check     @"/zhihuiqichen/userlogin/checkusernameuniquepost"     //注册前检查用户名是有已经被使用
#define APPINTERFACE_Login              @"/zhihuiqichen/userlogin/userloginPost"                // 登录
#define APPINTERFACE_Logout             @"/zhihuiqichen/userlogin/userlogout"                   // 退出登录
#define APPINTERFACE_modifyUserPwd      @"/zhihuiqichen/userinfo/setpasswordpost"               // 修改密码
#define APPINTERFACE_ForgetUserPwd      @"/zhihuiqichen/userlogin/forgotpasswordpost"           // 忘记密码
#define APPINTERFACE_SendMob            @"/index/sms/sendcodepost"                            //发送验证码
#define APPINTERFACE_CheckMob           @"/index/sms/checkcodepost"                           //校验验证码

#define APPINTERFACE__SetAvatar         @"/zhihuiqichen/userinfo/setavatarpost"               //上传头像
#define APPINTERFACE__UserInfo          @"/zhihuiqichen/userinfo/getuserinfopost"             //查看个人信息
#define APPINTERFACE__ModifyUserInfo    @"/zhihuiqichen/userinfo/setuserinfopost"             //修改个人信息

#define APPINTERFACE__SetCar            @"/zhihuiqichen/carinfo/setcarinfopost"             //设置车辆信息
#define APPINTERFACE__GetCar            @"/zhihuiqichen/carinfo/getcarinfopost"             //获取单辆车的详细信息
#define APPINTERFACE__ListCar           @"/zhihuiqichen/carinfo/listcarinfopost"            //获取所有车的信息

#define APPINTERFACE_Cycle              @"/zhihuiqichen/viewpage/listviewpagepost"           // 首页轮播图

//位置共享相关
#define APPINTERFACE_CreateLocationShared @"/zhihuiqichen/locationshare/setlocationsharepost" //创建位置共享事件
#define APPINTERFACE_CreateContact @"/zhihuiqichen/contact/setcontactpost" //创建联系人

#endif /* AppMacro_h */
