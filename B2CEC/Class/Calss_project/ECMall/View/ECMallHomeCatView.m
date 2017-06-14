//
//  ECMallHomeCatView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallHomeCatView.h"
#import "ECMallFilterView.h"
#import "ECMallFilterViewController.h"
#import "ECMallProductCell.h"
#import "ECMallProductModel.h"
#import "ECMallProductDetailViewController.h"

@interface ECMallHomeCatView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

/**
 排序视图
 */
@property (nonatomic, strong) ECMallFilterView *filterView;
/**
 表单
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 商品数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 筛选控制器
 */
@property (nonatomic, strong) ECMallFilterViewController *filterVC;

//筛选项------------------begin
/**
 场馆编码
 */
@property (nonatomic, copy) NSString *houseCode;
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
 排序类型 (不是升序、降序，顺序可直接读取filterView的sortDescType属性)
 */
@property (nonatomic, copy) NSString *sortType;
/**
 筛选界面筛选出来的条件
 */
@property (nonatomic, copy) NSString *filterAttrs;
/**
 页码
 */
@property (nonatomic, assign) NSInteger pageNum;
/**
 最大页
 */
@property (nonatomic, assign) NSInteger maxPage;
//筛选项------------------end

@property (nonatomic, assign) BOOL isLoadRequest;


@end

@implementation ECMallHomeCatView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _isLoadRequest = NO;
        _dataSource = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    
    if (!_filterView) {
        _filterView = [[ECMallFilterView alloc] init];
    }
    [self addSubview:_filterView];
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
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
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 24.f) / 2.f, (SCREENWIDTH - 24.f) / 2.f + 30.f + 12.f +16.f);
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.filterView.mas_bottom);
    }];
    [_collectionView registerClass:[ECMallProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallProductCell)];
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
    

}

#pragma mark - Setter&Getter

- (void)setCatCode:(NSString *)catCode {
    if ([_catCode isEqualToString:catCode] && !_isLoadRequest) {
        return;
    }
    _catCode = catCode;
    if (_isLoadRequest) {
        [_collectionView.mj_header beginRefreshing];
    }else{
        if (!_filterVC) {
            [_collectionView.mj_header beginRefreshing];
        }else{
            [_filterVC clearFilter];
        }
    }
}

- (void)setAttrs:(NSString *)attrs{
    _attrs = attrs;
    if (attrs == nil) {
        _filterAttrs = nil;
        _isLoadRequest = NO;
    }else{
        _filterAttrs = attrs;
        _isLoadRequest = YES;
    }
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
            if (attrs == nil) {
                weakSelf.isLoadRequest = NO;
                weakSelf.attrs = nil;
            }
            weakSelf.minPrice = minPrice;
            weakSelf.maxPrice = maxPrice;
            weakSelf.filterAttrs = attrs;
            weakSelf.houseCode = sHousecode;
            weakSelf.secondType = secondType;
            [weakSelf.collectionView.mj_header beginRefreshing];
        }];
    }
    _filterVC.houseCode = _houseCode;
    _filterVC.catCode = _catCode;
    _filterVC.attrs = self.attrs;
    
    [self.viewController.navigationController presentPopinController:_filterVC fromRect:CGRectMake(30, -20, SCREENWIDTH-10, SCREENHEIGHT +1 - 10 ) needComputeFrame:YES animated:YES completion:^{
        
    }];
}

- (void)loadDataSource {
    [ECHTTPServer requestProductListWithPageNumber:_pageNum
                                           catCode:_catCode
                                             attrs:_filterAttrs
                                        secondType:_secondType
                                         houseCode:_houseCode
                                          minPrice:(_minPrice == 0.f ? nil : [NSString stringWithFormat:@"%.2lf",_minPrice])
                                          maxPrice:(_maxPrice == 0.f ? nil : [NSString stringWithFormat:@"%.2lf",_maxPrice])
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallProductModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.protable = model.protable;
    vc.proId = model.proId;
    [((CMBaseNavigationController *)self.viewController.navigationController) pushViewController:vc
                                                                                        animated:YES
                                                                                      titleLabel:@""];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
