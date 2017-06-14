//
//  CMPublicMethod.h
//  TrCommerce
//
//  Created by Tristan on 15/11/5.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMPublicMethod : NSObject

+ (CGFloat)getAdapterHeight;

/*!
 *  加减乘除运算
 *
 *  @param first       运算第一位
 *  @param second      运算第二位
 *  @param theOperator 运算符
 *
 *  @return 运算结果
 */
+(NSString *)subtractingWithFirst:(id)first
                           second:(id)second
                      theOperator:(NSString *)theOperator;



/**
 *   根据用户名存储图片
 */
+ (void)saveImage:(UIImage *)image name:(NSString *)name;


/**
 *  根据用户名读缓存图片
 *  @return UIImage或者nil
 */
+ (UIImage *)loadImageName:(NSString *)name;

/*!
 *  裁剪图片
 *  @param sourceImage 图片
 *  @return 返回的图片
 */
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage ;

#pragma mark - camera utility
+ (BOOL) isCameraAvailable;
+ (BOOL) isFrontCameraAvailable ;
+ (BOOL) doesCameraSupportTakingPhotos ;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;


/*!
 *  //身份证号
 *  @param identityCard 身份证号
 *  @return yes  no
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;


/*!
 *  生成图片
 *  @param color 颜色
 *  @return 图片
 */
+(UIImage *)imageWithColor:(UIColor *)color;

/*!
 *  手机号转成带****
 */
+ (NSString *)mobilePhoneNumberIntoAStarMobile:(NSString *)Mobile;

/*!
 *  银行卡号转成带****
 */
+ (NSString *)bankNumberIntoAStarMobile:(NSString *)bankNumber;
/*!
 * 正在表达式  邮箱
 */
+ (BOOL)validateEmail:(NSString *)email;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;


/**
 计算宽度--setModel布局

 @param label 需要布局的label
 @return 宽度
 */
+ (CGFloat)getWidthWithLabel:(UILabel *)label;

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;

+ (void)showInfoWithString:(NSString *)content;

+ (NSData *)getFitImageWithImage:(UIImage *)image;

/**
 找到导航栏底部的分割黑细线
 
 @param bar 导航栏
 @return 分割黑细线
 */
+ (UIImageView *)findNavBottomLineView:(UIView *)bar;

/**
 倒计时功能
 
 @param timeCount 倒计时
 @param operation 正在倒计时时的操作
 @param completion 倒计时结束的操作
 */
+ (void)countDownWithTime:(NSInteger)timeCount WithOperation:(void(^)(NSInteger count))operation WithCompletion:(void(^)())completion;

/**
 *  匹配字符串中得链接  并返回链接字符串数组
 *
 *  @param string 要匹配的字符串数组
 *
 *  @return 链接数组
 */
+(NSArray *)matchLinks:(NSString *)string;

/*!
 *  支付键盘限制条件
 *
 *  @param textField textFiled
 *  @param string    当前输入的字符
 *
 *  @return 是否可以让输入
 */
+ (BOOL)payTheKeyboardConstraintsTextField:(UITextField *)textField string:(NSString *)string;

/*!
 *  支付键盘限制条件 结束的时候
 *
 *  @param textField  textField
 */
+ (void)paytextFieldDidEndEditingTextField:(UITextField *)textField;

/*!
 *  支付键盘限制条件 开始的时候
 *
 *  @param textField textField
 */
+ (void)paytextFieldDidBeginEditingTextField:(UITextField *)textField;

/*!
 *  加法
 *
 *  @param oneString 第一个参数
 *  @param twoString 第二个参数·
 *
 *  @return 相加的数
 */
+ (NSString *)addOneString:(NSString *)oneString twoString:(NSString *)twoString;

/*!
 *  减法
 *
 *  @param oneString 第一个参数
 *  @param twoString 第二个参数·
 *
 *  @return 相减的数
 */
+ (NSString *)subtractionOneString:(NSString *)oneString twoString:(NSString *)twoString;


/*!
 *  乘法
 *
 *  @param oneString 第一个参数
 *  @param twoString 第二个参数·
 *
 *  @return 相乘的数
 */
+ (NSString *)multiplicationOneString:(NSString *)oneString twoString:(NSString *)twoString;

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

/**
 *  判断全空格输入
 *
 *  @param str str
 *
 *  @return return BOOL
 */
+ (BOOL)isEmpty:(NSString *)str;

/**
 验证是否为纯数字

 @param str <#str description#>
 @return <#return value description#>
 */
+ (BOOL)isValidateNumber:(NSString *)str;

/**
 分享到第三方平台

 @param title 标题
 @param link 链接
 */
+ (void)shareToPlatformWithTitle:(NSString *)title WithLink:(NSString *)link WithQCode:(BOOL)isQCode;

/**
 依据生日获得年龄

 @param birth 生日  yyyy-mm-dd
 @return <#return value description#>
 */
+ (NSInteger)getAgeWithBirth:(NSString *)birth;

/**
 时间长度转成时分秒

 @param time <#time description#>
 @return <#return value description#>
 */
+ (NSString *)playerTimeStyle:(CGFloat)time;

@end
