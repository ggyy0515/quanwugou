//
//  CMImageBrowser.m
//  B2CEC
//
//  Created by Tristan on 2017/1/6.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "CMImageBrowser.h"
#import "TAPageControl.h"


#pragma mark - CMImageBrowser

@protocol ImgScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface CMImageBrowser ()
<
    UIScrollViewDelegate,
    ImgScrollViewDelegate
>

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, copy) NSArray <NSString *> *urls;
@property (nonatomic, strong) TAPageControl *pageCtrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger fromIndex;

@end

@interface ImgScrollView : UIScrollView

@property (nonatomic, copy) NSString *imageUrlStr;
@property (nonatomic ,weak) id<ImgScrollViewDelegate> i_delegate;

@end

@implementation CMImageBrowser

+ (void)showBrowserInView:(UIView *)superView
          backgroundColor:(UIColor *)backgroundColor
                imageUrls:(NSArray <NSString *> *)imageUrls
                fromIndex:(NSInteger)fromIndex {
    CMImageBrowser *browser = [[self alloc] initWithSuperView:superView backgroundColor:backgroundColor];
    browser.urls = imageUrls;
    browser.fromIndex = fromIndex;
    [browser initUI];
}

- (instancetype)initWithSuperView:(UIView *)superView
                  backgroundColor:(UIColor *)backgroundColor {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)]) {
        _superView = superView;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

- (void)dealloc {
    ECLog(@"CMImageBrowse dealloc");
}

- (void)initUI {
    
    [_superView addSubview:self];
    self.userInteractionEnabled = YES;
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    [self addSubview:_scrollView];
    _scrollView.backgroundColor = ClearColor;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH * _urls.count, SCREENHEIGHT);
    _scrollView.delegate = self;
    
    
    [_urls enumerateObjectsUsingBlock:^(NSString * _Nonnull urlStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ImgScrollView *subScrollView = [[ImgScrollView alloc] initWithFrame:CGRectMake(idx * SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT)];
        subScrollView.i_delegate = self;
        [_scrollView addSubview:subScrollView];
        subScrollView.imageUrlStr = urlStr;
        
    }];
    _scrollView.contentOffset = CGPointMake(SCREENWIDTH * _fromIndex, 0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    if (!_pageCtrl) {
        _pageCtrl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 80.f, SCREENWIDTH, 30.f)];
    }
    [self addSubview:_pageCtrl];
    _pageCtrl.numberOfPages = _urls.count;
    _pageCtrl.dotColor = [UIColor whiteColor];
    _pageCtrl.currentPage = _fromIndex;
    _pageCtrl.userInteractionEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREENWIDTH;
    _pageCtrl.currentPage = index;
}

- (void)tapImageViewTappedWithObject:(id)sender {
    self.hidden = YES;
    [self removeFromSuperview];
}


@end

#pragma mark - ImgScrollView

@interface ImgScrollView ()
<
    UIScrollViewDelegate
>

@property (nonatomic, strong) UIImageView *imgView;

@property (assign,nonatomic) CGFloat currentScale;

@end


@implementation ImgScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1;
        self.maximumZoomScale = 2.f;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.userInteractionEnabled = YES;
        [self addSubview:_imgView];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [_imgView addGestureRecognizer:singleTapGestureRecognizer];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleGesture:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_imgView addGestureRecognizer:doubleTapGestureRecognizer];
        
        
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    }
    return self;
}

- (void)singleTap:(id)sender{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)])
    {
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}

-(void)doubleGesture:(UIGestureRecognizer *)sender{
    
    //当前倍数等于最大放大倍数
    //双击默认为缩小到原图
    if (_currentScale == 2.f) {
        _currentScale = 1.f;
        [self setZoomScale:_currentScale animated:YES];
        return;
    }
    //当前等于最小放大倍数
    //双击默认为放大到最大倍数
    if (_currentScale == 1.f) {
        _currentScale = 2.f;
        [self setZoomScale:_currentScale animated:YES];
        return;
    }
    
    CGFloat aveScale = 1.f + (2.f - 1.f)/2.0;//中间倍数
    
    //当前倍数大于平均倍数
    //双击默认为放大最大倍数
    if (_currentScale >= aveScale) {
        _currentScale = 2.f;
        [self setZoomScale:_currentScale animated:YES];
        return;
    }
    
    //当前倍数小于平均倍数
    //双击默认为放大到最小倍数
    if (_currentScale < aveScale) {
        _currentScale = 1.f;
        [self setZoomScale:_currentScale animated:YES];
        return;
    }
}

- (void)dealloc {
    ECLog(@"ImgScrollView dealloc");
}

- (void)setImageUrlStr:(NSString *)imageUrlStr {
    _imageUrlStr = imageUrlStr;
    [_imgView yy_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                     placeholder:[UIImage imageNamed:@"placeholder_goods2"]
                         options:(YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowInvalidSSLCertificates)
                      completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                          _imgView.frame = CGRectMake(0,
                                                      SCREENHEIGHT / 2.f - SCREENWIDTH * (image.size.height / image.size.width) / 2.f,
                                                      SCREENWIDTH,
                                                      SCREENWIDTH * (image.size.height / image.size.width));
                      }];
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    _imgView.center = centerPoint;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.currentScale = scale;
}

@end



