//
//  ECWalletViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECWalletViewController.h"
#import "ECWalletInfoCell.h"
#import "ECWalletInfoModel.h"
#import "ECWalletPageActionCell.h"
#import "ECWalletPageBillHeader.h"
#import "ECWalletBillListCell.h"
#import "ECWalletBillListModel.h"
#import "ECBankCardListModel.h"
#import "ECMyBankCardViewController.h"
#import "ECTakeMoneyViewController.h"


@interface ECWalletViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;//导航栏底部的黑线
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECWalletInfoModel *walletInfoModel;
@property (nonatomic, strong) NSMutableArray *billListDataSource;
@property (nonatomic, strong) NSMutableArray *bankDataSource;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;

@end

@implementation ECWalletViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _billListDataSource = [NSMutableArray array];
        _bankDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ADD_OBSERVER_NOTIFICATION(self, @selector(noticeRefresh), NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE, nil);
    
    _navBarHairlineImageView = [CMPublicMethod findNavBottomLineView:self.navigationController.navigationBar];
    [self createUI];
    [self loadDataSource];
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE, nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [SELF_BASENAVI.backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    SELF_BASENAVI.titleLabel.textColor = ClearColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [SELF_BASENAVI.backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    SELF_BASENAVI.titleLabel.textColor = MainColor;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navBarHairlineImageView.hidden = NO;
    
    [super viewWillDisappear:animated];
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
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 12.f, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECWalletInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletInfoCell)];
    [_collectionView registerClass:[ECWalletPageActionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletPageActionCell)];
    [_collectionView registerClass:[ECWalletPageBillHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletPageBillHeader)];
    [_collectionView registerClass:[ECWalletBillListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletBillListCell)];
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
    [ECHTTPServer requestMyWalletInfoWithUserId:[Keychain objectForKey:EC_USER_ID]
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                ECWalletInfoModel *model = [ECWalletInfoModel yy_modelWithDictionary:result[@"account"]];
                                                _walletInfoModel = model;
                                                [_bankDataSource removeAllObjects];
                                                [result[@"banks"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                    ECBankCardListModel *bankModel = [ECBankCardListModel yy_modelWithDictionary:dic];
                                                    [_bankDataSource addObject:bankModel];
                                                }];
                                                [ECHTTPServer requestUserAccountBillWithUserId:[Keychain objectForKey:EC_USER_ID]
                                                                                    pageNumber:_pageNum
                                                                                       succeed:^(NSURLSessionDataTask *task, id result) {
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
                                                                                                   [_billListDataSource removeAllObjects];
                                                                                               }
                                                                                               [result[@"list"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                                                   ECWalletBillListModel *billModel = [ECWalletBillListModel yy_modelWithDictionary:dic];
                                                                                                   [_billListDataSource addObject:billModel];
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
                                                [_collectionView.mj_footer endRefreshing];
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             [_collectionView.mj_footer endRefreshing];
                                             RequestFailure
                                         }];
}

- (void)gotoMyBankCardVC {
    ECMyBankCardViewController *vc = [[ECMyBankCardViewController alloc] initWithMyBankCardType:MyBankCardType_list];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"我的银行卡"];
}

- (void)gotoTakeMoneyVC {
    if (_walletInfoModel) {
        ECTakeMoneyViewController *vc = [[ECTakeMoneyViewController alloc] initWithWalletInfoModel:_walletInfoModel];
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"提现"];
    } else {
        [SVProgressHUD showInfoWithStatus:@"没有加载到可用数据"];
    }
}

#pragma mark - UICollectionView Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return _billListDataSource.count;
        default:
            return 0;
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
        case 1:
            return 1.f;
            
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(SCREENWIDTH, 36.f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && kind == UICollectionElementKindSectionHeader) {
        ECWalletPageBillHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletPageBillHeader)
                                                                                   forIndexPath:indexPath];
        header.listCount = _billListDataSource.count;
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return CGSizeMake(SCREENWIDTH, 374.f / 2.f);
            } else {
                return CGSizeMake(SCREENWIDTH, 49.f);
            }
        }
        case 1:
            return CGSizeMake(SCREENWIDTH, 135.f / 2.f);
            
        default:
            return CGSizeZero;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                ECWalletInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletInfoCell)
                                                                                   forIndexPath:indexPath];
                if (_walletInfoModel) {
                    cell.model = _walletInfoModel;
                }
                return cell;
            } else {
                ECWalletPageActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletPageActionCell)
                                                                                         forIndexPath:indexPath];
                [cell setClickCashBtn:^{
                    //点击提现按钮
                    [weakSelf gotoTakeMoneyVC];
                }];
                [cell setClickCardBtn:^{
                    //点击银行卡按钮
                    [weakSelf gotoMyBankCardVC];
                }];
                return cell;
            }
        }
        case 1:
        {
            ECWalletBillListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECWalletBillListCell)
                                                                                   forIndexPath:indexPath];
            ECWalletBillListModel *model = [_billListDataSource objectAtIndexWithCheck:indexPath.row];
            cell.model = model;
            return cell;
        }
            
        default:
            return nil;
            break;
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
