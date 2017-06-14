//
//  ECNewsInfoHtmlTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInfoHtmlTableViewCell.h"
#import "TFHpple.h"
#import "CMImageBrowser.h"

@interface ECNewsInfoHtmlTableViewCell() <
    UIWebViewDelegate,
    NSURLConnectionDelegate,
    NSURLConnectionDataDelegate,
    UIGestureRecognizerDelegate
>

@property (strong,nonatomic) UIWebView *webView;

@property (nonatomic, assign) BOOL authenticated;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSArray *webImagePathArray;

@end

@implementation ECNewsInfoHtmlTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECNewsInfoHtmlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoHtmlTableViewCell)];
    if (cell == nil) {
        cell = [[ECNewsInfoHtmlTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsInfoHtmlTableViewCell)];
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
    if (!_webView) {
        _webView = [UIWebView new];
    }
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
    [self.contentView addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0.f);
//        make.left.mas_equalTo(18.f);
//        make.right.mas_equalTo(-18.f);
    }];
    UITapGestureRecognizer *aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTap:)];
    aTap.delegate = self;
    [_webView addGestureRecognizer:aTap];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
     CGFloat height = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 20.f;
    if (self.loadHtmlHeightBlock) {
        self.loadHtmlHeightBlock(height);
    }
    
    NSString *allJs = @"document.documentElement.innerHTML";
    NSString *allHtmlContent = [webView stringByEvaluatingJavaScriptFromString:allJs];
    _webImagePathArray = [self filterImgInHtmlString:allHtmlContent];
}

- (void)loadHtmlWithConntent:(NSString *)webContent WithNeed:(BOOL)isNeedLoadHtml{
    if (isNeedLoadHtml) {
        _request = [NSURLRequest requestWithURL:[NSURL URLWithString:webContent]];
        [_webView loadRequest:_request];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"WebController received response via NSURLConnection");
    
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_webView loadRequest:_request];
    
    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
    [_urlConnection cancel];
}

#pragma mark - Web ElementAction

-(NSArray*)filterImgInHtmlString:(NSString*)htmlContent {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLString:htmlContent];
    NSArray *images = [doc searchWithXPathQuery:@"//img"];
    NSString *imgUrl = nil;
    NSMutableArray *imgUrlArray = [NSMutableArray array];
    for (int i = 0; i < [images count]; i++)
    {
        imgUrl = [[images objectAtIndex:i] objectForKey:@"src"];
        [imgUrlArray addObject:imgUrl];
    }
    return imgUrlArray;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognize {
    [self webViewTap:gestureRecognize];
    return YES;
}
- (void)webViewTap:(UIGestureRecognizer*)sender {
    //  <Find HTML tag which was clicked by user>
    //  <If tag is IMG, then get image URL and start show>
    CGPoint pt = [sender locationInView:_webView];
    NSLog(@"handleSingleTap!pointx:%f,y:%f",pt.x,pt.y);
    
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString * tagName = [_webView stringByEvaluatingJavaScriptFromString:js];
    if ([tagName length] > 0 && [[tagName lowercaseString] isEqualToString:@"img"]) {
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        NSString *tapedImagePath = [_webView stringByEvaluatingJavaScriptFromString:imgURL];
        NSInteger index = [_webImagePathArray indexOfObject:tapedImagePath];
        [CMImageBrowser showBrowserInView:SELF_VC_BASEVAV.view backgroundColor:[UIColor blackColor] imageUrls:_webImagePathArray fromIndex:index];
    }
    
}


@end
