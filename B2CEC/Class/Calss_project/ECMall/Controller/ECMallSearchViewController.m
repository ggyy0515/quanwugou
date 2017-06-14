//
//  ECMallSearchViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallSearchViewController.h"
#import "ECMallFilterView.h"
#import "ECMallFilterViewController.h"
#import "ECMallProductCell.h"
#import "ECMallProductModel.h"
#import "ECMallProductDetailViewController.h"
#import "ECCartViewController.h"

@interface ECMallSearchViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate
>
/**
 搜索栏是否可为第一响应
 */
@property (nonatomic, assign) BOOL canSearchBecomeFirstResp;
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
 搜索栏
 */
@property (nonatomic, strong) UITextField *searchTF;
/**
  购物车按钮
 */
@property (nonatomic, strong) UIButton *cartBtn;

//筛选项------------------begin
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
 页码
 */
@property (nonatomic, assign) NSInteger pageNum;
/**
 最大页
 */
@property (nonatomic, assign) NSInteger maxPage;
/**
 筛选的属性
 */
@property (nonatomic, copy) NSString *attrs;
//筛选项------------------end

@end

@implementation ECMallSearchViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_canSearchBecomeFirstResp) {
        [_searchTF becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([_searchTF isFirstResponder]) {
        [_searchTF resignFirstResponder];
    }
    _canSearchBecomeFirstResp = NO;
    [super viewWillDisappear:animated];
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    _canSearchBecomeFirstResp = YES;
    
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * (528.f / 750.f), 26.f)];
    }
    _searchTF.backgroundColor = BaseColor;
    _searchTF.layer.cornerRadius = 1.f;
    _searchTF.delegate = self;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.font = FONT_28;
    _searchTF.textColor = LightMoreColor;
    [_searchTF setValue:LightColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    [_searchTF setReturnKeyType:UIReturnKeySearch];
    UIImageView *glassImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24.f, 24.f)];
    [glassImageView setImage:[UIImage imageNamed:@"shop_nav_search"]];
    _searchTF.leftView = glassImageView;
    self.navigationItem.titleView = _searchTF;
    
    if (!_cartBtn) {
        _cartBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22.f, 22.f)];
    }
    [_cartBtn setImage:[[UIImage imageNamed:@"nav_shop"] imageWithColor:MainColor] forState:UIControlStateNormal];
    [_cartBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 6.f, 0, -6.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cartBtn];
    [_cartBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECCartViewController *vc = [[ECCartViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"购物车"];
    }];
    
    if (!_filterView) {
        _filterView = [[ECMallFilterView alloc] init];
    }
    [self.view addSubview:_filterView];
    [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.height.mas_equalTo(40.f);
    }];
    _filterView.isHideFilter = YES;
    _filterView.sortType = ECSortType_time;

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
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
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
    
    [self.view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        gestureRecoginzer.cancelsTouchesInView = NO;
        if ([weakSelf.searchTF isFirstResponder]) {
            [weakSelf.searchTF resignFirstResponder];
        }
    }];
    
}


#pragma mark - Actions

- (void)loadDataSource {
    if (!_searchTF.text || [_searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入关键字"];
        return;
    }
    [ECHTTPServer requestSearchProductWithKeyword:_searchTF.text
                                         sortType:_sortType
                                     sortDescType:_filterView.sortDescType == ECSortDescType_desc ? @"desc" : @"asc"
                                          pageNum:_pageNum
                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                              [_collectionView.mj_header endRefreshing];
                                              [_collectionView.mj_footer endRefreshing];
                                              if (IS_REQUEST_SUCCEED(result)) {
                                                  ECLog(@"%@", result);
                                                  if ([SVProgressHUD isVisible]) {
                                                      DISMISSSVP
                                                  }
                                                  _maxPage = [result[@"page"][@"totalPage"] integerValue];
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
                                          } failed:^(NSURLSessionDataTask *task, NSError *error) {
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
    [SELF_BASENAVI pushViewController:vc
                             animated:YES
                           titleLabel:@""];
}



#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [SVProgressHUD show];
    _pageNum = 1;
    [self loadDataSource];
    return YES;
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
