//
//  ECHTTPServer.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECHTTPServer.h"

@implementation ECHTTPServer

+ (NSString *)loadApiVersion {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *apiVersion = [[version componentsSeparatedByString:@"."] firstObject];
    NSString *apiVersionStr = [NSString stringWithFormat:@"api/v%@", apiVersion];
    return apiVersionStr;
}

/**
 创建SessionManager
 
 @param isNeedAuthInfo 是否需要鉴权
 @param paramDic 参数信息
 @return manager 实例
 */
+ (AFHTTPSessionManager *)shareManagerWithAuthInfo:(BOOL)isNeedAuthInfo
                                          paramDic:(NSDictionary *)paramDic {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    if (isNeedAuthInfo) {
        //set token
        NSString *token = [Keychain objectForKey:EC_USER_ID];
        if ([token isEqualToString:@""]) {
            [APP_DELEGATE.logServer insertDetailTableWithInterface:NSStringFromClass([self class])
                                                              type:type_error
                                                              text:@"token 为空字符串, keychain存储失败"];
        }
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
        //set timeStamp
        NSDateFormatter *dateFt = [[NSDateFormatter alloc] init];
        [dateFt setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateStr = [dateFt stringFromDate:[NSDate date]];
        [manager.requestSerializer setValue:dateStr forHTTPHeaderField:@"timestamp"];
        //set secret
        NSString *secret = [Keychain objectForKey:EC_SECRET];
        NSString *allstr = [NSString stringWithFormat:@"%@ %@", token, secret];
        NSString *secretMD5 = [NSString getMd5_32Bit_String:allstr];
        NSString *secretBase64 = [secretMD5 base64EncodedString];
        [manager.requestSerializer setValue:secretBase64 forHTTPHeaderField:@"secret"];
    }
    
    /**
     * 客户端和服务端各保存一份相同的密钥，客户端请求服务端接口时，
     * 生成签名，由服务端验证。统一使用post请求
     * 签名规则：
     * 1.将所有请求参数的key值从小到大进行排序并拼接成字符串str，key1=value1&key2=value2的形式
     * 2.获取当前系统时间timestamp，拼接到str的尾部
     * 3.将密钥拼接到str尾部
     * 4.使用md5加密str，生成签名signStr
     * 5.将timestamp和signStr放入Header中，命名为timestamp和signStr
     *
     * 服务端将取到他请求头中的参数，按照同样的算法生成签名进行对比。
     *
     */
    
    //1.获取所有key，排序，拼接
    NSMutableArray <NSString *> *keyArray = [paramDic allKeys].mutableCopy;
    [keyArray sortUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *signStr = [NSMutableString string];
    [keyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signStr appendString:obj];
        [signStr appendString:@"="];
        [signStr appendString:[paramDic objectForKey:obj]];
        if (idx != paramDic.count - 1) {
            [signStr appendString:@"&"];
        }
    }];
    //2.追加timeStamp
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", [@([[NSDate date] timeIntervalSince1970] * 1000) longValue]];
    [signStr appendString:timeStamp];
    //3.追加密钥
    [signStr appendString:@"1234567890"];
    //4.md5加密sign
    NSString *md5Sign = [NSString getMd5_32Bit_String:signStr];
    //5.设置请求头
    [manager.requestSerializer setValue:timeStamp forHTTPHeaderField:@"timestamp"];
    [manager.requestSerializer setValue:md5Sign forHTTPHeaderField:@"signStr"];
    
    //https配置-------------//
    //证书路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"tomcat" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObjects:cerData, nil]];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    
    return manager;
}

+ (void)requestSendAuthcodeMessageWithMobileNumber:(NSString *)phoneNumber
                                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/authcode", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"mobile":phoneNumber};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestLoginWithUserName:(NSString *)userName
                        password:(NSString *)password
                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/login", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USERNAME":userName,
                               @"PASSWORD":[NSString getMd5_32Bit_String:password]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestRegisterWithUserName:(NSString *)userName
                       WithPassword:(NSString *)password
                WithVerficationCode:(NSString *)verficationCode
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/register", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"PHONE":userName,
                               @"PASSWORD":[NSString getMd5_32Bit_String:password],
                               @"AUTHCODE":verficationCode
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestVailMobileWithMobile:(NSString *)mobile
                    WithVerfication:(NSString *)verficationCode
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/valiUserPhone", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"PHONE":mobile,
                               @"AUTHCODE":verficationCode
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestResetPasswordWithMobile:(NSString *)mobile
                          WithPassword:(NSString *)password
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/resetPassword", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"PHONE":mobile,
                               @"PASSWORD":[NSString getMd5_32Bit_String:password]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestQQLoginWithUid:(NSString *)uid
                  WithIconurl:(NSString *)iconUrl
                     WithName:(NSString *)name
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/qqlogin", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"qqunionId":uid.length == 0 ? @"" : uid,
                               @"iconURL":iconUrl.length == 0 ? @"" : iconUrl,
                               @"nickName":name.length == 0 ? @"" : name
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWeixinLoginWithUid:(NSString *)uid
                      WithIconurl:(NSString *)iconUrl
                         WithName:(NSString *)name
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/wxlogin", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"wxunionId":uid.length == 0 ? @"" : uid,
                               @"iconURL":iconUrl.length == 0 ? @"" : iconUrl,
                               @"nickName":name.length == 0 ? @"" : name
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestBindMobileWithQQUid:(NSString *)qqUid
                     WithWeixinUid:(NSString *)weixinUid
                         WithMobil:(NSString *)mobile
                      WithPassword:(NSString *)password
                          WithCode:(NSString *)code
                       WithIconurl:(NSString *)iconUrl
                          WithName:(NSString *)name
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/bindingPhone", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"qqunionId":qqUid.length == 0 ? @"" : qqUid,
                               @"wxunionId":weixinUid.length == 0 ? @"" : weixinUid,
                               @"PHONE":mobile,
                               @"PASSWORD":password,
                               @"AUTHCODE":code,
                               @"iconURL":iconUrl.length == 0 ? @"" : iconUrl,
                               @"nickName":name.length == 0 ? @"" : name
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestMallIndexInfoWithCity:(NSString *)city
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/index", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"city":STR_EXISTS(city)};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestBaseDataSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/initData", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestCityNameWithLng:(double)lng
                           lat:(double)lat
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/getCityName", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"jd":[NSString stringWithFormat:@"%lf", lng],
                               @"wd":[NSString stringWithFormat:@"%lf", lat]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCityListSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/region", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestUserNewsTypeSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/userinforType", HOST_ADDRESS, [self loadApiVersion]];
    NSString *userid = [Keychain objectForKey:EC_USER_ID].length == 0 ? @"" : [Keychain objectForKey:EC_USER_ID];
    NSDictionary *paramDic = @{
                               @"userId":userid
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestAllNewsTypeSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/inforType", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager POST:urlStr
       parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestNewsDataWithType:(NSString *)type
                  WithPageIndex:(NSInteger)pageindex
                        Succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/inforlist/%ld", HOST_ADDRESS, [self loadApiVersion],pageindex];
    NSDictionary *paramDic = @{
                               @"BIANMA":type,
                               @"USER_ID":STR_EXISTS([Keychain objectForKey:EC_USER_ID])
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestSaveUserNewsType:(NSString *)typeStr
                        Succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/saveUserInforType", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"inforType":typeStr,
                               @"USERINFO_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestFilterDataWithHouseCode:(NSString *)houseCode
                               catCode:(NSString *)catCode
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/filtrate", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"productHall":houseCode,
                               @"category":catCode
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

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
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/list/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    NSDictionary *paramDic = @{
                               @"bianma":STR_EXISTS(catCode),
                               @"attrs":STR_EXISTS(attrs),
                               @"secondType":STR_EXISTS(secondType),
                               @"productHall":STR_EXISTS(houseCode),
                               @"price_max":STR_EXISTS(maxPrice),
                               @"price_min":STR_EXISTS(minPrice),
                               @"orderAttr":STR_EXISTS(sortType),
                               @"orderMode":STR_EXISTS(sortDescType)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestPanicBuyListWithPageNumber:(NSInteger)pageNumber
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/getActiveProduct/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestProductDetailWithProTable:(NSString *)proTable
                                   proId:(NSString *)proId
                                  userId:(NSString *)userId
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/info", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"protable":STR_EXISTS(proTable),
                               @"proid":STR_EXISTS(proId),
                               @"user_id":STR_EXISTS(userId)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestNewsSendCommentWithNewsID:(NSString *)newsID
                             WithComment:(NSString *)comment
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/saveCommont", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"informationId":newsID,
                               @"userId":[Keychain objectForKey:EC_USER_ID],
                               @"content":comment
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestNewsInfoWithBianma:(NSString *)bianma
                       WithNewsID:(NSString *)newsID
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/info", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"informationId":newsID,
                               @"userId":[Keychain objectForKey:EC_USER_ID],
                               @"BIANMA":bianma
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}
+ (void)requestNewsCollectWithNewsID:(NSString *)newsID
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/collectInformation", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"informationId":newsID,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestNewsCommentWithNewsID:(NSString *)newsID
                       WithPageIndex:(NSInteger)pageIndex
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/infocommentList/%@/%ld", HOST_ADDRESS, [self loadApiVersion],newsID, pageIndex];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}
+ (void)requestNewsAttrInfoWithNewsID:(NSString *)newsID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/intro/%@", HOST_ADDRESS, [self loadApiVersion],newsID];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}
+ (void)requestProductAppraiseListWithPageNumber:(NSInteger)pageNumber
                                           proId:(NSString *)proId
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/commentList/%@/%ld", HOST_ADDRESS, [self loadApiVersion], proId, pageNumber];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}
+ (void)requestNewsPraiseWithType:(NSString *)type
                       WithNewsID:(NSString *)newsID
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/praise", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"type":type,
                               @"informationId":newsID,
                               @"userId":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestNewsSearchWithSearchKey:(NSString *)key
                         WithPageIndex:(NSInteger)pageIndex
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/searchInforlist/%@/%ld", HOST_ADDRESS, [self loadApiVersion],[key urlEncodedUTF8String], pageIndex];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestMoreProductListWithProtable:(NSString *)protable
                                    serise:(NSString *)serise
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/recommendProduct", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"protable":protable,
                               @"series":serise
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}


+ (void)requestCollectProductWithProtable:(NSString *)protable
                                    proId:(NSString *)proId
                                   userId:(NSString *)userId
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/collect", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"PROTABLE":STR_EXISTS(protable),
                               @"PRODUCT_ID":STR_EXISTS(proId),
                               @"USER_ID":STR_EXISTS(userId)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES
                                                          paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestCartNumberWithUserId:(NSString *)userId
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/getCount", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"USER_ID":userId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}


+ (void)requestAddToCartWithUserId:(NSString *)userId
                             proId:(NSString *)proId
                          protable:(NSString *)protable
                             count:(NSInteger)count
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/join", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":userId,
                               @"PROIDS":proId,
                               @"PROTABLE":protable,
                               @"PROQTY":[NSString stringWithFormat:@"%ld", count]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCartListWithUserId:(NSString *)userId
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/index/%@", HOST_ADDRESS, [self loadApiVersion], userId];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestDeleteCartProductsWithCartIdString:(NSString *)cartIdString
                                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/delete", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"ORD_CART_ID":STR_EXISTS(cartIdString)};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestAddAddressWithName:(NSString *)name
                        WithPhone:(NSString *)phone
                      WithAddress:(NSString *)address
                WithAddressDetail:(NSString *)addressDetail
                      WithDefauls:(BOOL)isDefauls
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/delivery/add", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"userid":[Keychain objectForKey:EC_USER_ID],
                               @"mobile_no":phone,
                               @"consignee":name,
                               @"area":address,
                               @"address":addressDetail,
                               @"is_default":isDefauls ? @"1" : @"0"
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestAddressListsucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/delivery/deliveryList/1", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"userid":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestSetDefaultsAddressWithAddressID:(NSString *)addressID
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/delivery/setDefault", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"delivery_id":addressID,
                               @"userid":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDeleteAddressWithAddressID:(NSString *)addressID
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/delivery/delDelivery", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"deliveryids":addressID,
                               @"userid":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestEditAddressWithAddressID:(NSString *)addressID
                              WithName:(NSString *)name
                             WithPhone:(NSString *)phone
                           WithAddress:(NSString *)address
                     WithAddressDetail:(NSString *)addressDetail
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/delivery/updateDelivery", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"delivery_id":addressID,
                               @"mobile_no":phone,
                               @"consignee":name,
                               @"area":address,
                               @"address":addressDetail
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestMineDatasucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/myindex", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"USER_ID":[Keychain objectForKey:EC_USER_ID]};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestSearchProductWithKeyword:(NSString *)keyword
                               sortType:(NSString *)sortType
                           sortDescType:(NSString *)sortDescType
                                pageNum:(NSInteger)pageNum
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/search/%ld", HOST_ADDRESS, [self loadApiVersion], pageNum];
    NSDictionary *paramDic = @{
                               @"orderAttr":STR_EXISTS(sortType),
                               @"orderMode":STR_EXISTS(sortDescType),
                               @"keyword":STR_EXISTS(keyword)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestUploadFileWithFilesData:(NSArray *)filesData
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/upload", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager POST:urlStr
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [filesData enumerateObjectsUsingBlock:^(NSData * _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
        [formData appendPartWithFileData:data
                                    name:@"files"
                                fileName:[NSString stringWithFormat:@"file%ld.jpg", idx]
                                mimeType:@"image/jpeg"];
    }];
    
}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}
+ (void)requestModifyCartSingleProductCountWithCartId:(NSString *)cartId
                                                count:(NSString *)count
                                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/change", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"ORD_CART_ID":cartId,
                               @"PROQTY":count
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}
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
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/applyDesigner", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"userid":userid,
                               @"name":name,
                               @"sex":sex,
                               @"birth":birth,
                               @"province":province,
                               @"city":STR_EXISTS(city),
                               @"nativeplace":nativeplace,
                               @"profession":profession,
                               @"school":school,
                               @"email":email,
                               @"phone":phone,
                               @"company":company,
                               @"obtainyears":obtainyears,
                               @"charge":charge,
                               @"style":style,
                               @"resume":resume,
                               @"experience":experience,
                               @"headImgUrl":headImgUrl,
                               @"certificateImgUrls":certificateImgUrls
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestModifyCartProductCountWithParamString:(NSString *)paramString
                                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/changeMore", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"param":paramString};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetDesignersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/getDesignerInfo", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"userid":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCheckQCode:(NSString *)QCode
                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/shoppingcart/checkDiscode", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"discode":QCode};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            succeed(task, responseObject);
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failed(task, error);
         }];
}

+ (void)requestValidPasswordWithLoginPassword:(NSString *)loginPassword
                              WithPayPassword:(NSString *)payPassword
                                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/validPassword", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic;
    if (payPassword.length == 0) {
        paramDic = @{@"USER_ID":[Keychain objectForKey:EC_USER_ID],
                     @"PASSWORD":[NSString getMd5_32Bit_String:loginPassword]
                     };
    }else{
        paramDic = @{@"USER_ID":[Keychain objectForKey:EC_USER_ID],
                     @"PAYPWD":[NSString getMd5_32Bit_String:payPassword]
                     };
    }
    NSLog(@"-》》》》》》》》》》%@",paramDic);
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestChangePasswordWithLoginPassword:(NSString *)loginPassword
                               WithPayPassword:(NSString *)payPassword
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/changePassword", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic;
    if (payPassword.length == 0) {
        paramDic = @{@"USER_ID":[Keychain objectForKey:EC_USER_ID],
                     @"NEW_PASSWORD":[NSString getMd5_32Bit_String:loginPassword]
                     };
    }else{
        paramDic = @{@"USER_ID":[Keychain objectForKey:EC_USER_ID],
                     @"NEW_PAYWORD":[NSString getMd5_32Bit_String:payPassword]
                     };
    }
    NSLog(@"%@",paramDic);
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestValidAuthCodeWithPhone:(NSString *)phone
                             WithCode:(NSString *)code
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/validAuthcode", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"PHONE":phone,
                               @"AUTHCODE":code
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestChangeMobileWithMobile:(NSString *)mobile
                             WithCode:(NSString *)code
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/changeMobile", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"PHONE":mobile,
                               @"AUTHCODE":code,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestValidPhoneExistWithPhone:(NSString *)phone
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/valiPhoneIsExist", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"PHONE":phone
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestFocusNewsWithNewsID:(NSString *)newsID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/attention", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"informationId":newsID,
                               @"userId":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetUserInfoWithUserID:(NSString *)userid
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/info", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"CURRENT_USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"QUERY_USER_ID":userid
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestFocusWithUserID:(NSString *)userID
                 WithPageIndex:(NSInteger)pageIndex
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/userAttentionList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestFansWithUserID:(NSString *)userID
                WithPageIndex:(NSInteger)pageIndex
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/userFansList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestFocusAndFansFocusWithUserID:(NSString *)userID
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/userDealattention", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID_ONE":userID,
                               @"USER_ID_TWO":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestSelectUserInfoWithUserID:(NSString *)userID
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/userinfo", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}
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
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/postOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":STR_EXISTS(userId),
                               @"cartInfo":STR_EXISTS(cartInfo),
                               @"addressInfo":STR_EXISTS(addressId),
                               @"frontAmount":STR_EXISTS(totalPrice),
                               @"frontNowPay":STR_EXISTS(nowPay),
                               @"isdiscount":STR_EXISTS(isDiscount),
                               @"discode":STR_EXISTS(qcode),
                               @"invoicetitle":STR_EXISTS(billTitle),
                               @"buyerMsg":STR_EXISTS(message)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
    
}
+ (void)requestUpdateUserInfoWithUserInfoID:(NSString *)userInfoID
                              WithHeadImage:(NSString *)headImage
                                  WithBirth:(NSString *)birth
                                    WithSex:(NSString *)sex
                                   WithName:(NSString *)name
                                WithAddress:(NSString *)address
                                  WithEmail:(NSString *)email
                                    succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                     failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/edit", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USERINFO_ID":userInfoID,
                               @"TITLE_IMG":headImage,
                               @"BIRTH":birth,
                               @"SEX":sex,
                               @"NAME":name,
                               @"NATIVEPLACE":address,
                               @"EMAIL":email
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

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
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/postOrderNow", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":STR_EXISTS(userId),
                               @"addressInfo":STR_EXISTS(addressId),
                               @"frontAmount":STR_EXISTS(totalPrice),
                               @"frontNowPay":STR_EXISTS(nowPay),
                               @"isdiscount":STR_EXISTS(isDiscount),
                               @"discode":STR_EXISTS(qcode),
                               @"invoicetitle":STR_EXISTS(billTitle),
                               @"buyerMsg":STR_EXISTS(message),
                               @"protable":STR_EXISTS(protable),
                               @"proid":STR_EXISTS(proId),
                               @"proqty":STR_EXISTS(count),
                               @"iseasypay":STR_EXISTS(isEasyPay)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetPostWorksTypesucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/caseAllstyleData", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}
+ (void)requestOrderListWithPageNumber:(NSInteger)pageNumber
                                userId:(NSString *)userId
                                 state:(NSString *)state
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/orderList/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    NSDictionary *paramDic = @{
                               @"userid":userId,
                               @"state":state
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestSubmitWorksWithUserID:(NSString *)userID
                           WithStyle:(NSString *)style
                            WithType:(NSString *)type
                       WithHouseType:(NSString *)houseType
                           WithTitle:(NSString *)title
                           WithCover:(NSString *)cover
                         WithContent:(NSString *)content
                             WithTop:(BOOL)top
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/publishCaseOrArticle", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"user_id":STR_EXISTS(userID),
                               @"style":STR_EXISTS(style),
                               @"type":STR_EXISTS(type),
                               @"housetype":STR_EXISTS(houseType),
                               @"title":STR_EXISTS(title),
                               @"cover":STR_EXISTS(cover),
                               @"isTop":top ? @"1" : @"0",
                               @"content":STR_EXISTS(content)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestConfirmReceiveWithOrderId:(NSString *)orderId
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/confirmGoods/%@", HOST_ADDRESS, [self loadApiVersion], orderId];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestSubmitLogsWithTitle:(NSString *)title
                         WithImage:(NSString *)image
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/publishLog", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"user_id":[Keychain objectForKey:EC_USER_ID],
                               @"title":STR_EXISTS(title),
                               @"imgurl":STR_EXISTS(image)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestArticleListWithUserID:(NSString *)userID
                       WithPageIndex:(NSInteger)pageIndex
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/articleCaseList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"user_id":STR_EXISTS(userID)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestLogsListWithUserID:(NSString *)userID
                    WithPageIndex:(NSInteger)pageIndex
                          succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                           failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/logList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"user_id":STR_EXISTS(userID)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestMyCollectWithType:(NSInteger)type
                   WithPageIndex:(NSInteger)pageindex
                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/mycollect/%ld", HOST_ADDRESS, [self loadApiVersion], pageindex];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"TYPE":[NSString stringWithFormat:@"%ld",type]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestChangeMyCollectStateWithCollectID:(NSString *)collectID
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/deleteCollect", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"IDS":collectID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestPostFeebackWithContent:(NSString *)content
                            WithPhone:(NSString *)phone
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/feeback/postFeeback", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"description":content,
                               @"phone":phone
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerCaseListWithStyle:(NSString *)style
                                WithType:(NSString *)type
                               WithHouse:(NSString *)house
                               WithOrder:(NSString *)order
                           WithPageIndex:(NSInteger)pageIndex
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/design/caseList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"style":style,
                               @"type":type,
                               @"housetype":house,
                               @"orderBy":order
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerListWithOrderBy:(NSString *)orderBy
                              WithCity:(NSString *)city
                             WithStyle:(NSString *)style
                         WithPageIndex:(NSInteger)pageIndex
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/design/designList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"orderBy":orderBy,
                               @"city":STR_EXISTS(city),
                               @"style":style
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestTeamUsersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/teamUsers", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestTeamDetailWithUserID:(NSString *)userID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/subteamUsers", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"PARENTID":[Keychain objectForKey:EC_USER_ID],
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestTeamDeleteWithUserID:(NSString *)userID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/unbindUser", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWorksDetailWithWorksID:(NSString *)worksID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/articleCaseInfo", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"id":worksID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWorksPraiseWithType:(NSString *)type
                       WithWorksID:(NSString *)worksID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/praise", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"userId":[Keychain objectForKey:EC_USER_ID],
                               @"casearticle_id":worksID,
                               @"type":type
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWorksCollectWithWorksID:(NSString *)worksID
                               succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/collectCase", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"ID":worksID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetWorksCommentWithWorksID:(NSString *)worksID
                            WithPageIndex:(NSInteger)pageIndex
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/design/casecommentList/%@/%ld", HOST_ADDRESS, [self loadApiVersion],worksID,pageIndex];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestWorksSendCommentWithWorksID:(NSString *)worksID
                               WithContent:(NSString *)content
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/design/saveCaseComment", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"userId":[Keychain objectForKey:EC_USER_ID],
                               @"content":content,
                               @"caseId":worksID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCancleOrderWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/cancelOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"orderids":orderId
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDeleteOrderWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/delOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"orderids":orderId
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestExpressDeliveryWithCom:(NSString *)com
                          OrderNumber:(NSString *)orderNum
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/queryLogistics", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"expressnumber":STR_EXISTS(orderNum),
                               @"expresscode":STR_EXISTS(com)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
             succeed(task, dic);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestOrderDetailWithOrderId:(NSString *)orderId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/orderInfo/%@", HOST_ADDRESS, [self loadApiVersion], orderId];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestReturnGoodWithUserId:(NSString *)userId
                            orderId:(NSString *)orderId
                             reason:(NSString *)reason
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/returnGoods", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"orderid":orderId,
                               @"userid":userId,
                               @"pursue_reason":STR_EXISTS(reason)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestCommitCommentWithOrderId:(NSString *)orderId
                                 userId:(NSString *)userId
                         productIdArray:(NSArray <NSString *> *)productIdArray
                           commentArray:(NSArray <NSString *> *)commentArray
                         starLevelArray:(NSArray <NSString *> *)starLevelArray
                         imageListAttay:(NSArray <NSArray *> *)imageListArray
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/postComment", HOST_ADDRESS, [self loadApiVersion]];
    NSMutableArray *commitArray = [NSMutableArray array];
    [productIdArray enumerateObjectsUsingBlock:^(NSString * _Nonnull productId, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *commentStr = [commentArray objectAtIndexWithCheck:idx];
        NSString *starLevel = [starLevelArray objectAtIndexWithCheck:idx];
        NSArray *imageList = [imageListArray objectAtIndexWithCheck:idx];
        NSDictionary *dic = @{
                              @"product_id":productId,
                              @"comment":commentStr,
                              @"star_level":starLevel,
                              @"imgurls":imageList
                              };
        [commitArray addObject:dic];
    }];
    NSDictionary *paramDic = @{
                               @"orderid":orderId,
                               @"userid":userId,
                               @"commentlist":[commitArray JSONString]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestUserInfoCommentListWithUserID:(NSString *)userID
                               WithPageIndex:(NSInteger)pageIndex
                                     succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                      failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/userCommentList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":userID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestMyWalletInfoWithUserId:(NSString *)userId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/index", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"USER_ID":userId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestUserAccountBillWithUserId:(NSString *)userId
                              pageNumber:(NSInteger)pageNumber
                                 succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                  failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/journary/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    NSDictionary *paramDic = @{@"user_id":userId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestPayOrderUseWalletWithOrderNum:(NSString *)orderNum
                                      amount:(NSString *)amount
                                        type:(NSString *)type
                                     succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                      failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/payOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"orderNo":orderNum,
                               @"money":amount,
                               @"type":type
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestAliSignWithBody:(NSString *)body
                       orderNo:(NSString *)orderNo
                        amount:(NSString *)amount
                          type:(NSString *)type
                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@pay/alipay/appSign", HOST_ADDRESS];
    NSDictionary *paramDic = @{
                               @"BODY":body,
                               @"ORDERNO":orderNo,
                               @"TOTAL_MONEY":amount,
                               @"type":type
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWxSignWithBody:(NSString *)body
                      orderNo:(NSString *)orderNo
                       amount:(NSString *)amount
                         type:(NSString *)type
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@pay/wxpay/appSign", HOST_ADDRESS];
    NSDictionary *paramDic = @{
                               @"BODY":body,
                               @"ORDERNO":orderNo,
                               @"TOTAL_MONEY":amount,
                               @"type":type
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestUnionPaySignWithUserId:(NSString *)userId
                              orderNo:(NSString *)orderNo
                               amount:(NSString *)amount
                                 type:(NSString *)type
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@pay/unionpay/appSign", HOST_ADDRESS];
    NSDictionary *paramDic = @{
                               @"userId":userId,
                               @"ORDERNO":orderNo,
                               @"TOTAL_MONEY":amount,
                               @"type":type
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestLeftProductListWithPageNum:(NSInteger)pageNum
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/getLeftProductList/%ld", HOST_ADDRESS, [self loadApiVersion], pageNum];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestBrandStoryWithProId:(NSString *)proId
                          protable:(NSString *)protable
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/proPinpaiStory", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"proid":proId,
                               @"protable":protable
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
    
}

+ (void)requestGetAddressByLatWithLat:(CGFloat)lat
                              WithLng:(CGFloat)lng
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/getAddressBylnglat", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"lng":[NSString stringWithFormat:@"%f",lng],
                               @"lat":[NSString stringWithFormat:@"%f",lat]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

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
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/postDesigneOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"designer_id":designer_id,
                               @"user_id":user_id,
                               @"describe":describe,
                               @"housearea":housearea,
                               @"location":location,
                               @"lng":[NSString stringWithFormat:@"%f",lng],
                               @"lat":[NSString stringWithFormat:@"%f",lat],
                               @"housetype":housetype,
                               @"decoratetype":decoratetype,
                               @"style":style,
                               @"claim":claim,
                               @"imgurls":imgurls,
                               @"cycle":cycle
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderListWithState:(NSString *)state
                            WithPageIndex:(NSInteger)pageIndex
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/designorderList/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID],
                               @"state":state
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

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
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/editDesigneOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"id":orderID,
                               @"describe":describe,
                               @"housearea":housearea,
                               @"location":location,
                               @"lng":[NSString stringWithFormat:@"%f",lng],
                               @"lat":[NSString stringWithFormat:@"%f",lat],
                               @"housetype":housetype,
                               @"decoratetype":decoratetype,
                               @"style":style,
                               @"claim":claim,
                               @"imgurls":imgurls,
                               @"cycle":cycle
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCancelDesignerOrder:(NSString *)orderID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/cancelOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"id":orderID,
                               @"userid":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetDesignerOrderStyleDatasucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/designerOrderStyleTypeData", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderOfferWithID:(NSString *)orderID
                              WithMoney:(CGFloat)money
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/offerPriceOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"money":[NSString stringWithFormat:@"%.f",money],
                               @"id":orderID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderWalletPayWithID:(NSString *)orderID
                                  WithMoney:(NSString *)money
                                    succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                     failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/payDesigneOrder", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"money":money,
                               @"id":orderID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderCompleteWithOrderID:(NSString *)orderID
                                      WithState:(NSString *)state
                                        succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/changeDesOrderState", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"state":state,
                               @"id":orderID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderReturnMoney:(NSString *)orderID
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/returnMoney", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"id":orderID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderComment:(NSString *)orderID
                        WithComment:(NSString *)comment
                           WithStar:(NSString *)star
                        WithImgUrls:(NSString *)imgUrls
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/postComment", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"userid":[Keychain objectForKey:EC_USER_ID],
                               @"id":orderID,
                               @"comment":comment,
                               @"star_level":star,
                               @"imgurls":imgUrls
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerOrderDetail:(NSString *)orderID
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/designOrder/getDesigneOrderInfo", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"id":orderID
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestMaterialLibraryWithStyle:(NSString *)style
                               WithType:(NSString *)type
                              WithOrder:(NSString *)order
                          WithPageIndex:(NSInteger)pageIndex
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/materialList/%ld", HOST_ADDRESS, [self loadApiVersion],(long)pageIndex];
    NSDictionary *paramDic = @{@"style":style,
                               @"type":type,
                               @"order":order,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCollectMaterialLibrary:(NSString *)libID
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/collectmaterial", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"ID":libID,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDesignerSearchWithtype:(NSInteger)type
                              WithKey:(NSString *)key
                        WithPageIndex:(NSInteger)pageIndex
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/design/dcmSearchList/%ld", HOST_ADDRESS, [self loadApiVersion], pageIndex];
    NSDictionary *paramDic = @{@"type":[NSString stringWithFormat:@"%ld",type],
                               @"keywords":key,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO
                                                          paramDic:@{}];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestPointInfoWithUserId:(NSString *)userId
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mypoint/index", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":userId
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestPointToMoneyRateSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mypoint/getPointToMoneyRate", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestPointBillListWithPageNum:(NSInteger)pageNum
                                 userId:(NSString *)userId
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mypoint/journary/%ld", HOST_ADDRESS, [self loadApiVersion], pageNum];
    NSDictionary *paramDic = @{@"user_id":userId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestPointProductListWithPageNumber:(NSInteger)pageNumber
                                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/integral/integralList/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestPointProductDetailWithProId:(NSString *)proId
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/integral/seeIntegral", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"id":proId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestCommitPointOrderWithUserId:(NSString *)userId
                                    proId:(NSString *)proId
                                addressId:(NSString *)addressId
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/integral/postOrderIntegral", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"user_id":userId,
                               @"proids":STR_EXISTS(proId),
                               @"deliveryid":STR_EXISTS(addressId)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetShareRegistersucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/getShareRegisterURL", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestPointOrderListWithUserId:(NSString *)userId
                             pageNumber:(NSInteger)pageNumber
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/integral/orderintegralList/%ld", HOST_ADDRESS, [self loadApiVersion], pageNumber];
    NSDictionary *paramDic = @{@"user_id":userId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}


+ (void)requestPointOrderDetailWithOrderId:(NSString *)orderId
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/integral/seeOrderIntegral", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"integral_id":orderId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestBankListSucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/getBankList", HOST_ADDRESS, [self loadApiVersion]];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestbindBankCardWithUserId:(NSString *)userId
                           cardHolder:(NSString *)cardHolder
                               cardNo:(NSString *)cardNo
                             province:(NSString *)province
                                 city:(NSString *)city
                               bankId:(NSString *)bankId
                              succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                               failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/bindBankCard", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"userid":STR_EXISTS(userId),
                               @"cardholder":STR_EXISTS(cardHolder),
                               @"bankno":STR_EXISTS(cardNo),
                               @"province":STR_EXISTS(province),
                               @"city":STR_EXISTS(city),
                               @"DICTIONARIES_ID":STR_EXISTS(bankId)
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDeleteBankCardWithCardId:(NSString *)cardId
                                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/getByIdSetState", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"bankid":cardId
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestWalletBalanceTakeMoneyWithUserId:(NSString *)userId
                                         amount:(NSString *)amount
                                     bankCardId:(NSString *)bankCardId
                                        succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                         failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/wallet/withdraw", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"USER_ID":userId,
                               @"money":amount,
                               @"bankid":bankCardId
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


+ (void)requestTakePointWithUserId:(NSString *)userId
                             point:(NSString *)point
                           succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                            failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mypoint/withdrawPoint", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{
                               @"user_id":userId,
                               @"point":point
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestPushList:(NSInteger)pageIndex
                succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                 failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/msg/findNotifyMsg/%ld", HOST_ADDRESS, [self loadApiVersion],pageIndex];
    NSDictionary *paramDic = @{
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]
                               };
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestChatListUserInfoWithUserIdArray:(NSArray *)userIdArray
                                       succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                        failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/msg/getChatUserInfo", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"user_ids":[userIdArray JSONString]};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager GET:urlStr
      parameters:paramDic
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestCollectMoreProductWithInfo:(NSString *)info
                                  succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                   failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/collectMore", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"info":info,
                               @"USER_ID":[Keychain objectForKey:EC_USER_ID]};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestGetDesignerJobsucceed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/designerCareerType", HOST_ADDRESS, [self loadApiVersion]];

    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager POST:urlStr
       parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestReportWithType:(NSInteger)type
                       WithID:(NSString *)infoID
                  WithContent:(NSString *)content
                 WithCategory:(NSString *)category
                      succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                       failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/reportInfomationOrCase", HOST_ADDRESS, [self loadApiVersion]];
    
    NSDictionary *paramDic = @{@"type":[NSString stringWithFormat:@"%ld",type],
                               @"repostUserId":[Keychain objectForKey:EC_USER_ID],
                               @"informationId":infoID,
                               @"repostContent":content,
                               @"category":category};
    
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestOrderCommentListWithOrderID:(NSString *)orderID
                                   succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                    failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/order/seeOrderComment/%@", HOST_ADDRESS, [self loadApiVersion],orderID];
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:@{}];
    [manager GET:urlStr
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             succeed(task, responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failed(task, error);
         }];
}

+ (void)requestDeleteUserWorksWithID:(NSString *)workdsID
                             succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                              failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/cancelCaseOrArticle", HOST_ADDRESS, [self loadApiVersion]];
    
    NSDictionary *paramDic = @{@"id":workdsID};
    
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestDeleteUserLogsWithID:(NSString *)logsID
                            succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                             failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/user/cancelLog", HOST_ADDRESS, [self loadApiVersion]];
    
    NSDictionary *paramDic = @{@"id":logsID};
    
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:YES paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}

+ (void)requestAddVideoPlayCountWithInfomationId:(NSString *)infomationId
                                         succeed:(void(^)(NSURLSessionDataTask *task, id result))succeed
                                          failed:(void(^)(NSURLSessionDataTask *task, NSError *error))failed {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/infor/addVideoView", HOST_ADDRESS, [self loadApiVersion]];
    NSDictionary *paramDic = @{@"id":infomationId};
    AFHTTPSessionManager *manager = [self shareManagerWithAuthInfo:NO paramDic:paramDic];
    [manager POST:urlStr
       parameters:paramDic
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              succeed(task, responseObject);
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failed(task, error);
          }];
}


@end
