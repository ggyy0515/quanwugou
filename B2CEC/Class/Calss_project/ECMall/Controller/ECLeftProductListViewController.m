//
//  ECLeftProductListViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLeftProductListViewController.h"
#import "ECMallProductCell.h"
#import "ECMallProductModel.h"
#import "ECMallProductDetailViewController.h"

@interface ECLeftProductListViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;

@end

@implementation ECLeftProductListViewController

#pragma mark -Life Cycle

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
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 24.f) / 2.f, (SCREENWIDTH - 24.f) / 2.f + 30.f + 12.f +16.f);
        layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BaseColor;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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

#pragma mark - Action

- (void)loadDataSource {
    [ECHTTPServer requestLeftProductListWithPageNum:_pageNum
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
                                                    for (NSDictionary *dic in result[@"productList"]) {
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
