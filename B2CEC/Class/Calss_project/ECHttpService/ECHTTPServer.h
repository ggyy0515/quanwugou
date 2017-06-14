//
//  ECHTTPServer.h
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECHTTPServer : NSObject

/**
 *  读取api版本号
 *
 *  @return 字符串对象
 */
+ (NSString *)loadApiVersion;

/**
 请求发送短信验证码

 @param phoneNumber 手机号
 @param succeed
 @param failed 
 */
+ (void)requestSendAuthcodeMessageWithMobileNumber:(NSString *)phoneNumber
                                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 登录

 @param userName 用户名
 @param password 密码
 @param succeed
 @param failed
 */
+ (void)requestLoginWithUserName:(NSString *)userName
                        password:(NSString *)password
                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 注册

 @param userName 账号
 @param password 密码
 @param verficationCode 验证码
 @param succeed
 @param failed
 */
+ (void)requestRegisterWithUserName:(NSString *)userName
                       WithPassword:(NSString *)password
                WithVerficationCode:(NSString *)verficationCode
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 重置密码时验证手机号

 @param mobile 手机号
 @param verfication 验证码
 @param succeed
 @param failed
 */
+ (void)requestVailMobileWithMobile:(NSString *)mobile
                    WithVerfication:(NSString *)verficationCode
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 重置密码

 @param mobile 手机号
 @param password 密码
 @param succeed
 @param failed
 */
+ (void)requestResetPasswordWithMobile:(NSString *)mobile
                          WithPassword:(NSString *)password
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 QQ登录

 @param uid QQ  Uid
 @param iconUrl QQ  Iconurl
 @param name QQ name
 @param succeed
 @param failed
 */
+ (void)requestQQLoginWithUid:(NSString *)uid
                  WithIconurl:(NSString *)iconUrl
                     WithName:(NSString *)name
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 微信登录

 @param uid 微信  UID
 @param iconUrl 微信 iconurl
 @param name 微信  name
 @param succeed
 @param failed
 */
+ (void)requestWeixinLoginWithUid:(NSString *)uid
                      WithIconurl:(NSString *)iconUrl
                         WithName:(NSString *)name
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 第三方登录绑定手机

 @param qqUid QQ的唯一ID
 @param weixinUid wx的唯一ID，跟QQ的两者比传一个
 @param mobile 绑定手机号
 @param password 密码
 @param code 验证码
 @param iconUrl 第三方头像地址
 @param name 第三方昵称
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestBindMobileWithQQUid:(NSString *)qqUid
                     WithWeixinUid:(NSString *)weixinUid
                         WithMobil:(NSString *)mobile
                      WithPassword:(NSString *)password
                          WithCode:(NSString *)code
                       WithIconurl:(NSString *)iconUrl
                          WithName:(NSString *)name
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 请求商城首页数据

 @param city 定位或者用户选择的城市名称
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMallIndexInfoWithCity:(NSString *)city
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 *  请求基础配置参数
 *
 *  @param succeed <#succeed description#>
 *  @param failed  <#failed description#>
 */
+ (void)requestBaseDataSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 根据经纬度获取当前城市名

 @param lng 经度
 @param lat 纬度
 @param succeed
 @param failed
 */
+ (void)requestCityNameWithLng:(double)lng
                           lat:(double)lat
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取城市列表数据

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCityListSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取用户自定义资讯分类

 @param succeed
 @param failed
 */
+ (void)requestUserNewsTypeSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取所有咨询分类

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAllNewsTypeSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取资讯列表内容

 @param type l资讯的类型编码，如INFORMATION_TOUTIAO；如果是城市的编码，则在编码后面添加城市名称，如INFORMATION_CHENGSHI深圳
 @param pageindex 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsDataWithType:(NSString *)type
                  WithPageIndex:(NSInteger)pageindex
                        Succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 保存用户自定义编码

 @param typeStr 分类1的编码,分类2的编码,...";字典的编码按顺序用逗号拼接
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSaveUserNewsType:(NSString *)typeStr
                        Succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取筛选条件

 @param houseCode 场馆编号
 @param catCode 产品分类编号
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestFilterDataWithHouseCode:(NSString *)houseCode
                               catCode:(NSString *)catCode
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取商城产品列表

 @param pageNumber 页码
 @param catCode 大分类编码
 @param attrs 筛选字段和值，为json数组格式的字符串。如：[{"attrcode":"对应的属性编码","attrvalue":"选中的属性值"}]
 @param secondType 二级分类编码
 @param houseCode 场馆编码
 @param minPrice 最小价格
 @param maxPrice 最大价格
 @param sortType 排序字段，默认是时间排序，可传销量（salenumber）和价格（price）
 @param sortDescType 排序方式，可选值：asc（升序），desc（降序)
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestProductListWithPageNumber:(NSInteger)pageNumber
                                 catCode:(NSString *)catCode
                                   attrs:(NSString *)attrs
                              secondType:(NSString *)secondType
                               houseCode:(NSString *)houseCode
                                minPrice:(NSString *)minPrice
                                maxPrice:(NSString *)maxPrice
                                sortType:(NSString *)sortType
                            sortDescType:(NSString *)sortDescType
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 获取抢购商品列表

 @param pageNumber 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPanicBuyListWithPageNumber:(NSInteger)pageNumber
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 评论资讯
 
 @param newsID 资讯ID
 @param comment 评论内容
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsSendCommentWithNewsID:(NSString *)newsID
                             WithComment:(NSString *)comment
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取资讯详情
 
 @param bianma 编码
 @param newsID ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsInfoWithBianma:(NSString *)bianma
                       WithNewsID:(NSString *)newsID
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 收藏资讯
 
 @param newsID 资讯ID
 @param succeed
 @param failed
 */
+ (void)requestNewsCollectWithNewsID:(NSString *)newsID
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 请求商品详情
 @param newsID 资讯ID
 @param pageIndex 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsCommentWithNewsID:(NSString *)newsID
                       WithPageIndex:(NSInteger)pageIndex
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取资讯评论列表
 
 @param proTable 产品对应分类表
 @param proId 产品id
 @param userId 用户id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestProductDetailWithProTable:(NSString *)proTable
                                   proId:(NSString *)proId
                                  userId:(NSString *)userId
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取资讯富文本

 @param newsID 资讯ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsAttrInfoWithNewsID:(NSString *)newsID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 请求商品评价列表

 @param pageNumber 页码
 @param proId 商品id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestProductAppraiseListWithPageNumber:(NSInteger)pageNumber
                                           proId:(NSString *)proId
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 资讯点赞和倒彩接口

 @param type 1-点赞 2-倒彩
 @param newsID 资讯的id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsPraiseWithType:(NSString *)type
                       WithNewsID:(NSString *)newsID
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 同系列产品推荐

 @param protable 产品表关键字
 @param serise 产品系列,在产品详情中有这个字段
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMoreProductListWithProtable:(NSString *)protable
                                    serise:(NSString *)serise
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 资讯根据标题搜索列表
 
 @param key 搜索内容
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestNewsSearchWithSearchKey:(NSString *)key
                         WithPageIndex:(NSInteger)pageIndex
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 请求收藏商品

 @param protable 表名
 @param proId 商品id
 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCollectProductWithProtable:(NSString *)protable
                                    proId:(NSString *)proId
                                   userId:(NSString *)userId
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 查询购物车中商品的数量

 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCartNumberWithUserId:(NSString *)userId
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 加入购物车

 @param userId userId
 @param proId 商品id
 @param protable 表名
 @param count 数量
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAddToCartWithUserId:(NSString *)userId
                             proId:(NSString *)proId
                          protable:(NSString *)protable
                             count:(NSInteger)count
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 添加收货地址
=======
 @param name 收货人
 @param phone 手机号码
 @param address 地区
 @param addressDetail 详细地址
 @param isDefauls 是否设置为默认收货地址 1 是 / 0 否 ，添加第一个地址时，后台自动设为默认收货地址
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAddAddressWithName:(NSString *)name
                        WithPhone:(NSString *)phone
                      WithAddress:(NSString *)address
                WithAddressDetail:(NSString *)addressDetail
                      WithDefauls:(BOOL)isDefauls
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 请求购物车列表
 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCartListWithUserId:(NSString *)userId
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 删除购物车中的商品

 @param cartIdString 删除指定的购物车数据
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteCartProductsWithCartIdString:(NSString *)cartIdString
                                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;




/**
 分页获取收货地址列表

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAddressListsucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 设为默认收货地址

 @param addressID 收货地址ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSetDefaultsAddressWithAddressID:(NSString *)addressID
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 删除/ 批量删除 收货地址

 @param addressID 需要删除的收货地址ID，如有多个，用英文逗号分隔开。如 ‘111,222,333’
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteAddressWithAddressID:(NSString *)addressID
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 修改收货地址

 @param addressID 收货地址ID
 @param name 收货人
 @param phone 手机号码
 @param address 地区
 @param addressDetail 详细地址
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestEditAddressWithAddressID:(NSString *)addressID
                               WithName:(NSString *)name
                              WithPhone:(NSString *)phone
                            WithAddress:(NSString *)address
                      WithAddressDetail:(NSString *)addressDetail
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取我的首页

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMineDatasucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 搜索商品

 @param keyword 关键字
 @param sortType 排序方式
 @param sortDescType 升序降序
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSearchProductWithKeyword:(NSString *)keyword
                               sortType:(NSString *)sortType
                           sortDescType:(NSString *)sortDescType
                                pageNum:(NSInteger)pageNum
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 修改购物车中单个商品的数量

 @param cartId 购物车id
 @param count 数量
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestModifyCartSingleProductCountWithCartId:(NSString *)cartId
                                                count:(NSString *)count
                                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 上传文件

 @param filesData 文件数组
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestUploadFileWithFilesData:(NSArray *)filesData
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 批量修改购物车中的商品数量

 @param paramString json串,比如:[{"PROQTY":5,"ORD_CART_ID":"0580eed524ca4a719dcf2ae883093f15"},{"PROQTY":6,"ORD_CART_ID":"10fb6548ce9f48209c4644bd06f07f3d"}]
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestModifyCartProductCountWithParamString:(NSString *)paramString
                                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 申请成为设计师

 @param name 姓名
 @param sex 性别（男/女）
 @param birth 生日
 @param province 省信息（广东省）
 @param city 市信息（深圳市）
 @param nativeplace 籍贯
 @param profession 职业
 @param school 院校
 @param email 邮箱
 @param phone 手机号
 @param company 公司
 @param obtainyears 从业年限
 @param charge 收费标准
 @param resume 个人简介
 @param experience 工作经验
 @param headImgUrl 设计师头像路径
 @param certificateImgUrls 证书图片路径（含多个），采用数组形式
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestApplyDesingerWithUserID:(NSString *)userid
                              WithName:(NSString *)name
                               WithSex:(NSString *)sex
                             WithBirth:(NSString *)birth
                          WithProvince:(NSString *)province
                              WithCity:(NSString *)city
                       WithNativeplace:(NSString *)nativeplace
                        WithProfession:(NSString *)profession
                            WithSchool:(NSString *)school
                             WithEmail:(NSString *)email
                             WithPhone:(NSString *)phone
                           WithCompany:(NSString *)company
                       WithObtainyears:(NSString *)obtainyears
                            WithCharge:(NSString *)charge
                             WithStyle:(NSString *)style
                            WithResume:(NSString *)resume
                        WithExperience:(NSString *)experience
                        WithHeadImgUrl:(NSString *)headImgUrl
                WithCertificateImgUrls:(NSString *)certificateImgUrls
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 查询Q码是否存在

 @param QCode Q码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCheckQCode:(NSString *)QCode
                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取注册设计师的资料
 
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetDesignersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 验证密码是否正确

 @param loginPassword 登录密码
 @param payPassword 支付密码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestValidPasswordWithLoginPassword:(NSString *)loginPassword
                              WithPayPassword:(NSString *)payPassword
                                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 修改登录/支付密码

 @param newPassword 新密码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestChangePasswordWithLoginPassword:(NSString *)loginPassword
                               WithPayPassword:(NSString *)payPassword
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 验证验证码是否正确

 @param phone 手机号码
 @param code 验证码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestValidAuthCodeWithPhone:(NSString *)phone
                             WithCode:(NSString *)code
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 更改绑定手机号

 @param mobile 新手机号码
 @param code 验证码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestChangeMobileWithMobile:(NSString *)mobile
                             WithCode:(NSString *)code
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 验证手机号是否存在(用于更改绑定手机号码)

 @param phone 手机号码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestValidPhoneExistWithPhone:(NSString *)phone
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 关注资讯

 @param newsID zixunID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestFocusNewsWithNewsID:(NSString *)newsID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取个人资料

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetUserInfoWithUserID:(NSString *)userid
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取关注列表

 @param userID <#userID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestFocusWithUserID:(NSString *)userID
                 WithPageIndex:(NSInteger)pageIndex
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取粉丝列表

 @param userID <#userID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestFansWithUserID:(NSString *)userID
                WithPageIndex:(NSInteger)pageIndex
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 在关注列表、粉丝列表点击关注操作

 @param userID 对方的id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestFocusAndFansFocusWithUserID:(NSString *)userID
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 查询用户资料

 @param userID <#userID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSelectUserInfoWithUserID:(NSString *)userID
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 修改普通用户资料

 @param userInfoID 用户信息ID
 @param headImage 头像路径
 @param birth 生日
 @param sex 性别。男/女
 @param name 昵称
 @param address 籍贯
 @param email 邮箱
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestUpdateUserInfoWithUserInfoID:(NSString *)userInfoID
                              WithHeadImage:(NSString *)headImage
                                  WithBirth:(NSString *)birth
                                    WithSex:(NSString *)sex
                                   WithName:(NSString *)name
                                WithAddress:(NSString *)address
                                  WithEmail:(NSString *)email
                                    succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                     failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 通过购物车提交订单

 @param userId userid
 @param cartInfo 购物车的ID和是否分期的json串.iseasypay是否分期:0-不分期,1-分期.比如[{"cart_id":"132456455","iseasypay":"0"},{"cart_id":"132456456","iseasypay":"1"}]
 @param addressId 收货地址的ID
 @param totalPrice 前台计算的订单总额
 @param nowPay 前台计算的订单现在需要支付的金额
 @param isDiscount 当为1时表示使用了Q码打折,0或者不传表示不打折
 @param qcode Q码,isdiscount为1时必须传入
 @param billTitle 发票抬头,需要发票时直接传入此字段即可
 @param message 用户留言,json对象,[{"工厂ID":"给该工厂的留言"}]
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCartCommitOrderWithUserId:(NSString *)userId
                                cartInfo:(NSString *)cartInfo
                               addressId:(NSString *)addressId
                              totalPrice:(NSString *)totalPrice
                                  nowPay:(NSString *)nowPay
                              isDiscount:(NSString *)isDiscount
                                   qcode:(NSString *)qcode
                               billTitle:(NSString *)billTitle
                                 message:(NSString *)message
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;




/**
 立即购买提交订单

 @param userId userId
 @param addressId addressId
 @param totalPrice 前台计算的订单总额
 @param nowPay 前台计算的订单现在需要支付的金额
 @param isDiscount 当为1时表示使用了Q码打折,0或者不传表示不打折
 @param qcode Q码,isdiscount为1时必须传入
 @param billTitle 发票抬头,需要发票时直接传入此字段即可
 @param message 用户留言,json数组,[{"工厂ID":"给该工厂的留言"}]
 @param protable 表名关键字
 @param proId 产品ＩＤ
 @param count 购买数量
 @param isEasyPay 是否分期
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCommitOrderWithUserId:(NSString *)userId
                         addressInfo:(NSString *)addressId
                          totalPrice:(NSString *)totalPrice
                              nowPay:(NSString *)nowPay
                          isDiscount:(NSString *)isDiscount
                               qcode:(NSString *)qcode
                           billTitle:(NSString *)billTitle
                             message:(NSString *)message
                            protable:(NSString *)protable
                               proId:(NSString *)proId
                               count:(NSString *)count
                           isEasyPay:(NSString *)isEasyPay
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取发布作品时的类型

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetPostWorksTypesucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/*
 待付款：  For_the_payment
 （待接单： daijiedan
 工厂接单： gongchangjiedan
 生产完成：shengchanwancheng
 待付尾款：daifuweikuan）
 
 
 待发货：   To_send_the_goods
 待收货：   For_the_goods
 待评价：  For_the_Comment
 完成：  Complete
 退货：  Return
 (已退货： Have_To_Return
 退货中： In_Return)
 */
/**
 请求订单列表

 @param pageNumber 页码
 @param userId userId
 @param state 订单状态编码,多个状态码用逗号分开 如"aa,bb"
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestOrderListWithPageNumber:(NSInteger)pageNumber
                                userId:(NSString *)userId
                                 state:(NSString *)state
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 发布作品

 @param userID 用户ID
 @param style 风格
 @param type 作品类型
 @param houseType 房屋类型
 @param title 标题
 @param cover 封面图片
 @param content 正文内容
 @param top 0/1(0-不推到首页1-推倒首页)
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSubmitWorksWithUserID:(NSString *)userID
                           WithStyle:(NSString *)style
                            WithType:(NSString *)type
                       WithHouseType:(NSString *)houseType
                           WithTitle:(NSString *)title
                           WithCover:(NSString *)cover
                         WithContent:(NSString *)content
                             WithTop:(BOOL)top
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 发表日志
 @param title <#title description#>
 @param image <#image description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestSubmitLogsWithTitle:(NSString *)title
                         WithImage:(NSString *)image
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 确认收货
 @param orderId 订单id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestConfirmReceiveWithOrderId:(NSString *)orderId
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取文章列表

 @param userID <#userID description#>
 @param pageIndex <#pageIndex description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestArticleListWithUserID:(NSString *)userID
                       WithPageIndex:(NSInteger)pageIndex
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 取消订单/批量取消订单
 @param orderId 要取消的订单id，多个订单用逗号分开，如"aa,bb"
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCancleOrderWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取用户日志列表
 @param userID <#userID description#>
 @param pageIndex <#pageIndex description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestLogsListWithUserID:(NSString *)userID
                    WithPageIndex:(NSInteger)pageIndex
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 删除订单/批量删除订单
 @param orderId 要删除的订单id，多个订单用逗号分开，如"aa,bb"
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteOrderWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 我的收藏
 @param type 类型（1-产品，2-资讯，3-分享文（案例） ，4-素材）
 @param pageindex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMyCollectWithType:(NSInteger)type
                   WithPageIndex:(NSInteger)pageindex
                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 *  获取快递100接口
 *
 *  @param com      快递公司代码
 *  @param orderNum 快递订单号
 *  @param succeed  <#succeed description#>
 *  @param failed   <#failed description#>
 */
+ (void)requestExpressDeliveryWithCom:(NSString *)com
                          OrderNumber:(NSString *)orderNum
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 批量删除收藏

 @param collectID 要删除的收藏ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestChangeMyCollectStateWithCollectID:(NSString *)collectID
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 请求订单详情
 @param orderId orderId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestOrderDetailWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 服务与反馈

 @param content <#content description#>
 @param phone <#phone description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPostFeebackWithContent:(NSString *)content
                            WithPhone:(NSString *)phone
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取设计作品列表

 @param style 作品的风格
 @param type 作品的类型
 @param house 作品的房屋类型
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerCaseListWithStyle:(NSString *)style
                                WithType:(NSString *)type
                               WithHouse:(NSString *)house
                               WithOrder:(NSString *)order
                           WithPageIndex:(NSInteger)pageIndex
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取设计列表数据

 @param userID 当前登录用户ID
 @param orderBy 排序参数（FANS_COUNT、WORK_COUNT、ATTENTION_COUNT
 @param city 城市
 @param style 风格类型
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerListWithOrderBy:(NSString *)orderBy
                              WithCity:(NSString *)city
                             WithStyle:(NSString *)style
                         WithPageIndex:(NSInteger)pageIndex
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取用户团队列表
 
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestTeamUsersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取某个下线团队列表
 
 @param collectID 下线用户ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestTeamDetailWithUserID:(NSString *)userID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 删除某个下线
 
 @param collectID 下线用户ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestTeamDeleteWithUserID:(NSString *)userID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取作品详情
 
 @param collectID 作品ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWorksDetailWithWorksID:(NSString *)worksID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 对文章或者案例点赞或者倒彩
 
 @param collectID 类型1-点赞 2-倒彩
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWorksPraiseWithType:(NSString *)type
                       WithWorksID:(NSString *)worksID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 收藏案例或者文章
 
 @param collectID 收藏的案例或者文章ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWorksCollectWithWorksID:(NSString *)worksID
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取作品评论

 @param worksID 文章ID
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetWorksCommentWithWorksID:(NSString *)worksID
                            WithPageIndex:(NSInteger)pageIndex
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 对作品(文章)进行评论

 @param worksID 作品或者文章ID
 @param content 评论内容
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWorksSendCommentWithWorksID:(NSString *)worksID
                               WithContent:(NSString *)content
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 申请退货

 @param userId userId
 @param orderId orderId
 @param reason 原因
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestReturnGoodWithUserId:(NSString *)userId
                            orderId:(NSString *)orderId
                             reason:(NSString *)reason
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 评价订单

 @param orderId 订单id
 @param userId userId
 @param productIdArray 商品id数组
 @param commentArray 评论内容数组
 @param starLevelArray 评分数组
 @param imageListArray 装有每个商品图片路径数组的数组
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCommitCommentWithOrderId:(NSString *)orderId
                                 userId:(NSString *)userId
                         productIdArray:(NSArray <NSString *> *)productIdArray
                           commentArray:(NSArray <NSString *> *)commentArray
                         starLevelArray:(NSArray <NSString *> *)starLevelArray
                         imageListAttay:(NSArray <NSArray *> *)imageListArray
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取设计师的评价列表

 @param userID 用户ID
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestUserInfoCommentListWithUserID:(NSString *)userID
                               WithPageIndex:(NSInteger)pageIndex
                                     succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                      failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 查询我的钱包首页内容

 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMyWalletInfoWithUserId:(NSString *)userId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 请求用户资金流水账列表

 @param userId userId
 @param pageNumber 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestUserAccountBillWithUserId:(NSString *)userId
                              pageNumber:(NSInteger)pageNumber
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 使用钱包支付订单

 @param orderNum 订单号,多个订单号之间用逗号隔开
 @param amount 支付金额
 @param type 类型:nowpay-订单支付,leftpay-尾款支付,designpay-设计订单支付
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPayOrderUseWalletWithOrderNum:(NSString *)orderNum
                                      amount:(NSString *)amount
                                        type:(NSString *)type
                                     succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                      failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 请求支付宝签名

 @param body 订单附加信息
 @param orderNo 订单号,多个订单号用逗号分割,如果是设计订单传设计订单的ID
 @param amount 金额
 @param type 类型:nowpay-订单支付,leftpay-尾款支付,designpay-设计订单支付
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAliSignWithBody:(NSString *)body
                       orderNo:(NSString *)orderNo
                        amount:(NSString *)amount
                          type:(NSString *)type
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 请求微信签名
 
 @param body 订单附加信息
 @param orderNo 订单号,多个订单号用逗号分割,如果是设计订单传设计订单的ID
 @param amount 金额
 @param type 类型:nowpay-订单支付,leftpay-尾款支付,designpay-设计订单支付
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWxSignWithBody:(NSString *)body
                      orderNo:(NSString *)orderNo
                       amount:(NSString *)amount
                         type:(NSString *)type
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 根据经度纬度获取地址

 @param lat 纬度
 @param lng 经度
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetAddressByLatWithLat:(CGFloat)lat
                              WithLng:(CGFloat)lng
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 提交设计师订单

 @param designer_id 设计师用户ID
 @param user_id 用户ID
 @param describe 简单描述
 @param housearea 房屋面积
 @param location 具体位置
 @param lng 经度
 @param lat 纬度
 @param housetype 房屋类型（传编码值）
 @param decoratetype 装修户型（传编码值）
 @param style 期望风格（传编码值
 @param claim 具体要求
 @param imgurls 具体要求中上传的图片(json数组格式)
 @param cycle 完成周期/时间
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPostDesignerOrderWithdesigner_id:(NSString *)designer_id
                                        user_id:(NSString *)user_id
                                       describe:(NSString *)describe
                                      housearea:(NSString *)housearea
                                       location:(NSString *)location
                                            lng:(CGFloat)lng
                                            lat:(CGFloat)lat
                                      housetype:(NSString *)housetype
                                   decoratetype:(NSString *)decoratetype
                                          style:(NSString *)style
                                          claim:(NSString *)claim
                                        imgurls:(NSString *)imgurls
                                          cycle:(NSString *)cycle
                                        succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 请求银联签名

 @param userId userId
 @param orderNo 订单号,多个订单号用逗号分割,如果是设计订单传设计订单的ID
 @param amount 金额
 @param type 类型:nowpay-订单支付,leftpay-尾款支付,designpay-设计订单支付
 @param succeed {
 "tn": "1231234"  #银联订单号,
 "mode": "00"  #01为测试环境，00为生产环境,
 "code": "10000",
 "msg": "获取成功"
 }
 @param failed <#failed description#>
 */
+ (void)requestUnionPaySignWithUserId:(NSString *)userId
                              orderNo:(NSString *)orderNo
                               amount:(NSString *)amount
                                 type:(NSString *)type
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 请求尾货商品列表

 @param pageNum 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestLeftProductListWithPageNum:(NSInteger)pageNum
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取品牌故事内容

 @param proId <#proId description#>
 @param protable <#protable description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestBrandStoryWithProId:(NSString *)proId
                          protable:(NSString *)protable
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
/**
 获取设计订单列表数据通过不同的订单状态

 @param state 订单状态(多种状态用逗号分割)
 @param pageIndex 页数
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderListWithState:(NSString *)state
                            WithPageIndex:(NSInteger)pageIndex
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 修改设计订单数据

 @param designer_id <#designer_id description#>
 @param describe <#describe description#>
 @param housearea <#housearea description#>
 @param location <#location description#>
 @param lng <#lng description#>
 @param lat <#lat description#>
 @param housetype <#housetype description#>
 @param decoratetype <#decoratetype description#>
 @param style <#style description#>
 @param claim <#claim description#>
 @param imgurls <#imgurls description#>
 @param cycle <#cycle description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestUpdateDesignerOrderWithOrder_id:(NSString *)orderID
                                      describe:(NSString *)describe
                                     housearea:(NSString *)housearea
                                      location:(NSString *)location
                                           lng:(CGFloat)lng
                                           lat:(CGFloat)lat
                                     housetype:(NSString *)housetype
                                  decoratetype:(NSString *)decoratetype
                                         style:(NSString *)style
                                         claim:(NSString *)claim
                                       imgurls:(NSString *)imgurls
                                         cycle:(NSString *)cycle
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 用户取消设计订单/设计师婉拒订单

 @param designerID 设计订单ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCancelDesignerOrder:(NSString *)orderID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取设计订单中的房屋类型、 装修户型、期望风格的数据

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetDesignerOrderStyleDatasucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 出价订单

 @param designerID 	设计订单ID
 @param money 出价金额
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderOfferWithID:(NSString *)orderID
                              WithMoney:(CGFloat)money
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 设计订单零钱支付

 @param orderID 订单ID
 @param money <#money description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderWalletPayWithID:(NSString *)orderID
                                  WithMoney:(NSString *)money
                                    succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                     failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 设计师点击确定完工或者用户点击确定完工

 @param orderID <#orderID description#>
 @param state 状态值( 设计师点击确定完工：Designer_complate 用户点击： daipingjia )
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderCompleteWithOrderID:(NSString *)orderID
                                      WithState:(NSString *)state
                                        succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 用户点击退款

 @param orderID <#orderID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderReturnMoney:(NSString *)orderID
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 评价设计订单

 @param orderID <#orderID description#>
 @param comment <#comment description#>
 @param star <#star description#>
 @param imgUrls <#imgUrls description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderComment:(NSString *)orderID
                        WithComment:(NSString *)comment
                           WithStar:(NSString *)star
                        WithImgUrls:(NSString *)imgUrls
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取设计订单详情

 @param orderID <#orderID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerOrderDetail:(NSString *)orderID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取素材列表

 @param style 风格参数（筛选条件）
 @param type 类型参数（筛选条件）
 @param order 排序方式
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestMaterialLibraryWithStyle:(NSString *)style
                               WithType:(NSString *)type
                              WithOrder:(NSString *)order
                          WithPageIndex:(NSInteger)pageIndex
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 收藏素材

 @param libID 收藏的素材ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCollectMaterialLibrary:(NSString *)libID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 设计中搜索（包括设计师、案例、素材）

 @param type 1、2、3（1-设计师2-案例-3-素材）
 @param key <#key description#>
 @param pageIndex <#pageIndex description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDesignerSearchWithtype:(NSInteger)type
                              WithKey:(NSString *)key
                        WithPageIndex:(NSInteger)pageIndex
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取用户积分

 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointInfoWithUserId:(NSString *)userId
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取设计师的积分和零钱的兑换比例

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointToMoneyRateSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 积分流水账

 @param pageNum 页码
 @param userId userId
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointBillListWithPageNum:(NSInteger)pageNum
                                 userId:(NSString *)userId
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 积分商品列表

 @param pageNumber 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointProductListWithPageNumber:(NSInteger)pageNumber
                                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 积分商品详情

 @param proId 商品id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointProductDetailWithProId:(NSString *)proId
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 提交积分商城订单

 @param userId userId
 @param proId ProId
 @param addressId 收货地址ID
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCommitPointOrderWithUserId:(NSString *)userId
                                    proId:(NSString *)proId
                                addressId:(NSString *)addressId
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取分享注册的URL

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetShareRegistersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 查询积分订单列表

 @param userId userId
 @param pageNumber 页码
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointOrderListWithUserId:(NSString *)userId
                             pageNumber:(NSInteger)pageNumber
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 积分订单详情

 @param orderId 积分订单id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPointOrderDetailWithOrderId:(NSString *)orderId
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 获取添加银行卡时可选择的银行列表

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestBankListSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 绑定银行卡

 @param userId userId
 @param cardHolder 持卡人姓名
 @param cardNo 卡号
 @param province 省
 @param city 市
 @param bankId 银行id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestbindBankCardWithUserId:(NSString *)userId
                           cardHolder:(NSString *)cardHolder
                               cardNo:(NSString *)cardNo
                             province:(NSString *)province
                                 city:(NSString *)city
                               bankId:(NSString *)bankId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 解除绑定银行卡

 @param cardId 银行卡主键
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteBankCardWithCardId:(NSString *)cardId
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 零钱提现

 @param userId userId
 @param amount 金额
 @param bankCardId 银行id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestWalletBalanceTakeMoneyWithUserId:(NSString *)userId
                                         amount:(NSString *)amount
                                     bankCardId:(NSString *)bankCardId
                                        succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 积分提现(设计师将积分转换成零钱)

 @param userId userId
 @param point point
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestTakePointWithUserId:(NSString *)userId
                             point:(NSString *)point
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取通知列表

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestPushList:(NSInteger)pageIndex
                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;


/**
 获取聊天用户列表的信息

 @param userIdArray <#userIdArray description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestChatListUserInfoWithUserIdArray:(NSArray *)userIdArray
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 批量收藏产品

 @param info <#info description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestCollectMoreProductWithInfo:(NSString *)info
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 获取注册设计师的职业列表

 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestGetDesignerJobsucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 举报资讯或者案例

 @param type 1-资讯，2-案例 ）
 @param infoID 资讯或者案例的ID
 @param content 举报内容
 @param category 举报类型（传编码值）侵权，非法
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestReportWithType:(NSInteger)type
                       WithID:(NSString *)infoID
                  WithContent:(NSString *)content
                 WithCategory:(NSString *)category
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 查看订单评价数据

 @param orderID <#orderID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestOrderCommentListWithOrderID:(NSString *)orderID
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 用户删除案例

 @param workdsID <#workdsID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteUserWorksWithID:(NSString *)workdsID
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;

/**
 用户删除日志
 
 @param workdsID <#workdsID description#>
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestDeleteUserLogsWithID:(NSString *)logsID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;



/**
 增加视频播放次数

 @param infomationId 资讯id
 @param succeed <#succeed description#>
 @param failed <#failed description#>
 */
+ (void)requestAddVideoPlayCountWithInfomationId:(NSString *)infomationId
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed;
@end
