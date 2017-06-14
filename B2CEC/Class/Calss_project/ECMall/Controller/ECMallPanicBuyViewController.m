//
//  ECMallPanicBuyViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/18.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuyViewController.h"
#import "ECMallPanicBuyListCell.h"
#import "ECMallPanicBuyListModel.h"
#import "ECMallProductDetailViewController.h"

@interface ECMallPanicBuyViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

/**
 表单
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 购物车按钮
 */
@property (nonatomic, strong) UIButton *cartBtn;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 定时器
 */
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;
@property (nonatomic, assign) BOOL canReloadInWillAppear;

@end

@implementation ECMallPanicBuyViewController

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
    [_collectionView.mj_header beginRefreshing];
    [self createTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [_timer invalidate];
    _timer = nil;
    _canReloadInWillAppear = YES;
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_canReloadInWillAppear) {
        [_collectionView.mj_header beginRefreshing];
        [self createTimer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 24.f) / 2.f, (SCREENWIDTH - 24.f) / 2.f + 145 / 2.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECMallPanicBuyListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuyListCell)];
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

- (void)createTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(timerEvent)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - Actions

- (void)timerEvent {
    [_dataSource enumerateObjectsUsingBlock:^(ECMallPanicBuyListModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [model countDown];
    }];
    POST_NOTIFICATION(NOTIFICATION_NAME_PURCHASE_COUNTDOWN, nil);
}


- (void)loadDataSource {
    [ECHTTPServer requestPanicBuyListWithPageNumber:_pageNum
                                            succeed:^(NSURLSessionDataTask *task, id result) {
                                                ECLog(@"%@", result);
                                                [_collectionView.mj_header endRefreshing];
                                                [_collectionView.mj_footer endRefreshing];
                                                if (IS_REQUEST_SUCCEED(result)) {
                                                    _maxPage = [result[@"page"][@"totalPage"] integerValue];
                                                    if (_pageNum == _maxPage) {
                                                        [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                                    }
                                                    if (_pageNum == 1) {
                                                        [_dataSource removeAllObjects];
                                                    }
                                                    for (NSDictionary *dic in result[@"qiangouList"]) {
                                                        ECMallPanicBuyListModel *model = [ECMallPanicBuyListModel yy_modelWithDictionary:dic];
                                                        //先减掉一秒确保更精确
                                                        [model countDown];
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
                                             }];
}


#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallPanicBuyListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuyListCell)
                                                                             forIndexPath:indexPath];
    ECMallPanicBuyListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallPanicBuyListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.proId = model.proId;
    vc.protable = model.proTable;
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
