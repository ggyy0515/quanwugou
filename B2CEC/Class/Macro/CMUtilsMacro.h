//
//  CMUtilsMacro.h
//  TrCommerce
//
//  Created by Tristan on 15/11/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#ifndef CMUtilsMacro_h
#define CMUtilsMacro_h

#define wenqiu_address                              @"http://10.10.1.110/"

#define wenqiu2_address                             @"https://10.10.1.59:8443/"

#define gaofang_address                             @"http://10.10.1.86:8888/"

#define yinyuan_address                             @"http://10.10.1.123:8080/"

#define huangHu_address                             @"http://10.10.1.234:8080/"

#define wangyue_address                             @"https://10.10.1.99:8443/"

#define xinbin_address                              @"http://10.10.1.66:8084/"

#define lizhiyong_address                           @"http://10.10.1.50:8010/"

#define qinguanyu_address                           @"http://10.10.1.68:8443/"

#define inner_server_adderss                        @"https://10.10.1.112:8443/"
 
#define outside_server_adderss                      @"https://120.24.59.6:8443/"

#define custom_server_address                       @"http://www.maijiusong999.com/"

#define yangyu_address                              @"https://10.10.1.14:8443/"

#define HOST_ADDRESS                                outside_server_adderss          //切换主机改这里就行






#define HTTP_USER_CONTROLLER_HEAD                   [NSString stringWithFormat:@"%@jf/shuhua/ecmall/usercontroller/",HOST_ADDRESS]
#define HTTP_SHOW_CONTROLLER_HEAD                   [NSString stringWithFormat:@"%@jf/shuhua/ecmall/showindex/",HOST_ADDRESS]
#define HTTP_PRODUCT_CONTROLLER_HEAD                [NSString stringWithFormat:@"%@jf/shuhua/ecmall/productshow/",HOST_ADDRESS]
#define HTTP_USER_ORDER_HEAD                        [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/order/",HOST_ADDRESS]
#define HTTP_USER_HEAD                              [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/user/",HOST_ADDRESS]
#define HTTP_USER_ORDERINFO                         [NSString stringWithFormat:@"%@jf/shuhua/ecmall/order/",HOST_ADDRESS]
#define HTTP_PERSINAL_CENTER                        [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/personal/",HOST_ADDRESS]
#define HTTP_USER_FRIEND                            [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/userfriend/",HOST_ADDRESS]
#define HTTP_WALLET_HEADER                          [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/myWallet/",HOST_ADDRESS]
#define HTTP_SEARCH_SHOP_TYPE_HEADER                [NSString stringWithFormat:@"%@jf/shuhua/ecmall/searchshoptype/",HOST_ADDRESS]
#define HTTP_SHOP_TYPE_HEAD                         [NSString stringWithFormat:@"%@jf/shuhua/ecmall/shoptype/",HOST_ADDRESS]
#define HTTP_MYPAYMENT                              [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/mypayment/",HOST_ADDRESS]
#define HTTP_USER_MESSAGE                           [NSString stringWithFormat:@"%@jf/shuhua/ecmall/message/",HOST_ADDRESS]
#define HTTP_STORE_CATE                             [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/store/cate/",HOST_ADDRESS]
#define HTTP_SHOP_ORDER                             [NSString stringWithFormat:@"%@jf/shuhua/shoporder/",HOST_ADDRESS]
#define HTTP_WXPAY                                  [NSString stringWithFormat:@"%@jf/shuhua/pay/wxpay/",HOST_ADDRESS]
#define HTTP_DRESS                                  [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/store/dress/",HOST_ADDRESS]
#define HTTP_UNIONPAY                               [NSString stringWithFormat:@"%@jf/ecmall/unionpay/",HOST_ADDRESS]
#define HTTP_LUCENE                                 [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/lucene/",HOST_ADDRESS]
#define HTTP_AliPay                                 [NSString stringWithFormat:@"%@jf/shuhua/pay/zhifubao/zhifubaoPay",HOST_ADDRESS]
#define HTTP_Opinion                                [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/opinion/",HOST_ADDRESS]
#define HTTP_COMMENT                                [NSString stringWithFormat:@"%@jf/shuhua/ecmall/app/comment/",HOST_ADDRESS]


#if  DEBUG
#define ECLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define ECLog(...);
#endif

/*
 * 单例
 */

// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

//显示GIF加载
#define showLoadingGif(view) \
UIView *loadingGifView = [[UIView alloc] initWithFrame:view.frame]; \
loadingGifView.backgroundColor = BaseColor; \
loadingGifView.tag = 76543; \
[view addSubview:loadingGifView]; \
YLImageView *imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 80.f)]; \
imageView.center = CGPointMake(SCREENWIDTH / 2.f, SCREENHEIGHT / 2.f - 64.f); \
[loadingGifView addSubview:imageView]; \
imageView.image = [YLGIFImage imageNamed:@"loadingHtml.gif"]; 
//隐藏GIF
#define dismisLoadingGif(view) \
[[view viewWithTag:76543] removeFromSuperview];



#define SELF_BASENAVI                   ((CMBaseNavigationController *)self.navigationController)
#define WEAKSELF_BASENAVI               ((CMBaseNavigationController *)weakSelf.navigationController)
#define STRONGSELF_BASENAVI             ((CMBaseNavigationController *)strongSelf.navigationController)
#define SELF_VC_BASEVAV                 ((CMBaseNavigationController *)self.viewController.navigationController)
#define WEAKSELF_VC_BASENAVI            ((CMBaseNavigationController *)weakSelf.viewController.navigationController)
#define STRONGSELF_VC_BASENAVI          ((CMBaseNavigationController *)strongSelf.viewController.navigationController)


//placeholder
#define TEXTFIELD_PLACEHORDER_TEXTCOLOR   @"_placeholderLabel.textColor"
#define TEXTFIELD_PLACEHORDER_FONT        @"_placeholderLabel.font"

//菊花出现
#define SHOWSVP             [SVProgressHUD show];
//菊花消失
#define DISMISSSVP          [SVProgressHUD dismiss];
//默认图
#define DEFAULTIMAGE        [UIImage imageNamed:@"placeholder_goods2"]
//拼接网络图片
#define IMAGEURL(URL)       [NSString stringWithFormat:@"%@%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.imageHeader,URL]

//判断网络请求是否成功
#define IS_REQUEST_SUCCEED(dic)           ([[(dic) objectForKey:@"code"] integerValue] == 10000)
//判断网络请求是否是鉴权失败
#define IS_REQUEST_INVALIDATION(dic)      ([[(dic) objectForKey:@"code"] integerValue] == 20002 || [[(dic) objectForKey:@"code"] integerValue] == 20003 || [[(dic) objectForKey:@"code"] integerValue] == 20004 || [[(dic) objectForKey:@"code"] integerValue] == 20005 )

//请求得到相应，提示用户
#define RequestSuccess(result)            IS_REQUEST_SUCCEED(result) ? [SVProgressHUD showSuccessWithStatus:result[@"msg"]] : [SVProgressHUD showErrorWithStatus:result[@"msg"]];
//显示请求成功，报错的信息
#define EC_SHOW_REQUEST_ERROR_INFO        [SVProgressHUD showInfoWithStatus:result[@"msg"]];
//请求失效
#define RequestInvalidation               [SVProgressHUD showInfoWithStatus:@"请求失效，请重新登录"];
//网络请求失败
#define RequestFailure                    [SVProgressHUD showInfoWithStatus:@"网络开小差了.."];
//网络请求报错
#define RequestError                      [SVProgressHUD showInfoWithStatus:@"网络请求错误"];
//订单列表每页数据量
#define OrderListPageSize                 20
//scrollview page space
#define kItemMargin 10
#define OFFSET_TRIGGER_DIRECTION           40.0

//屏幕
#define SCREENHEIGHT                [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH                 [UIScreen mainScreen].bounds.size.width
#define kMainScreen_RATIO           (SCREENWIDTH/320.0)
#define kWaterPercentW              ((SCREENHEIGHT)/2.5 - 20)

//sys
#define APP_DELEGATE                ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define SYS_VERSION                 [UIDevice currentDevice].systemVersion.floatValue
#define WEAK_SELF                   typeof(self) __weak weakSelf = self;
#define STRONG_SELF                 typeof(weakSelf) __strong strongSelf = weakSelf;
#define USERDEFAULT                 [NSUserDefaults standardUserDefaults]
#define APPVERSION                  @"APPVERSION"

//系统版本号
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//AES加密Key
#define SESKEY                      @"12345abcDEF67890"

//服务器图片存储路径
#define ServerImagePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"/Caches"]

//各种key和id
#define WEIXINAPPID             @"wx114781ac4160a9a0"//
#define WEIXINAPPSECRET         @"ed91209df370ed5af01f63cd947df448"//
#define UMAPPKEY                @"5829a4179f06fd5490002662"//
#define TENCENTAPPID            @"1105814830"//
#define TENCENTAPPKEY           @"wMKn4SiHLYadqkpc"//
#define SINAAPPKEY              @"3168293140"//
#define SINAAPPSECRET           @"8ca0bcc55f9966897d6801ede315273f"//
#define HUANXINAPPKEY           @"1148161228178837#quanwugou"//
#define HUANXINCERNAME_PRD      @"aps_dst"//
#define HUANXINCERNAME_DEV      @"aps_dev"//
#define JPUSHAPPKEY             @"c4f3316ddb066bf7eeec25b6"//
#define HUANXIN_LOGIN_PASSWORD  @"88888888"//




//cell
#define IS_NORMAL_RESPONDDELEGATE_FUNC(id,SEL) (id && [id respondsToSelector:SEL])
#define CELL_IDENTIFY_WITH_OBJECT(obj) NSStringFromClass([obj class])


//null
#define OBJ_IS_NULL(obj)                                ([(obj) isKindOfClass:[NSNull class]])
#define STR_IS_NIL_ASSIGNMENT(str)                      (([(str) isKindOfClass:[NSNull class]]) ? (@"") : (str))
#define STR_IS_NullClass(str,nilStr)                    (([(str) isKindOfClass:[NSNull class]]) ? (nilStr) : (str))
#define STR_IS_NIL(str,nilStr)                          ((str == nil) ? (nilStr) : (str))
#define STR_EXISTS(str)                                 ((str) ? (str) : (@""))

//------ begin 私密信息需要用keyChain存储------//
//USER_ID
#define EC_USER_ID                          @"EC_USER_ID"
//用户电话号码
#define EC_PHONE                            @"EC_PHONE"
//USERINFO_ID
#define EC_USERINFO_ID                      @"USERINFO_ID"
//secret
#define EC_SECRET                           @"EC_SECRET"
//登录名
#define EC_USER_LOGINNAME                   @"EC_USER_LOGINNAME"
//------ end   私密信息需要用keyChain存储------//


//判断用户是否登录
#define EC_USER_WHETHERLOGIN                [USERDEFAULT boolForKey:EC_ISLOGIN_FLAG]



//------ begin 使用userdefault存储-----------//
//年龄
#define EC_USER_AGE                         @"EC_USER_AGE"
//性别
#define EC_USER_SEX                         @"EC_USER_SEX"
//用户名
#define EC_USER_NICKNAME                    @"EC_USER_NICKNAME"
//头像地址
#define EC_USER_HEAD_IMAGE                  @"EC_USER_HEAD_IMAGE"
//DISSTATE
#define EC_USER_DISSTATE                    @"EC_USER_DISSTATE"
//用户自己的Q码,
#define EC_USER_DISCODE                     @"EC_USER_DISCODE"
//ISDIS
#define EC_USER_ISDIS                       @"EC_USER_ISDIS"
//PARENTDISCODE
#define EC_USER_PARENTDISCODE               @"EC_USER_PARENTDISCODE"
//"1"  #是否设置支付密码0-未1-有
#define EC_USER_ISSETPAYWD                  @"EC_USER_ISSETPAYWD"
//用户身份 0-普通用户 1-VIP用户 2-设计师
#define EC_USER_STATUS                      @"EC_USER_STATUS"
//记录是否已经登录
#define EC_ISLOGIN_FLAG                     @"EC_ISLOGIN_FLAG"


//用户是否允许接收推送消息
#define EC_ALLOW_RECEIVE_PUSH               @"EC_ALLOW_RECEIVE_PUSH"


//------ end  使用userdefault存储-----------//



#endif /* CMUtilsMacro_h */
