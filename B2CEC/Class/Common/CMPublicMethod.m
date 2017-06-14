//
//  CMPublicMethod.m
//  TrCommerce
//
//  Created by Tristan on 15/11/5.
//  Copyright © 2015年 Tristan. All rights reserved.
//
#define ORIGINAL_MAX_WIDTH 640.0f
#import "CMPublicMethod.h"

#import <UShareUI/UShareUI.h>

@implementation CMPublicMethod

+(CGFloat)getAdapterHeight{
    CGFloat adapterHeight = 0;
    if (SYS_VERSION < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}

+ (NSString *)subtractingWithFirst:(id)first
                            second:(id)second
                       theOperator:(NSString *)theOperator{
    if (!first || !second) {
        return @"0";
    }
    
    //运算结果
    NSDecimalNumber *results;
    
    //声明两个  NSDecimalNumber
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",first]];
    
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",second]];
    
    //加法
    if ([theOperator isEqualToString:@"+"]) {
        results = [one decimalNumberByAdding:two];
    }
    
    //减法
    if ([theOperator isEqualToString:@"-"]) {
        results = [one decimalNumberBySubtracting:two];
    }
    
    //乘法
    if ([theOperator isEqualToString:@"*"]) {
        results = [one decimalNumberByMultiplyingBy:two];
    }
    
    //除法
    if ([theOperator isEqualToString:@"/"]) {
        results = [one decimalNumberByDividingBy:two];
    }
    //保留两位小数  四舍五入  如果不想四舍五入直接截取的话就把 NSRoundPlain改为NSRoundDown即可。
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                                                                                      scale:2
                                                                                           raiseOnExactness:NO raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:YES];
    
    NSDecimalNumber *  roundedOunces = [results decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
    
}


+ (void)saveImage:(UIImage *)image name:(NSString *)name{
//    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndexWithCheck:0];
//    NSString *imageName = [NSString stringWithFormat:@"%@%@",[USERDEFAULT objectForKey:USERID],name];
//    NSString *filePath = [[documentDirectory stringByAppendingPathComponent:@"HeadImages"] stringByAppendingString:imageName];
//    NSData *data = UIImageJPEGRepresentation(image, 0.1);
//    [data writeToFile:filePath atomically:YES];
//    POST_NOTIFICATION(NOTIFACATION_NAME_HASCHANGE_HEADIMAGE, nil);
}


+ (UIImage *)loadImageName:(NSString *)name{
//    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndexWithCheck:0];
//    NSString *imageName = [NSString stringWithFormat:@"%@%@",[USERDEFAULT objectForKey:USERID],name];
//    NSString *filePath = [[documentDirectory stringByAppendingPathComponent:@"HeadImages"] stringByAppendingString:imageName];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:filePath]) {
//        NSData * data = [NSData dataWithContentsOfFile:filePath];
//        UIImage *image = [UIImage imageWithData:data];
//        return image;
//    }
    return nil;
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - image scale utility
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

#pragma mark - camera utility

+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGFloat imageW = 5.0;
    CGFloat imageH = 5.0;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)mobilePhoneNumberIntoAStarMobile:(NSString *)Mobile{
    if ([Mobile isEqualToString:@""]) {
        return @"";
    }
    
    NSRange range;//匹配得到的下标
    
    range.length = 3;
    
    range.location = 0;
    
    NSString * stringOne = [Mobile substringWithRange:range];//截取范围类的字符串
    
    NSRange rangeTwo;//匹配得到的下标
    
    rangeTwo.length = 4;
    
    rangeTwo.location = 7;
    
    NSString * stringTwo = [Mobile substringWithRange:rangeTwo];//截取范围类的字符串
    
    NSString * replace = @"****";
    
    NSString *mstr = [NSString stringWithFormat:@"%@%@%@",stringOne,replace,stringTwo];
    return mstr;
}

+ (NSString *)bankNumberIntoAStarMobile:(NSString *)bankNumber{
    if ([bankNumber isEqualToString:@""]) {
        return @"";
    }
    NSRange range;//匹配得到的下标
    
    range.length = 4;
    
    range.location = bankNumber.length-4;
    
    NSString * stringOne = [bankNumber substringWithRange:range];//截取范围类的字符串
    NSString *mstr = [NSString stringWithFormat:@"*** **** **** %@",stringOne];
    return mstr;
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 1000999)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return ceil(rect.size.height);
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(100000, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                        context:nil];
    return rect.size.width;
}

+ (CGFloat)getWidthWithLabel:(UILabel *)label {
    CGFloat width = ceilf([label.text boundingRectWithSize:CGSizeMake(100000, label.font.lineHeight)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:label.font}
                                                   context:nil].size.width);
    return width;
}

+ (void)showInfoWithString:(NSString *)content{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:content];
        　　});
}

+ (NSData *)getFitImageWithImage:(UIImage *)image {
    
#define kIMAGESIZE   ((200 * 1024.0) - 100)
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    double imageLength = imageData.length;
    if (imageLength <= kIMAGESIZE) {
        return imageData;
    }
    double scale = kIMAGESIZE / imageLength;
    NSData *compressData = UIImageJPEGRepresentation(image, scale);
    return compressData;
}


+ (UIImageView *)findNavBottomLineView:(UIView *)view{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findNavBottomLineView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

+ (void)countDownWithTime:(NSInteger)timeCount WithOperation:(void(^)(NSInteger count))operation WithCompletion:(void(^)())completion{
    __block NSInteger timeout = timeCount;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 1){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                operation(timeout);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+(NSArray *)matchLinks:(NSString *)string
{
    //匹配链接
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //存放匹配到的 链接字符串
    NSMutableArray *urls = [NSMutableArray array];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        [urls addObject:substringForMatch];
    }
    
    return urls;
}

+ (BOOL)payTheKeyboardConstraintsTextField:(UITextField *)textField string:(NSString *)string{
    //判断点击的是不是  删除键
    if ([string isEqualToString:@""]) {
        return YES;
    }
    //输入第一个字符为。情况下
    if (textField.text.length == 0) {
        if ([string isEqualToString:@"."]) {
            textField.text = @"0.";
            return NO;
        }
        
    }
    //输入第一个字符为0情况下
    if (textField.text.length == 0) {
        if ([string isEqualToString:@"0"]) {
            textField.text = @"0.";
            return NO;
        }
        
    }
    //第一个字符为0的情况下
    if (textField.text.length == 1) {
        if ([textField.text isEqualToString:@"0"]) {
            if (![string isEqualToString:@"."]) {
                return NO;
            }
        }
    }
    //判断当输入第二个.的情况下
    if ([string isEqualToString:@"."]) {
        if ([textField.text containsString:@"."]) {
            return NO;
        }
    }
    //小数点后面只能保留两位
    if ([textField.text containsString:@"."]) {
        NSArray *array = [textField.text componentsSeparatedByString:@"."];
        if (((NSString *)array[1]).length == 2) {
            return NO;
        }
    }
    return YES;
}

+ (void)paytextFieldDidEndEditingTextField:(UITextField *)textField{
    NSRange range;//匹配得到的下标
    range.length = 1;
    range.location = textField.text.length-1;
    NSString * stringOne = [textField.text substringWithRange:range];//截取范围类的字符串
    if ([stringOne isEqualToString:@"."]) {
        NSArray *array = [textField.text componentsSeparatedByString:@"."];
        textField.text = array[0];
    }
}

+ (void)paytextFieldDidBeginEditingTextField:(UITextField *)textField{
    if (textField.text.length == 1) {
        NSRange range;//匹配得到的下标
        range.length = 1;
        range.location = 0;
        NSString * string = [textField.text substringWithRange:range];//截取范围类的字符串
        //输入第一个字符为。情况下
        if ([string isEqualToString:@"0"]) {
            textField.text = @"0.";
        }
    }
}


+ (NSString *)addOneString:(NSString *)oneString twoString:(NSString *)twoString{
    //加法
    
    //声明两个  NSDecimalNumber
    NSDecimalNumber *jiafa1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",oneString]];
    
    NSDecimalNumber *jiafa2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",twoString]];
    
    //加法运算函数  decimalNumberByAdding
    NSDecimalNumber *jiafa = [jiafa1 decimalNumberByAdding:jiafa2];
    
    return [NSString stringWithFormat:@"%@",jiafa.stringValue];
    
}


+ (NSString *)subtractionOneString:(NSString *)oneString twoString:(NSString *)twoString
{
    //减法
    
    //声明两个  NSDecimalNumber
    NSDecimalNumber *jianfa1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",oneString]];
    
    NSDecimalNumber *jianfa2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",twoString]];
    
    //减法运算函数  decimalNumberByAdding
    NSDecimalNumber *jianfa = [jianfa1 decimalNumberBySubtracting:jianfa2];
    
    return [NSString stringWithFormat:@"%@",jianfa];
}

+ (NSString *)multiplicationOneString:(NSString *)oneString twoString:(NSString *)twoString{
    //乘法
    
    //声明两个  NSDecimalNumber
    NSDecimalNumber *chengfa1 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",oneString]];
    
    NSDecimalNumber *chengfa2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",twoString]];
    
    
    //乘法运算函数  decimalNumberByAdding
    NSDecimalNumber *chengfa = [chengfa1 decimalNumberByMultiplyingBy:chengfa2];
    
    return [NSString stringWithFormat:@"%@",chengfa];
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)isValidateNumber:(NSString *)str{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}

+ (void)shareToPlatformWithTitle:(NSString *)title WithLink:(NSString *)link WithQCode:(BOOL)isQCode{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.text = title;
        
        if (!isQCode) {
            UMShareWebpageObject *shareObiect = [UMShareWebpageObject shareObjectWithTitle:@"全屋构分享" descr:title thumImage:[UIImage imageNamed:@"share_icon"]];
            shareObiect.webpageUrl = link;
            
            messageObject.shareObject = shareObiect;
        }
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
            if (error == nil) {
                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"分享失败"];
            }
        }];
    }];
}

+ (NSInteger)getAgeWithBirth:(NSString *)birth{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [inputFormatter dateFromString:birth];
    
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:inputDate];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

+ (NSString *)playerTimeStyle:(CGFloat)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (time / 3600 > 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showTimeStyle = [formatter stringFromDate:date];
    return showTimeStyle;
}
@end
