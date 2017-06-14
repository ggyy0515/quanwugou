//
//  ECPointOrderListViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderListViewController.h"
#import "ECPointOrderListCell.h"
#import "ECPointOrderListModel.h"
#import "ECPointOrderDetailViewController.h"

@interface ECPointOrderListViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;

@end

@implementation ECPointOrderListViewController

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
        layout.itemSize = CGSizeMake(SCREENWIDTH, 116.f);
        layout.minimumLineSpacing = 12.f;
        layout.sectionInset = UIEdgeInsetsMake(12.f, 0.f, 12.f, 0.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECPointOrderListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderListCell)];
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
    [ECHTTPServer requestPointOrderListWithUserId:[Keychain objectForKey:EC_USER_ID]
                                       pageNumber:_pageNum
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
                                                  for (NSDictionary *dic in result[@"orderintegralList"]) {
                                                      ECPointOrderListModel *model = [ECPointOrderListModel yy_modelWithDictionary:dic];
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

#pragma mark - UICollectionView Methd

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPointOrderListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderListCell)
                                                                           forIndexPath:indexPath];
    ECPointOrderListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPointOrderListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECPointOrderDetailViewController *vc = [[ECPointOrderDetailViewController alloc] initWithOrderId:model.orderIds];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"兑换详情"];
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
