//
//  ECMallViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallViewController.h"
#import "ECMallTagView.h"
#import "ECMallAllView.h"
#import "ECMallDataParser.h"
#import "ECMallHomeCatView.h"
#import "ECMallTagModel.h"
#import "ECMallSearchViewController.h"
#import "ECCartViewController.h"
#import "ECSelectCityViewController.h"
//cc
#import "ECSelectAddressViewController.h"
#import "ECAddAddressViewController.h"


@interface ECMallViewController ()
<
    CAAnimationDelegate
>

/**
 导航栏底部的线
 */
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;
/**
 切换城市按钮
 */
@property (nonatomic, strong) UIButton *cityBtn;
/**
 城市名
 */
@property (nonatomic, copy) NSString *cityString;
/**
 搜索栏
 */
@property (nonatomic, strong) UIView *searchView;
/**
  购物车按钮
 */
@property (nonatomic, strong) UIButton *cartBtn;
/**
 顶部分类选择视图
 */
@property (nonatomic, strong) ECMallTagView *topView;
/**
 “全部”的view
 */
@property (nonatomic, strong) ECMallAllView *allView;
/**
 分类视图
 */
@property (nonatomic, strong) ECMallHomeCatView *catView;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGFloat beganX;
@property (nonatomic, assign) CGFloat beganY;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, strong) UIView *amView;
//----滑动手势----//

@end

//[{\"attrcode\":\"\U5361\U68ee\U6d77\U6d3e\U540d\U5bb6\",\"attrvalue\":\"BrandPPjiaju\"}]";
//[{\"attrcode\":\"BrandPPjiaju\",\"attrvalue\":\"\U5361\U68ee\U6d77\U6d3e\U540d\U5bb6\"}]

@implementation ECMallViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //更新购物车数量
    [APP_DELEGATE updateCartNumberCacheFromNetwork];
    
    if (!_navBarHairlineImageView) {
        _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
    if (![[CMLocationManager sharedCMLocationManager].userCityName isEqualToString:@""]) {
        [self setCityString:[CMLocationManager sharedCMLocationManager].userCityName];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    _navBarHairlineImageView.hidden = NO;
    [super viewWillDisappear:animated];
}

- (void)createUI {
    WEAK_SELF
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    if (!_cityBtn) {
        _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    [_cityBtn setTitle:@"城市" forState:UIControlStateNormal];
    [_cityBtn setImage:[UIImage imageNamed:@"nav_citymore"] forState:UIControlStateNormal];
    _cityBtn.titleLabel.font = FONT_24;
    [_cityBtn setTitleColor:DarkColor forState:UIControlStateNormal];
    [_cityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    CGFloat cityWidth = ceilf([@"城市" boundingRectWithSize:CGSizeMake(1000, 40)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:FONT_24}
                                                context:nil].size.width);
    _cityBtn.frame = CGRectMake(0, 0, cityWidth + 9.f, 40.f);
    [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, cityWidth, 0, -cityWidth)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
    [_cityBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
//        [weakSelf gotoSelectCityVC];
        ECSelectCityViewController *vc = [[ECSelectCityViewController alloc] init];
        vc.type = 1;
        [vc setSelectCityBlock:^(ECCityModel *model1, ECCityModel *model2) {
            [weakSelf loadDataSource];
        }];
        [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择城市"];
    }];
    
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * (528.f / 750.f), 26.f)];
    }
    _searchView.backgroundColor = BaseColor;
    _searchView.layer.cornerRadius = 1.f;
    UIImageView *glassImageView = [UIImageView new];
    [_searchView addSubview:glassImageView];
    [glassImageView setImage:[UIImage imageNamed:@"shop_nav_search"]];
    [glassImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.searchView.mas_centerY);
        make.left.mas_equalTo(weakSelf.searchView.mas_left).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
    }];
    self.navigationItem.titleView = _searchView;
    [_searchView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weakSelf gotoSearchVC];
    }];
    
    if (!_cartBtn) {
        _cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.f, 22.f)];
    }
    [_cartBtn setImage:[[UIImage imageNamed:@"nav_shop"] imageWithColor:MainColor] forState:UIControlStateNormal];
    [_cartBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 6.f, 0, -6.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cartBtn];
    [_cartBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (!EC_USER_WHETHERLOGIN) {
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf
                                              jumpToMian:NO
                                   clearCurrentLoginInfo:YES
                                                 succeed:^{
                                                     
                                                 }];
            return;
        }
        ECCartViewController *vc = [[ECCartViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"购物车"];
    }];
    
    if (!_topView) {
        _topView = [[ECMallTagView alloc] init];
    }
    [self.view addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(0);
    }];
    [_topView setDidSelectCatAtIndex:^(NSInteger index) {
        weakSelf.currIndex = index;
        if (index == 0) {
            [weakSelf showAllView];
        } else {
            ECMallTagModel *model = [[CMPublicDataManager sharedCMPublicDataManager].mallTagDataSource objectAtIndexWithCheck:index - 1];
            weakSelf.catView.attrs = nil;
            [weakSelf showCatViewWithCatCode:model.code];
        }
    }];
    
    if (!_amView) {
        _amView = [UIView new];
    }
    [self.view addSubview:_amView];
    _amView.backgroundColor = ClearColor;
    [_amView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
    }];
    
    if (!_allView) {
        _allView = [[ECMallAllView alloc] init];
    }
    [_amView addSubview:_allView];
    [_allView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_allView setDidClickFloor:^(NSString *attrCode, NSString *attrValue, NSString *code) {
        [weakSelf.topView.dataSource enumerateObjectsUsingBlock:^(ECMallTagModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.code isEqualToString:code]) {
                [weakSelf.topView scrollToIndex:idx];
                weakSelf.currIndex = idx;
                *stop = YES;
            }
        }];
        NSArray *arr = @[@{@"attrcode":attrCode,
                           @"attrvalue":attrValue}];
        weakSelf.catView.attrs = [arr JSONString];
        [weakSelf showCatViewWithCatCode:code];
    }];
    
    if (!_catView) {
        _catView = [[ECMallHomeCatView alloc] init];
    }
    _catView.hidden = YES;
    [_amView addSubview:_catView];
    [_catView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _currIndex = 0;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
    _pan.enabled = NO;

}

- (void)showCatViewWithCatCode: (NSString *)catCode {
    _allView.hidden = YES;
    _catView.hidden = NO;
    _catView.catCode = catCode;
}

- (void)showAllView {
    _allView.hidden = NO;
    _catView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                if (_currIndex < _topView.dataSource.count - 1) {
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
    _catView.attrs = @"";
    if (_currIndex == 0) {
        //滑动到分类视图
        ECMallTagModel *model = [_topView.dataSource objectAtIndexWithCheck:1];
        if (!model) {
            return;
        }
        [self showCatViewWithCatCode:model.code];
    } else {
        if (_currIndex == 1 && num == -1) {
            //滑动到全部视图
            [self showAllView];
        } else {
            //向右或左滑动一个
            ECMallTagModel *model = [_topView.dataSource objectAtIndexWithCheck:_currIndex + num];
            if (!model) {
                return;
            }
            [self showCatViewWithCatCode:model.code];
        }
    }
    [_topView scrollToIndex:_currIndex + num];
    
//    UIView *currView = [_amView viewWithTag:_currIndex + 100];
//    UIView *nextView = [_amView viewWithTag:_currIndex + num + 100];
//    [_navTagView scrollToIndex:_currIndex + num];
//    currView.hidden = YES;
//    nextView.hidden = NO;
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

- (void)gotoSelectCityVC {
    ECSelectCityViewController *vc = [[ECSelectCityViewController alloc] init];
    vc.type = 1;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择城市"];
}



#pragma mark - Actions

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)loadDataSource {
    [ECMallDataParser loadMallIndexDataSourcesSucceed:^(NSMutableArray<ECMallTagModel *> *mallTagDataSource,
                                                        NSMutableArray<ECMallCycleViewModel *> *mallCycleDataSource,
                                                        NSMutableArray<ECMallHouseModel *> *mallHouseDataSource,
                                                        NSMutableArray<ECMallPanicBuyProductModel *> *panicBuyDataSource,
                                                        NSMutableArray<ECMallFloorModel *> *mallFloorDataSource) {
        WEAK_SELF
        
        //设置顶部分类数据源
        [_allView endRefresh];
        _topView.dataSource = mallTagDataSource;
        [CMPublicDataManager sharedCMPublicDataManager].mallTagDataSource = mallTagDataSource.mutableCopy;
        [[CMPublicDataManager sharedCMPublicDataManager].mallTagDataSource removeObjectAtIndex:0];
        [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(weakSelf.view);
            make.height.mas_equalTo(33.f);
        }];
        [_allView setCycleDataSource:mallCycleDataSource
                      houseDataSouce:mallHouseDataSource
                  PanicBuyDataSource:panicBuyDataSource
                     floorDataSource:mallFloorDataSource];
        _pan.enabled = YES;
    } failed:^{
        [_allView endRefresh];
    }];
}

- (void)gotoSearchVC {
    ECMallSearchViewController *vc = [[ECMallSearchViewController alloc] init];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
}

#pragma mark - Setter

- (void)setCityString:(NSString *)cityString {
    _cityString = cityString;
    [_cityBtn setTitle:cityString forState:UIControlStateNormal];
    CGFloat cityWidth = ceilf([cityString boundingRectWithSize:CGSizeMake(1000, 40)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:FONT_24}
                                                       context:nil].size.width);
    _cityBtn.frame = CGRectMake(0, 0, cityWidth + 9.f, 40.f);
    [_cityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, cityWidth, 0, -cityWidth)];
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
