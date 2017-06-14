//
//  ECAdvertisingViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAdvertisingViewController.h"
#import "NJKWebViewProgress.h"

@interface ECAdvertisingViewController ()<
UIWebViewDelegate,
NJKWebViewProgressDelegate
>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ECAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isHavRightNav) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"同意" style:UIBarButtonItemStylePlain target:self action:@selector(agreeClick:)];
    }
    
    if (!_webView) {
        _webView = [UIWebView new];
    }
    _webView.userInteractionEnabled = NO;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(2.f);
    }];
    
    [self loadWebWithUrlStr:_url];
}

- (void)agreeClick:(id)sender{
    if (self.rightNavClickBlock) {
        self.rightNavClickBlock();
    }
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
    }
    
    [_progressView setProgress:progress animated:NO];
}

@end
