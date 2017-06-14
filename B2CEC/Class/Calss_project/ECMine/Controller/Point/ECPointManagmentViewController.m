//
//  ECPointManagmentViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointManagmentViewController.h"
#import "ECPointManagmentInfoCell.h"
#import "ECPointInfoModel.h"
#import "ECPointManagmentActionCell.h"
#import "ECPointManagmentBillHeader.h"
#import "ECPointManagermentBillListCell.h"
#import "ECPointManagmentBillModel.h"
#import "ECPointMallViewController.h"
#import "ECPointOrderListViewController.h"
#import "ECTakePointViewController.h"
#import "ECPointDistributionViewController.h"

@interface ECPointManagmentViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ECPointInfoModel *infoModel;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;
@property (strong, nonatomic) UIImageView *navBarHairlineImageView;//导航栏底部的黑线

@end

@implementation ECPointManagmentViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_OBSERVER_NOTIFICATION(self, @selector(noticeRefresh), NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
    _navBarHairlineImageView = [CMPublicMethod findNavBottomLineView:self.navigationController.navigationBar];
    [self createUI];
    [self loadDataSource];
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navBarHairlineImageView.hidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WEAK_SELF
    
    UIButton *instBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [instBtn setTitle:@"积分说明" forState:UIControlStateNormal];
    instBtn.titleLabel.font = FONT_32;
    [instBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [instBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf gotoPointInstructionVC];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:instBtn];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.bounces = NO;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECPointManagmentInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentInfoCell)];
    [_collectionView registerClass:[ECPointManagmentActionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentActionCell)];
    [_collectionView registerClass:[ECPointManagmentBillHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentBillHeader)];
    [_collectionView registerClass:[ECPointManagermentBillListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagermentBillListCell)];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.pageNum < weakSelf.maxPage) {
            _pageNum ++;
        }
        [weakSelf loadDataSourceWithoutSvp];
    }];
}

#pragma mark - Actions

- (void)noticeRefresh {
    _pageNum = 1;
    [self loadDataSourceWithoutSvp];
}


- (void)loadDataSource {
    SHOWSVP
    _pageNum = 1;
    [self loadDataSourceWithoutSvp];
}

- (void)loadDataSourceWithoutSvp {
    [ECHTTPServer requestPointInfoWithUserId:[Keychain objectForKey:EC_USER_ID]
                                     succeed:^(NSURLSessionDataTask *task, id result) {
                                         if (IS_REQUEST_SUCCEED(result)) {
                                             _infoModel = [ECPointInfoModel yy_modelWithDictionary:result[@"info"]];
                                             [ECHTTPServer requestPointBillListWithPageNum:_pageNum
                                                                                    userId:[Keychain objectForKey:EC_USER_ID]
                                                                                   succeed:^(NSURLSessionDataTask *task, id result) {
                                                                                       ECLog(@"%@", result);
                                                                                       if (IS_REQUEST_SUCCEED(result)) {
                                                                                           [_collectionView.mj_footer endRefreshing];
                                                                                           if ([SVProgressHUD isVisible]) {
                                                                                               DISMISSSVP
                                                                                           }
                                                                                           _maxPage = [result[@"page"][@"totalPage"] integerValue];
                                                                                           if (_pageNum == _maxPage) {
                                                                                               [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                                                                           }
                                                                                           if (_pageNum == 1) {
                                                                                               [_dataSource removeAllObjects];
                                                                                           }
                                                                                           [result[@"list"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                                               ECPointManagmentBillModel *billModel = [ECPointManagmentBillModel yy_modelWithDictionary:dic];
                                                                                               [_dataSource addObject:billModel];
                                                                                           }];
                                                                                           [_collectionView reloadData];
                                                                                       } else {
                                                                                           [_collectionView.mj_footer endRefreshing];
                                                                                           EC_SHOW_REQUEST_ERROR_INFO
                                                                                       }
                                                                                   }
                                                                                    failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                        [_collectionView.mj_footer endRefreshing];
                                                                                        RequestFailure
                                                                                    }];
                                         } else {
                                             EC_SHOW_REQUEST_ERROR_INFO
                                             [_collectionView.mj_footer endRefreshing];
                                         }
                                     }
                                      failed:^(NSURLSessionDataTask *task, NSError *error) {
                                          RequestFailure
                                          [_collectionView.mj_footer endRefreshing];
                                      }];
}

- (void)gotoPointMallVC {
    ECPointMallViewController *vc = [[ECPointMallViewController alloc] init];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"积分商城"];
}

- (void)gotoOrderListVC {
    ECPointOrderListViewController *vc = [[ECPointOrderListViewController  alloc] init];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"兑换记录"];
}

- (void)gotoTakePointVC {
    ECTakePointViewController *vc = [[ECTakePointViewController alloc] initWithPointInfoModel:_infoModel];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"积分兑现"];
}

- (void)gotoPointDistibutionVC {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/mypoint/pointDistribution/%@", HOST_ADDRESS, [ECHTTPServer loadApiVersion], [Keychain objectForKey:EC_USER_ID]];
    ECPointDistributionViewController *vc = [[ECPointDistributionViewController alloc] initWithUrlString:urlStr];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"积分分布"];
}

- (void)gotoPointInstructionVC {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/common/pointDescibe", HOST_ADDRESS, [ECHTTPServer loadApiVersion]];
    ECPointDistributionViewController *vc = [[ECPointDistributionViewController alloc] initWithUrlString:urlStr];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"积分说明"];
}


#pragma mark - UICollection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return _dataSource.count;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 12.f, 0.f);
    }
    return UIEdgeInsetsMake(0, 0, 0, 12.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(SCREENWIDTH, 36.f);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(SCREENWIDTH, 420.f / 2.f);
        } else {
            return CGSizeMake(SCREENWIDTH, 49.f);
        }
    } else {
        return CGSizeMake(SCREENWIDTH, 135.f / 2.f);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && kind == UICollectionElementKindSectionHeader) {
        ECPointManagmentBillHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentBillHeader)
                                                                                       forIndexPath:indexPath];
        header.titleLabel.text = _dataSource.count == 0 ? @"暂无积分明细" : @"积分明细";
        header.backgroundColor = _dataSource.count == 0 ? BaseColor : [UIColor whiteColor];
        return header;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ECPointManagmentInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentInfoCell)
                                                                                       forIndexPath:indexPath];
            if (_infoModel) {
                cell.model = _infoModel;
            }
            return cell;
        } else {
            ECPointManagmentActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagmentActionCell)
                                                                                         forIndexPath:indexPath];
            [cell setLeftBtnClick:^{
                if (![[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {
                    //不是设计师,积分商城
                    [weakSelf gotoPointMallVC];
                } else {
                    //设计师,积分兑现
                    [weakSelf gotoTakePointVC];
                }
            }];
            [cell setRightBtnClick:^{
                if (![[USERDEFAULT objectForKey:EC_USER_STATUS] isEqualToString:@"2"]) {
                    //不是设计师,积分订单列表
                    [weakSelf gotoOrderListVC];
                } else {
                    //设计师,积分分布
                    [weakSelf gotoPointDistibutionVC];
                }
            }];
            return cell;
        }
    } else {
        ECPointManagermentBillListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointManagermentBillListCell)
                                                                                         forIndexPath:indexPath];
        ECPointManagmentBillModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 0) {
        CGPoint point = scrollView.contentOffset;
        point.y = 0.f;
        scrollView.contentOffset = point;
    }
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
