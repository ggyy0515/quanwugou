//
//  ECMallHouseViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallHouseViewController.h"
#import "ECMallTagView.h"
#import "ECMallFilterView.h"
#import "ECMallProductCell.h"
#import "ECMallTagModel.h"
#import "ECMallFilterViewController.h"
#import "ECMallProductModel.h"
#import "ECMallProductDetailViewController.h"
#import "ECLeftProductHouseHeader.h"
#import "ECLeftProductListViewController.h"

@interface ECMallHouseViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    CAAnimationDelegate
>

/**
 所选择的顶部分类的编码
 */
@property (nonatomic, copy) NSString *catCode;
/**
 顶部分类
 */
@property (nonatomic, strong) ECMallTagView *topView;
/**
 排序视图
 */
@property (nonatomic, strong) ECMallFilterView *filterView;
/**
 商品列表
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 顶部分类数据源
 */
@property (nonatomic, strong) NSMutableArray *mallTagDataSource;
/**
 商品列表数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 筛选的属性
 */
@property (nonatomic, copy) NSString *attrs;
/**
 最高价格
 */
@property (nonatomic, assign) CGFloat maxPrice;
/**
 最低价格
 */
@property (nonatomic, assign) CGFloat minPrice;
/**
 二级分类
 */
@property (nonatomic, copy) NSString *secondType;
/**
 筛选控制器
 */
@property (nonatomic, strong) ECMallFilterViewController *filterVC;
/**
 排序类型 (不是升序、降序，顺序可直接读取filterView的sortDescType属性)
 */
@property (nonatomic, copy) NSString *sortType;
/**
 页码
 */
@property (nonatomic, assign) NSInteger pageNum;
/**
 最大页
 */
@property (nonatomic, assign) NSInteger maxPage;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGFloat beganX;
@property (nonatomic, assign) CGFloat beganY;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, strong) UIView *amView;
//----滑动手势----//


@end

@implementation ECMallHouseViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
        _mallTagDataSource = [CMPublicDataManager sharedCMPublicDataManager].mallTagDataSource;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ECMallTagModel *model = [_mallTagDataSource objectAtIndexWithCheck:0];
    _catCode = model ? model.code : @"";
    [self createUI];
    [_collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    
    if (!_topView) {
        _topView = [ECMallTagView showTagInView:self.view dataSource:[CMPublicDataManager sharedCMPublicDataManager].mallTagDataSource];
    }
    [_topView setDidSelectCatAtIndex:^(NSInteger index) {
        //点击顶部的某个分类
        weakSelf.currIndex = index;
        ECMallTagModel *model = [weakSelf.mallTagDataSource objectAtIndexWithCheck:index];
        weakSelf.catCode = model.code;
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    if (!_filterView) {
        _filterView = [[ECMallFilterView alloc] init];
    }
    [self.view addSubview:_filterView];
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.height.mas_equalTo(40.f);
    }];
    _filterView.sortType = ECSortType_time;
    [_filterView setFilterBtnClick:^{
        //点击筛选按钮
        [weakSelf showFilter];
    }];
    [_filterView setSortTypeClickBlock:^(ECSortType type) {
        //改变排序类型
        switch (type) {
            case ECSortType_time:
            {
                //默认是时间排序
                weakSelf.sortType = @"";
            }
                break;
            case ECSortType_sales:
            {
                weakSelf.sortType = @"salenumber";
            }
                break;
            case ECSortType_price:
            {
                weakSelf.sortType = @"price";
            }
                break;
                
            default:
                break;
        }
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    if (!_amView) {
        _amView = [UIView new];
    }
    [self.view addSubview:_amView];
    _amView.backgroundColor = ClearColor;
    [_amView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.filterView.mas_bottom);
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 24.f) / 2.f, (SCREENWIDTH - 24.f) / 2.f + 30.f + 12.f +16.f);
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [_amView addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.amView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECMallProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallProductCell)];
    [_collectionView registerClass:[ECLeftProductHouseHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLeftProductHouseHeader)];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf loadDataSource];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.pageNum < weakSelf.maxPage) {
            _pageNum ++;
        }
        [weakSelf loadDataSource];
    }];
    
    _currIndex = 0;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
    
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
    _attrs = @"";
    
    ECMallTagModel *model = [_topView.dataSource objectAtIndexWithCheck:_currIndex + num];
    if (!model) {
        return;
    }
    _catCode = model.code;
    [_collectionView.mj_header beginRefreshing];
    [_topView scrollToIndex:_currIndex + num];
    
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




#pragma mark - Actions

- (void)showFilter {
    WEAK_SELF
    
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    
    if (!_filterVC) {
        _filterVC = [[ECMallFilterViewController alloc]init];
        [_filterVC setBlurParameters:blurParameters];
        [_filterVC setPopinTransitionDirection:BKTPopinTransitionDirectionRight];
        
        [_filterVC setSubmitFiltrateClick:^(CGFloat minPrice, CGFloat maxPrice, NSString *attrs, NSString *sHousecode, NSString *secondType) {
            weakSelf.minPrice = minPrice;
            weakSelf.maxPrice = maxPrice;
            weakSelf.attrs = attrs;
            weakSelf.houseCode = sHousecode;
            weakSelf.secondType = secondType;
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
    }
    _filterVC.houseCode = _houseCode;
    _filterVC.catCode = _catCode;
    
    
    [self.navigationController presentPopinController:_filterVC fromRect:CGRectMake(30, -1, SCREENWIDTH-10, SCREENHEIGHT +1 ) needComputeFrame:YES animated:YES completion:^{
        
    }];
}

- (void)loadDataSource {
    [ECHTTPServer requestProductListWithPageNumber:_pageNum
                                           catCode:_catCode
                                             attrs:_attrs
                                        secondType:_secondType
                                         houseCode:_houseCode
                                          minPrice:(_minPrice == 0.f ? nil : [NSString stringWithFormat:@"%lf",_minPrice])
                                          maxPrice:(_maxPrice == 0.f ? nil : [NSString stringWithFormat:@"%lf",_maxPrice])
                                          sortType:_sortType
                                      sortDescType:_filterView.sortDescType == ECSortDescType_desc ? @"desc" : @"asc"
                                           succeed:^(NSURLSessionDataTask *task, id result) {
                                               [_collectionView.mj_header endRefreshing];
                                               [_collectionView.mj_footer endRefreshing];
                                               if (IS_REQUEST_SUCCEED(result)) {
                                                   ECLog(@"%@", result);
                                                   _maxPage = [result[@"page"][@"totalPage"] integerValue];
                                                   if (_pageNum == _maxPage) {
                                                       [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                                   }
                                                   if (_pageNum == 1) {
                                                       [_dataSource removeAllObjects];
                                                   }
                                                   for (NSDictionary *dic in result[@"productlist"]) {
                                                       ECMallProductModel *model = [ECMallProductModel yy_modelWithDictionary:dic];
                                                       [_dataSource addObject:model];
                                                   }
                                                   [_collectionView reloadData];
                                                   
                                               } else {
                                                   EC_SHOW_REQUEST_ERROR_INFO
                                               }
                                           }
                                            failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                [_collectionView.mj_header endRefreshing];
                                                [_collectionView.mj_footer endRefreshing];
                                               RequestFailure
                                            }];
}

#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallProductCell)
                                                                        forIndexPath:indexPath];
    ECMallProductModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (_isBarginPriceHouse) {
        return CGSizeMake(SCREENWIDTH, SCREENWIDTH * 300.f / 750.f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (_isBarginPriceHouse && kind == UICollectionElementKindSectionHeader) {
        WEAK_SELF
        ECLeftProductHouseHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLeftProductHouseHeader)
                                                                                     forIndexPath:indexPath];
        [header setTapAction:^{
            ECLeftProductListViewController *vc = [[ECLeftProductListViewController alloc] init];
            [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"工厂尾货"];
        }];
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallProductModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.protable = model.protable;
    vc.proId = model.proId;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
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
