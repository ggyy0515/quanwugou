//
//  ECUserInfoDesignerResumeTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/6.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoDesignerResumeTableViewCell.h"

@interface ECUserInfoDesignerResumeTableViewCell()<
    UIWebViewDelegate,
    NSURLConnectionDelegate,
    NSURLConnectionDataDelegate
>

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *titleLineView;

@property (strong,nonatomic) UIWebView *contentWebView;

@property (nonatomic, assign) BOOL authenticated;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation ECUserInfoDesignerResumeTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoDesignerResumeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoDesignerResumeTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoDesignerResumeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoDesignerResumeTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"个人介绍";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.backgroundColor = UIColorFromHexString(@"5e5e61");
    _titleLab.font = FONT_32;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_titleLineView) {
        _titleLineView = [UIView new];
    }
    _titleLineView.backgroundColor = UIColorFromHexString(@"5e5e61");
    
    if (!_contentWebView) {
        _contentWebView = [UIWebView new];
    }
    _contentWebView.scrollView.scrollEnabled = NO;
    _contentWebView.delegate = self;
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_titleLineView];
    [self.contentView addSubview:_contentWebView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.f);
        make.left.mas_equalTo(12.f);
        make.height.mas_equalTo(28.f);
        make.width.mas_equalTo(80.f);
    }];
    
    [_titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.bottom.mas_equalTo(weakSelf.titleLab.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
    
    [_contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLineView);
        make.top.mas_equalTo(weakSelf.titleLineView.mas_bottom).offset(20.f);
        make.bottom.mas_equalTo(0.f);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = [[_contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 20.f;
    if (self.loadHtmlHeightBlock) {
        self.loadHtmlHeightBlock(height);
    }
}

- (void)loadHtmlWithConntent:(NSString *)webContent WithNeed:(BOOL)isNeedLoadHtml{
    if (isNeedLoadHtml) {
        _request = [NSURLRequest requestWithURL:[NSURL URLWithString:webContent]];
        [_contentWebView loadRequest:_request];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (!_authenticated) {
        _authenticated = NO;
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [_urlConnection start];
        return NO;
    }
    return YES;
}

#pragma mark - NURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"WebController Got auth challange via NSURLConnection");
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_contentWebView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}


@end
