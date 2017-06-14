//
//  ECBrandStoryWebCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECBrandStoryWebCell.h"

@interface ECBrandStoryWebCell ()
<
    UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *extendBtn;
@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, assign) BOOL needLoadWeb;

@end

@implementation ECBrandStoryWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _needLoadWeb = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_extendBtn) {
        _extendBtn = [UIButton new];
    }
    [self.contentView addSubview:_extendBtn];
    [_extendBtn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"查看更多"
                                                                   attributes:@{NSFontAttributeName:FONT_32,
                                                                                NSForegroundColorAttributeName:DarkMoreColor,
                                                                                NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}]
                          forState:UIControlStateNormal];
    [_extendBtn setImage:[UIImage imageNamed:@"nav_citymore"] forState:UIControlStateNormal];
    CGFloat width = ceilf([_extendBtn.currentAttributedTitle boundingRectWithSize:CGSizeMake(100.f, 18.f)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                          context:nil].size.width);
    [_extendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-16.f);
        make.size.mas_equalTo(CGSizeMake(width + 14.f, 18.f));
    }];
    [_extendBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -14.f, 0, 14.f)];
    [_extendBtn setImageEdgeInsets:UIEdgeInsetsMake(0, width + 9.f, 0, -width - 9.f)];
    _extendBtn.hidden = YES;
    [_extendBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickCheckMore) {
            weakSelf.clickCheckMore();
        }
        [weakSelf.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        sender.hidden = YES;
    }];
    
    if (!_webView) {
        _webView = [UIWebView new];
    }
    [self.contentView addSubview:_webView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.scrollsToTop = NO;
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (!_act) {
        _act = [[UIActivityIndicatorView alloc] init];
    }
    _act.hidesWhenStopped = NO;
    [self.contentView addSubview:_act];
    [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_act mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(weakSelf.webView);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
    }];
    [_act startAnimating];
}

- (void)setContent:(NSString *)content {
    if (_needLoadWeb) {
        if (content.length > 0) {
            _needLoadWeb = NO;
        }
        _content = content;
        _act.hidden = NO;
        [_act startAnimating];
        
        if (content && ![content isEqualToString:@""]) {
            [_webView loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  bundlePath]]];
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    WEAK_SELF
    
    [_act stopAnimating];
    _act.hidden = YES;
    [_webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.contentView);
        make.bottom.mas_equalTo(weakSelf.extendBtn.mas_top).offset(-16.f);
    }];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    CGFloat height = ceilf([height_str intValue]);
    if (_didLoadWenHeight) {
        _didLoadWenHeight(height + 32.f + 18.f);
    }
    
//    CGFloat webViewHeight = 0.f;
    
//    if ([webView.subviews count] > 0) {
//        UIView *scrollerView = webView.subviews[0];
//        if ([scrollerView.subviews count] > 0) {
//            UIView *webDocView = scrollerView.subviews.lastObject;
//            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
//                webViewHeight = webDocView.frame.size.height;//获取文档的高度
//                if (_didLoadWenHeight) {
//                    _didLoadWenHeight(webViewHeight + 32.f + 18.f);
//                }
//            }
//        }
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
