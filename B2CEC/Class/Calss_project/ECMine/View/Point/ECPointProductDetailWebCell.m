//
//  ECPointProductDetailWebCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductDetailWebCell.h"

@interface ECPointProductDetailWebCell ()
<
    UIWebViewDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *sideView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, assign) BOOL needLoadWeb;

@end

@implementation ECPointProductDetailWebCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _needLoadWeb = YES;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_sideView) {
        _sideView = [UIView new];
    }
    [self.contentView addSubview:_sideView];
    _sideView.backgroundColor = MainColor;
    [_sideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(24.f);
        make.size.mas_equalTo(CGSizeMake(3.f, 15.f));
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_28;
    _titleLabel.textColor = DarkMoreColor;
    _titleLabel.text = @"商品详情";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.sideView.mas_right).offset(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(weakSelf.sideView.mas_bottom);
        make.height.mas_equalTo(weakSelf.titleLabel.font.lineHeight);
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
        make.top.mas_equalTo(weakSelf.sideView.mas_bottom).offset(16.f);
        make.left.right.bottom.mas_equalTo(weakSelf.contentView);
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
        _content = content;
        _needLoadWeb = NO;
        _act.hidden = NO;
        [_act startAnimating];
        
        if (content && ![content isEqualToString:@""]) {
            [_webView loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]  bundlePath]]];
        }
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [_act stopAnimating];
    _act.hidden = YES;
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    CGFloat height = ceilf([height_str intValue]);
    if (_didLoadWenHeight) {
        _didLoadWenHeight(height +24.f + 15.f + 16.f + 5.f);
    }
    
//    CGFloat webViewHeight = 0.f;
    
//    if ([webView.subviews count] > 0) {
//        UIView *scrollerView = webView.subviews[0];
//        if ([scrollerView.subviews count] > 0) {
//            UIView *webDocView = scrollerView.subviews.lastObject;
//            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
//                webViewHeight = webDocView.frame.size.height;//获取文档的高度
//                if (_didLoadWenHeight) {
//                    _didLoadWenHeight(webViewHeight +24.f + 15.f + 16.f + 5.f);
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
