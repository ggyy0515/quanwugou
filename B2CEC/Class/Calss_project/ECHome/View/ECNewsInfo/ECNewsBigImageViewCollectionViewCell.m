//
//  ECNewsBigImageViewCollectionViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsBigImageViewCollectionViewCell.h"

@interface ECNewsBigImageViewCollectionViewCell()<
UIScrollViewDelegate
>

@property (strong,nonatomic) UIScrollView *bigScrollView;


@property (strong,nonatomic) UIImageView *bigImageView;

@end

@implementation ECNewsBigImageViewCollectionViewCell

+(instancetype)CellWithCollectionView:(UICollectionView *)CollectionView WithIndexPath:(NSIndexPath *)indexPath{
    ECNewsBigImageViewCollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsBigImageViewCollectionViewCell) forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createBasicUI];
        [self addGesture];
    }
    return self;
}
- (void)createBasicUI{
    WEAK_SELF
    
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT)];
    }
    _bigScrollView.delegate = self;
    _bigScrollView.maximumZoomScale = 3.f;
    _bigScrollView.minimumZoomScale = 1.f;
    
    
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 110.f, 72.f)];
    }
    _bigImageView.center = _bigScrollView.center;
    _bigImageView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_bigScrollView];
    [_bigScrollView addSubview:_bigImageView];

}

- (void)addGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapClick:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.bigImageView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGestureDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapDoubleClick:)];
    tapGestureDouble.cancelsTouchesInView = NO;
    tapGestureDouble.numberOfTapsRequired = 2;
    [self.bigImageView addGestureRecognizer:tapGestureDouble];
    
    [tapGesture requireGestureRecognizerToFail:tapGestureDouble];
}

- (void)TapClick:(id)sender{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.bigScrollView.zoomScale = 1.0 ;
//    }] ;
    if (_hideAction) {
        _hideAction();
    }
}

- (void)TapDoubleClick:(UITapGestureRecognizer *)sender{
    CGFloat scale = self.bigScrollView.zoomScale == 1.f ? 3.f : 1.f;
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[sender locationInView:sender.view]];
    [self.bigScrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height = self.bigScrollView.frame.size.height / scale;
    zoomRect.size.width  = self.bigScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)setModel:(ECHomeNewsImageListModel *)model{
    _model = model;
    
    WEAK_SELF
    //
//    showLoadingGif(self.contentView)
    [self.bigImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                              placeholder:[UIImage imageNamed:@"placeholder_News2"]
                                  options:(YYWebImageOptionProgressiveBlur | YYWebImageOptionAllowInvalidSSLCertificates)
                               completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                   CGFloat height = 0.f;
                                   if (image.size.width != 0) {
                                       height = SCREENWIDTH * image.size.height / image.size.width;
                                   }
                                   weakSelf.bigImageView.frame = CGRectMake(0.f, 0.f, SCREENWIDTH, height);
                                   weakSelf.bigImageView.center = weakSelf.bigScrollView.center;
                                   weakSelf.bigScrollView.contentSize = weakSelf.bigImageView.frame.size;
                                   
//                                   dismisLoadingGif(weakSelf.contentView)
                               }];
    
    self.bigScrollView.zoomScale = 1.f;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.bigImageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    self.bigImageView.center = CGPointMake(xcenter, ycenter);
}

@end
