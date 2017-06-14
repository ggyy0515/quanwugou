//
//  ECOrderListViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderListViewController.h"
#import "ECOrderSingleProductCell.h"
#import "ECOrderMutilProductCell.h"
#import "ECOrderListModel.h"
#import "ECOrderProductModel.h"
#import "ECLogisticsViewController.h"
#import "ECOrderDetailViewController.h"
#import "ECMallDataParser.h"
#import "ECReturnViewController.h"
#import "ECCommentOrderViewController.h"
#import "ECPaymentViewController.h"
#import "ECCommitOrderInfoModel.h"
#import "ECLookOrderCommentViewController.h"

@interface ECOrderListViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger maxPage;

@end

@implementation ECOrderListViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ADD_OBSERVER_NOTIFICATION(self, @selector(headRefresh), NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
    
    [self createUI];
    [_collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 8, 0);
        layout.minimumLineSpacing = 8.f;
        layout.itemSize = CGSizeMake(SCREENWIDTH, 205.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECOrderSingleProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderSingleProductCell)];
    [_collectionView registerClass:[ECOrderMutilProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderMutilProductCell)];
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

#pragma mark - Actions

- (void)loadDataSource {
    [ECHTTPServer requestOrderListWithPageNumber:_pageNum
                                          userId:[Keychain objectForKey:EC_USER_ID]
                                           state:_stateString
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
                                                 for (NSDictionary *dic in result[@"list"]) {
                                                     ECOrderListModel *model = [ECOrderListModel yy_modelWithDictionary:dic];
                                                     [_dataSource addObject:model];
                                                 }
                                                 [_collectionView reloadData];
                                             } else {
                                                 EC_SHOW_REQUEST_ERROR_INFO
                                             }
                                         }
                                          failed:^(NSURLSessionDataTask *task, NSError *error) {
                                              RequestFailure
                                              [_collectionView.mj_header endRefreshing];
                                              [_collectionView.mj_footer endRefreshing];
                                          }];
}

- (void)headRefresh {
    [_collectionView.mj_header beginRefreshing];
}

- (void)doActionsWithBtnTitle:(NSString *)btnTitle index:(NSInteger)index {
    ECOrderListModel *model = [_dataSource objectAtIndexWithCheck:index];
    if ([btnTitle isEqualToString:@"支付尾款"]) {
        [self leftPayWithOrderListModel:model];
    } else if ([btnTitle isEqualToString:@"取消订单"]) {
        [self cancleOrderWithOrderId:model.orderId];
    } else if ([btnTitle isEqualToString:@"立即付款"]) {
        [self nowPayWithOrderListModel:model];
    } else if ([btnTitle isEqualToString:@"确认收货"]) {
        [self confirmReceiveWithOrderId:model.orderId];
    } else if ([btnTitle isEqualToString:@"查看物流"]) {
        [self gotoLogisticsVCWithModel:model];
    } else if ([btnTitle isEqualToString:@"立即评价"]) {
        [self gotoCommentVCWithOrderListModel:model];
    } else if ([btnTitle isEqualToString:@"申请退货"]) {
        [self gotoRrturnGoodVCWithOrderId:model.orderId];
    } else if ([btnTitle isEqualToString:@"删除订单"]) {
        [self deleteOrderWithOrderId:model.orderId];
    }else if ([btnTitle isEqualToString:@"查看评价"]){
        [self gotoOrderComment:model.orderId];
    }
}

//确认收货
- (void)confirmReceiveWithOrderId:(NSString *)orderId {
    WEAK_SELF
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                         andText:@"确认已经收到货？"
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               if (blockBtn == blockAlert.defaultButton) {
                                                                   SHOWSVP
                                                                   [ECHTTPServer requestConfirmReceiveWithOrderId:orderId
                                                                                                          succeed:^(NSURLSessionDataTask *task, id result) {
                                                                                                              if (IS_REQUEST_SUCCEED(result)) {
                                                                                                                  RequestSuccess(result);
                                                                                                                  POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                                  [weakSelf.collectionView.mj_header beginRefreshing];
                                                                                                              } else {
                                                                                                                  EC_SHOW_REQUEST_ERROR_INFO;
                                                                                                              }
                                                                                                          }
                                                                                                           failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                                               RequestFailure
                                                                                                           }];
                                                               }
                                                           }];
    [alert.cancelButton setTitle:@"还未收到" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"确认收货" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
    
}

//取消订单
- (void)cancleOrderWithOrderId:(NSString *)orderId {
    WEAK_SELF
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                         andText:@"确认取消订单？"
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               if (blockBtn == blockAlert.defaultButton) {
                                                                   SHOWSVP
                                                                   [ECHTTPServer requestCancleOrderWithOrderId:orderId
                                                                                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                                                                                           if (IS_REQUEST_SUCCEED(result)) {
                                                                                                               RequestSuccess(result);
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                               [weakSelf.collectionView.mj_header beginRefreshing];
                                                                                                           } else {
                                                                                                               EC_SHOW_REQUEST_ERROR_INFO;
                                                                                                           }
                                                                                                       }
                                                                                                        failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                                            RequestFailure
                                                                                                        }];
                                                               }
                                                           }];
    [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"取消订单" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
}

//删除订单
- (void)deleteOrderWithOrderId:(NSString *)orderId {
    WEAK_SELF
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示"
                                                                         andText:@"确认删除订单？"
                                                                 andCancelButton:YES
                                                                    forAlertType:AlertInfo
                                                           withCompletionHandler:^(AMSmoothAlertView *blockAlert, UIButton *blockBtn) {
                                                               if (blockBtn == blockAlert.defaultButton) {
                                                                   SHOWSVP
                                                                   [ECHTTPServer requestDeleteOrderWithOrderId:orderId
                                                                                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                                                                                           if (IS_REQUEST_SUCCEED(result)) {
                                                                                                               RequestSuccess(result);
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                               [weakSelf.collectionView.mj_header beginRefreshing];
                                                                                                           } else {
                                                                                                               EC_SHOW_REQUEST_ERROR_INFO;
                                                                                                           }
                                                                                                       }
                                                                                                        failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                                                            RequestFailure
                                                                                                        }];
                                                               }
                                                           }];
    [alert.cancelButton setTitle:@"考虑一下" forState:UIControlStateNormal];
    alert.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert.defaultButton setTitle:@"删除订单" forState:UIControlStateNormal];
    alert.defaultButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [alert show];
}

//查看物流
- (void)gotoLogisticsVCWithModel:(ECOrderListModel *)model {
    ECLogisticsViewController *vc = [[ECLogisticsViewController alloc] init];
    vc.model = model;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"物流信息"];
}

//申请退货
- (void)gotoRrturnGoodVCWithOrderId:(NSString *)orderId {
    ECReturnViewController *vc = [[ECReturnViewController alloc] init];
    vc.selectType = ECReturnViewControllerReturn;
    vc.orderId = orderId;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"退货申请"];
}

//去评价
- (void)gotoCommentVCWithOrderListModel:(ECOrderListModel *)model {
    ECCommentOrderViewController *vc = [[ECCommentOrderViewController alloc] initWithOrderList:model];
    NSString *title = [NSString stringWithFormat:@"评价(%ld)", model.productList.count];
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:title];
}

//查看评价
- (void)gotoOrderComment:(NSString *)orderID{
    ECLookOrderCommentViewController *vc = [[ECLookOrderCommentViewController alloc] init];
    vc.orderID = orderID;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"评价"];
}

//立即付款
- (void)nowPayWithOrderListModel:(ECOrderListModel *)model {
    ECPaymentViewController *vc = [[ECPaymentViewController alloc] initWithPopClass:[self class]];
    ECCommitOrderInfoModel *infoModel = [[ECCommitOrderInfoModel alloc] init];
    infoModel.orderNumbers = @[model.orderNo];
    infoModel.totalPrice = model.totalMoney;
    infoModel.nowPay = model.nowPay;
    infoModel.leftPay = model.leftPay;
    infoModel.type = @"nowpay";
    vc.model = infoModel;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"支付总额"];
}

//支付尾款
- (void)leftPayWithOrderListModel:(ECOrderListModel *)model {
    ECPaymentViewController *vc = [[ECPaymentViewController alloc] initWithPopClass:[self class]];
    ECCommitOrderInfoModel *infoModel = [[ECCommitOrderInfoModel alloc] init];
    infoModel.orderNumbers = @[model.orderNo];
    infoModel.totalPrice = model.totalMoney;
    infoModel.nowPay = model.leftPay;
    infoModel.leftPay = model.leftPay;
    infoModel.type = @"leftpay";
    vc.model = infoModel;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"支付总额"];
}




#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    ECOrderListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    if (model.productList.count > 1) {
        ECOrderMutilProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderMutilProductCell)
                                                                                  forIndexPath:indexPath];
        [cell setClickActionBtn:^(NSString *title) {
            [weakSelf doActionsWithBtnTitle:title index:indexPath.row];
        }];
        cell.model = model;
        return cell;
    } else {
        ECOrderSingleProductCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderSingleProductCell)
                                                                                    forIndexPath:indexPath];
        [cell setClickActionBtn:^(NSString *title) {
            [weakSelf doActionsWithBtnTitle:title index:indexPath.row];
        }];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECOrderListModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECOrderDetailViewController *vc = [[ECOrderDetailViewController alloc] init];
    vc.orderId = model.orderId;
    [SELF_BASENAVI pushViewController:vc
                             animated:YES
                           titleLabel:[ECMallDataParser getOrderStateTitleWithMainStateString:model.state
                                                                               subStateString:model.subState]];
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
