//
//  ECProductDetailWebView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductDetailWebView.h"
#import "NJKWebViewProgress.h"

@interface ECProductDetailWebView ()
<
    UIWebViewDelegate,
    NJKWebViewProgressDelegate
>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, copy) NSString *protable;
@property (nonatomic, copy) NSString *proId;

@end

@implementation ECProductDetailWebView

#pragma mark - Life Cycle

- (instancetype)initWithPritable:(NSString *)protable proId:(NSString *)proId {
    if (self = [super init]) {
        _protable = protable;
        _proId = proId;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/product/intro/%@/%@", HOST_ADDRESS, [ECHTTPServer loadApiVersion], _protable, _proId];
    
    
    if (!_webView) {
        _webView = [UIWebView new];
    }
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (!_progressProxy) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
    }
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0;
        _progressView.progressTintColor = MainColor;
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf);
        make.height.mas_equalTo(2.f);
    }];
    
    [self loadWebWithUrlStr:urlStr];
}

#pragma mark - Actions

- (void)loadWebWithUrlStr:(NSString *)urlStr {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
    [_webView loadRequest:req];
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
        [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        
        [_webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    }
    
    [_progressView setProgress:progress animated:NO];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
