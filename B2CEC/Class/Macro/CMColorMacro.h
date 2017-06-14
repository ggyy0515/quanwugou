//
//  CMColorMacro.h
//  TrCommerce
//
//  Created by Tristan on 15/11/4.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#ifndef CMColorMacro_h
#define CMColorMacro_h

//method
#define UIColorFromRGB(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define UIColorFromRGBA(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UIColorFromHexString(value)   [UIColor colorWithHexString:value alpha:1.0f]




//主色
#define MainColor               UIColorFromHexString(@"#1a191e")
//浅主色
#define MainShallowColor        UIColorFromHexString(@"#454449")
//辅色
#define CompColor               UIColorFromHexString(@"#ee383b")
//浅辅色
#define CompShallowColor        UIColorFromHexString(@"#fc5d60")
//tabbar颜色
#define TabbarTintColor         UIColorFromHexString(@"#1a191e")

//底色        导航栏底色
#define BaseColor               UIColorFromHexString(@"#f5f5f5")
//选项底色     选项卡底色
#define OptionsBaseColor        UIColorFromHexString(@"#ececec")
//默认分割线   部分描边也使用
#define LineDefaultsColor       UIColorFromHexString(@"#dddddd")
//浅色        一般用于不重要文字
#define LightColor              UIColorFromHexString(@"#999999")
//较浅色      一般用于默认文字
#define LightMoreColor          UIColorFromHexString(@"#666666")
//深色        一般用于重要加粗文字
#define DarkColor               UIColorFromHexString(@"#333333")
//正深色      一般用于重要不加粗文字
#define DarkMoreColor           UIColorFromHexString(@"#222222")
//浅色        一般用户输入框提示文字颜色
#define LightPlaceholderColor   UIColorFromHexString(@"#cccccc")

//透明色
#define ClearColor              [UIColor clearColor]


//字体大小
//38号不加粗文字    主要用在主页新闻标题等位置
#define FONT_38                 [UIFont systemFontOfSize:19]
//36号加粗文字      主要用在导航栏标题等重要标题
#define FONT_B_36               [UIFont boldSystemFontOfSize:18]
#define FONT_36               [UIFont systemFontOfSize:18]
//32号加粗文字      用于内容标题、价格等重要文字
#define FONT_B_32               [UIFont boldSystemFontOfSize:16]
//32号中等文字      用于重要展示类文字
#define FONT_32                 [UIFont systemFontOfSize:16]
//28号中等文字      用于一般类文字
#define FONT_28                 [UIFont systemFontOfSize:14]
#define FONT_B_28               [UIFont boldSystemFontOfSize:14]
//24号中等文字      用于副标题类非重要文字
#define FONT_24                 [UIFont systemFontOfSize:12]
//22号中等文字      用于标签栏或其他非重要文字
#define FONT_22                 [UIFont systemFontOfSize:11]
#define FONT_26                 [UIFont systemFontOfSize:13]





//pitcure
//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//占位图
#define SFPlaceHolderImage  [UIImage imageNamed:@"threeOfFour_holder"]
//默认头像
#define HeardImage          [UIImage imageNamed:@"set_heardImage"]

//定义UIImage对象
#define LOADPNGIMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

#endif /* CMColorMacro_h */
