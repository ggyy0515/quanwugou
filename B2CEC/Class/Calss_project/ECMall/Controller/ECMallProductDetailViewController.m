//
//  ECMallProductDetailViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//


#import "ECMallProductDetailViewController.h"
#import "ECMallNavTagView.h"
#import "ECMallProductDetailBottomView.h"
#import "ECProductDetailProductView.h"
#import "ECProductDetailWebView.h"
#import "ECProductDetailAppraiseView.h"
#import "ECProductDetailBrandStoryView.h"
#import "ECMallProductModel.h"
#import "ECMoreProductViewController.h"
#import "ECMoreProductDetailViewController.h"
#import "ECCartViewController.h"
#import "ECCartFactoryModel.h"
#import "ECCartProductModel.h"
#import "ECConfirmOrderViewController.h"
#import "ChatViewController.h"


@interface ECMallProductDetailViewController ()
<
    CAAnimationDelegate
>

/**
 顶部页签
 */
@property (nonatomic, strong) ECMallNavTagView *navTagView;
/**
  购物车按钮
 */
@property (nonatomic, strong) UIButton *shareBtn;
/**
 底部视图
 */
@property (nonatomic, strong) ECMallProductDetailBottomView *bottomView;
/**
 商品视图
 */
@property (nonatomic, strong) ECProductDetailProductView *productView;
/**
 商品详情视图
 */
@property (nonatomic, strong) ECProductDetailWebView *detailWebView;
/**
 商品评论
 */
@property (nonatomic, strong) ECProductDetailAppraiseView *appraiseView;
/**
 品牌故事
 */
@property (nonatomic, strong) ECProductDetailBrandStoryView *storyView;
/**
 更多商品数据源
 */
@property (nonatomic, strong) NSMutableArray <ECMallProductModel *> *moreProductDataSource;
/**
 是否是抢购
 */
@property (nonatomic, assign) BOOL isPanicBuy;
/**
 是否是尾货
 */
@property (nonatomic, assign) BOOL isLeftProduct;
/**
 库存
 */
@property (nonatomic, copy) NSString *stock;
/**
 商品对应的工厂用户id（环信id）
 */
@property (nonatomic, copy) NSString *factoryUserId;
/**
 用于立即购买的数据模型
 */
@property (nonatomic, strong) ECCartFactoryModel *cartFactoryModel;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGFloat beganX;
@property (nonatomic, assign) CGFloat beganY;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, strong) UIView *amView;
//----滑动手势----//

/**
 *  加入购物车动画图层
 */
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic, strong) UIImageView *animationIV;

/**
 用户分享的商品名
 */
@property (strong,nonatomic) NSString *productTitle;

@end

@implementation ECMallProductDetailViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _moreProductDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _bottomView.count = [CMPublicDataManager sharedCMPublicDataManager].cartNumber;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_animationIV) {
        _animationIV = [UIImageView new];
        [_animationIV setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    }
    
    if (!_navTagView) {
        _navTagView = [[ECMallNavTagView alloc] initWithFrame:CGRectMake(0, 0, 250.f, 33.f)];
    }
    [_navTagView setDataSource:@[@"商品",@"详情",@"评价",@"品牌故事"].mutableCopy currentIndex:0];
    self.navigationItem.titleView = _navTagView;
    [_navTagView setDidSelectIndex:^(NSInteger index) {
        UIView *nextView = [weakSelf.amView viewWithTag:index + 100];
        UIView *currView = [weakSelf.amView viewWithTag:weakSelf.currIndex + 100];
        currView.hidden = YES;
        nextView.hidden = NO;
        weakSelf.currIndex = index;
    }];
    
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.f, 22.f)];
    }
    [_shareBtn setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [_shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 6.f, 0, -6.f)];
    [_shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [CMPublicMethod shareToPlatformWithTitle:weakSelf.productTitle WithLink:[NSString stringWithFormat:@"%@protable=%@&proid=%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.productShareUrl,weakSelf.protable,weakSelf.proId] WithQCode:NO];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];
    
    if (!_bottomView) {
        _bottomView = [[ECMallProductDetailBottomView alloc] init];
    }
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49.f);
    }];
    _bottomView.count = [CMPublicDataManager sharedCMPublicDataManager].cartNumber;
    
    if (!_amView) {
        _amView = [UIView new];
    }
    [self.view addSubview:_amView];
    [_amView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    _amView.backgroundColor = [UIColor clearColor];
    
    
    //-------begin subViews----------//
    if (!_productView) {
        _productView = [[ECProductDetailProductView alloc] initWithProtable:_protable proId:_proId];
    }
    [_amView addSubview:_productView];
    [_productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _productView.tag = 100;
    _productView.hidden = NO;
    
    if (!_detailWebView) {
        _detailWebView  =[[ECProductDetailWebView alloc] initWithPritable:_protable proId:_proId];
    }
    [_amView addSubview:_detailWebView];
    [_detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _detailWebView.hidden = YES;
    _detailWebView.tag = 101;
    
    if (!_appraiseView) {
        _appraiseView = [[ECProductDetailAppraiseView alloc] initWithProId:_proId];
    }
    [_amView addSubview:_appraiseView];
    [_appraiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _appraiseView.tag = 102;
    _appraiseView.hidden = YES;
    
    if (!_storyView) {
        _storyView = [[ECProductDetailBrandStoryView alloc] initWithProtable:_protable proId:_proId];
    }
    [_amView addSubview:_storyView];
    [_storyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _storyView.hidden = YES;
    _storyView.tag = 103;
    
    _currIndex = 0;
    
    //-----------end subViews---------//
    
    //view actions
    //获取到库存后的回调
    [_productView setDidGetStock:^(NSString *stock) {
        weakSelf.bottomView.hidden = NO;
        weakSelf.stock = stock;
    }];
    //获取到商品名后的回调
    [_productView setGetProductTitleBlock:^(NSString *name) {
        weakSelf.productTitle = name;
    }];
    //加载更多商品页面数据源
    [_productView setDidLoadProductSerise:^(NSString *serise) {
        [weakSelf loadMoreProductListWithSerise:serise];
    }];
    [_productView setDidLoadProductAnimationPic:^(NSURL *url) {
        [weakSelf.animationIV yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    }];
    //点击更多商品
    [_productView setMoreBtnClick:^{
        [weakSelf showMoreProductVC];
    }];
    //点击更多评论
    [_productView setMoreAppraiseAction:^{
        UIView *currView = [weakSelf.amView viewWithTag:weakSelf.currIndex + 100];
        currView.hidden = YES;
        weakSelf.appraiseView.hidden = NO;
        [weakSelf.navTagView scrollToIndex:2];
        weakSelf.currIndex = 2;
    }];
    //查看商品图文详情
    [_productView setCheckWebDetailAction:^{
        UIView *currView = [weakSelf.amView viewWithTag:weakSelf.currIndex + 100];
        currView.hidden = YES;
        weakSelf.detailWebView.hidden = NO;
        [weakSelf.navTagView scrollToIndex:1];
        weakSelf.currIndex = 1;
    }];
    //设置收藏状态
    [_productView setUpdateCollectionState:^(BOOL isCollect) {
        [weakSelf changeCollectState:isCollect];
    }];
    //获取到是否是抢购状态
    [_productView setDidGetPanicBuyState:^(BOOL isPanicBuy) {
        weakSelf.isPanicBuy = isPanicBuy;
        [weakSelf updateBottomViewState];
    }];
    //获取到是否是尾货
    [_productView setDidGetLeftProductState:^(BOOL isLeftProduct) {
        weakSelf.isLeftProduct = isLeftProduct;
        [weakSelf updateBottomViewState];
    }];
    //获取到工厂用户id
    [_productView setDidGetFactoryUserId:^(NSString *factoryUserId) {
        weakSelf.factoryUserId = factoryUserId;
    }];
    //获取到立即购买需要的数据模型
    [_productView setDidGetCartModel:^(ECCartFactoryModel *model) {
        weakSelf.cartFactoryModel = model;
    }];
    //点击底部收藏商品
    [_bottomView setClickCollectBtn:^{
        [weakSelf collectProductWithProtable:weakSelf.protable proId:weakSelf.proId succeed:^(BOOL isSucceed) {
            if (isSucceed) {
                [weakSelf changeCollectState:!weakSelf.bottomView.collectBtn.selected];
            }
        }];
    }];
    //点击加入购物车
    [_bottomView setClickAddToCartBtn:^{
        [weakSelf addProductToCart];
    }];
    //点击购物车
    [_bottomView setClickCartBtn:^{
        [weakSelf gotoCartVC];
    }];
    //点击立即购买
    [_bottomView setClickBuyBtn:^{
        [weakSelf buyNow];
    }];
    //点击联系客服
    [_bottomView setClicksServiceBtn:^{
        if (weakSelf.factoryUserId) {
            ChatViewController *vc = [[ChatViewController alloc] initWithConversationChatter:weakSelf.factoryUserId
                                                                            conversationType:EMConversationTypeChat];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [SVProgressHUD showInfoWithStatus:@"没有获取到工厂客服信息"];
        }
    }];
    
 
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
}


#pragma mark - Actions

- (void)loadMoreProductListWithSerise:(NSString *)serise {
    [ECHTTPServer requestMoreProductListWithProtable:_protable
                                              serise:serise
                                             succeed:^(NSURLSessionDataTask *task, id result) {
                                                 if (IS_REQUEST_SUCCEED(result)) {
                                                     [_moreProductDataSource removeAllObjects];
                                                     [result[@"recommendProduct"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         ECMallProductModel *model = [ECMallProductModel yy_modelWithDictionary:dic];
                                                         [_moreProductDataSource addObject:model];
                                                     }];
                                                 } else {
                                                    EC_SHOW_REQUEST_ERROR_INFO
                                                 }
                                             }
                                              failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                 RequestFailure
                                              }];
}

- (void)showMoreProductVC {
    WEAK_SELF
    
    ECMoreProductViewController *vc = [[ECMoreProductViewController alloc] initWithDataSource:_moreProductDataSource];
    
    vc.view.bounds = CGRectMake(0, 0, SCREENWIDTH, 124.f);
//    vc.view.cornerRadius = 10;
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    [vc setBlurParameters:blurParameters];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionRight];
    [vc setDidClickProductAtIndex:^(NSInteger index, UICollectionViewCell *cell) {
        CGRect rect = [cell convertRect:cell.contentView.frame toView:weakSelf.navigationController.view];
        [weakSelf showMoreProductDetailVCWithIndex:index originFrame:rect];
    }];
    [self.navigationController presentPopinController:vc
                                             animated:YES
                                           completion:^{
                                               
                                           }];
}

- (void)showMoreProductDetailVCWithIndex:(NSInteger)index originFrame:(CGRect)originFrame {
    WEAK_SELF
    
    if (_moreProductDataSource.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"暂时没有同类型的商品"];
        return;
    }
    
    ECMallProductModel *model = [_moreProductDataSource objectAtIndexWithCheck:index];
    typeof(model) __weak weakModel = model;
    ECMoreProductDetailViewController *vc = [[ECMoreProductDetailViewController alloc] initWithProductModel:model];
    
    vc.view.bounds = CGRectMake(0, 0, 470.f / 2.f, 700.f / 2.f);
    //    vc.view.cornerRadius = 10;
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleZoomFromOriginPoint];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    blurParameters.originFrame = originFrame;
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    [vc setBlurParameters:blurParameters];
//    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [self.navigationController presentPopinController:vc
                                             animated:YES
                                           completion:^{
                                               
                                           }];
//    [self.navigationController presentPopinController:vc fromRect:CGRectMake(0, 0, 470.f / 2.f, 700.f / 2.f) needComputeFrame:NO animated:YES completion:^{
//        
//    }];
    [vc setToDetailBtnClick:^{
        [weakSelf.navigationController dismissCurrentPopinControllerAnimated:YES completion:^{
            [weakSelf.navigationController dismissCurrentPopinControllerAnimated:YES completion:^{
                [weakSelf gotoAnotherProductDetailWithModel:weakModel];
            }];
        }];
    }];
    [vc setCollectBtnClick:^{
        [weakSelf collectProductWithProtable:weakModel.protable proId:weakModel.proId succeed:^(BOOL isSucceed) {
            
        }];
    }];
    
}

- (void)gotoAnotherProductDetailWithModel:(ECMallProductModel *)model {
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.protable = model.protable;
    vc.proId = model.proId;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
}

- (void)collectProductWithProtable:(NSString *)protable
                             proId:(NSString *)proId
                           succeed:(void(^)(BOOL isSucceed))succeed {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    [ECHTTPServer requestCollectProductWithProtable:protable
                                              proId:proId
                                             userId:[Keychain objectForKey:EC_USER_ID]
                                            succeed:^(NSURLSessionDataTask *task, id result) {
                                                if (IS_REQUEST_SUCCEED(result)) {
                                                    RequestSuccess(result)
                                                    succeed(YES);
                                                } else {
                                                    EC_SHOW_REQUEST_ERROR_INFO
                                                }
                                            }
                                             failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                RequestFailure
                                             }];
}

- (void)changeCollectState:(BOOL)isCollect {
    if (isCollect) {
        _bottomView.collectBtn.selected = YES;
    } else {
        _bottomView.collectBtn.selected = NO;
    }
}

- (void)addProductToCart {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    if (_isPanicBuy || _isLeftProduct) {
        if (_stock.integerValue < 1) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
    }
    [ECHTTPServer requestAddToCartWithUserId:[Keychain objectForKey:EC_USER_ID]
                                       proId:_proId
                                    protable:_protable
                                       count:1
                                     succeed:^(NSURLSessionDataTask *task, id result) {
                                         if (IS_REQUEST_SUCCEED(result)) {
                                             [CMPublicDataManager sharedCMPublicDataManager].cartNumber ++ ;
                                             [self callAnimation];
                                         } else {
                                             EC_SHOW_REQUEST_ERROR_INFO
                                         }
                                     }
                                      failed:^(NSURLSessionDataTask *task, NSError *error) {
                                         RequestFailure
                                      }];
}

- (void)updateBottomViewState {
    WEAK_SELF
    if (_isPanicBuy || _isLeftProduct) {
        [_bottomView.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(weakSelf.bottomView);
            make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f) * 2);
        }];
        [_bottomView.addToCartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.bottomView.buyBtn.mas_left);
            make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f));
            make.bottom.top.mas_equalTo(weakSelf.bottomView);
        }];
        _bottomView.buyBtn.backgroundColor = UIColorFromHexString(@"#333333");
        _bottomView.addToCartBtn.hidden = YES;
    } else {
        [_bottomView.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(weakSelf.bottomView);
            make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f));
        }];
        [_bottomView.addToCartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakSelf.bottomView);
            make.right.mas_equalTo(weakSelf.bottomView.buyBtn.mas_left);
            make.width.mas_equalTo(SCREENWIDTH * (232.f / 750.f));
        }];
        _bottomView.buyBtn.backgroundColor = UIColorFromHexString(@"#EB3A41");
        _bottomView.addToCartBtn.hidden = NO;
    }
}

- (void)gotoCartVC {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    ECCartViewController *VC = [[ECCartViewController alloc] init];
    [SELF_BASENAVI pushViewController:VC animated:YES titleLabel:@"购物车"];
}

- (void)buyNow {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    if (_isPanicBuy || _isLeftProduct) {
        if (_stock.integerValue < 1) {
            [SVProgressHUD showInfoWithStatus:@"库存不足"];
            return;
        }
    }
    ECConfirmOrderViewController *vc = [[ECConfirmOrderViewController alloc] init];
    vc.isPanicBuy = _isPanicBuy;
    vc.isLeftProduct = _isLeftProduct;
    vc.confirmType = ConfirmOrderType_buyNow;
    NSMutableArray *array = [NSMutableArray arrayWithObject:_cartFactoryModel.mutableCopy];
    vc.dataSource = array;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"确认订单"];
}


#pragma mark - Pan Animation

- (void)panGesture:(id)sender {
    UIPanGestureRecognizer *panGestureRecognizer;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        _beganX = translation.x;
        _beganY = translation.y;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y - _beganY) < fabs(translation.x - _beganX)) {
            if (translation.x > _beganX && (translation.x - _beganX)>OFFSET_TRIGGER_DIRECTION) {
              //goBack
                if (_currIndex > 0) {
                     ECLog(@"go left");
                    [self changeNum:-1];
                }
            }else if (translation.x < _beganX && (_beganX - translation.x)>OFFSET_TRIGGER_DIRECTION){
                //goForward
                if (_currIndex < 3) {
                    ECLog(@"go right");
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

-(void)changeNum:(NSInteger)num {
    UIView *currView = [_amView viewWithTag:_currIndex + 100];
    UIView *nextView = [_amView viewWithTag:_currIndex + num + 100];
    [_navTagView scrollToIndex:_currIndex + num];
    currView.hidden = YES;
    nextView.hidden = NO;
    if (num < 0) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [[_amView layer] addAnimation:animation forKey:@"animation"];
    } else if (num > 0){
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        [[_amView layer] addAnimation:animation forKey:@"animation"];
    }
    _currIndex = _currIndex + num;
}


#pragma mark - Add To Cart Animation

- (void)callAnimation {
    [self startAnimationWithRect:CGRectMake(SCREENWIDTH - SCREENWIDTH * (232.f / 750.f) * 2 + SCREENWIDTH * (232.f / 750.f) / 2.f,
                                            SCREENHEIGHT - 30.f,
                                            50,
                                            50)
                       ImageView:_animationIV];
}

-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    if (!_layer) {
        _layer = [CALayer layer];
        _layer.contents = (id)imageView.layer.contents;
        _layer.contentsGravity = kCAGravityResizeAspectFill;
        _layer.bounds = rect;
        _layer.masksToBounds = YES;
        _layer.position = CGPointMake(rect.origin.x, rect.origin.y);
        [self.view.layer addSublayer:_layer];
        self.path = [UIBezierPath bezierPath];
        [_path moveToPoint:_layer.position];
        [_path addQuadCurveToPoint:CGPointMake(SCREENWIDTH - SCREENWIDTH * (232.f / 750.f) * 2 - 49.f / 2.f, SCREENHEIGHT - 30.0) controlPoint:CGPointMake(SCREENWIDTH/3.0,SCREENHEIGHT - 300)];
    }
    [self groupAnimation];
}
-(void)groupAnimation
{
    self.view.userInteractionEnabled = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:0.5f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.3f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.5f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
        self.view.userInteractionEnabled = YES;
        [_layer removeFromSuperlayer];
        _layer = nil;
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        _bottomView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [_bottomView.animationView.layer addAnimation:shakeAnimation forKey:nil];
    }
    _bottomView.count = [CMPublicDataManager sharedCMPublicDataManager].cartNumber;
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
