//
//  ECOrderDetailViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/12.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECOrderDetailViewController.h"
#import "ECOrderListModel.h"
#import "ECOrderProductModel.h"
#import "ECOrderDetailBottomView.h"
#import "ECOrderDetailStateCell.h"
#import "ECOrderDetailOrderNumCell.h"
#import "ECOrderDetailLogisticsInfoCell.h"
#import "ECOrderDetailAddressCell.h"
#import "ECOrderDetailBillInfoCell.h"
#import "ECOrderDetailProductHeaderCell.h"
#import "ECOrderDetailProductCell.h"
#import "ECOrderDetailMessageCell.h"
#import "ECConfirmOrderInfoCell.h"
#import "ECConfirmOrderInfoModel.h"
#import "ECLogisticsViewController.h"
#import "ECReturnViewController.h"
#import "ECMallProductDetailViewController.h"
#import "ECCommentOrderViewController.h"
#import "ECPaymentViewController.h"
#import "ECCommitOrderInfoModel.h"
#import "ECLookOrderCommentViewController.h"

@interface ECOrderDetailViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;//导航栏底部的黑线
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECOrderDetailBottomView *bottomView;
@property (nonatomic, strong) ECOrderListModel *model;
@property (nonatomic, strong) NSMutableArray *infoDataSource;

@end

@implementation ECOrderDetailViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _infoDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADD_OBSERVER_NOTIFICATION(self, @selector(loadDataSourceWithoutSVP), NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA, nil);
    
    _navBarHairlineImageView = [CMPublicMethod findNavBottomLineView:self.navigationController.navigationBar];
    [self createUI];
    [self loadDataSource];
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

- (void)dealloc {
    REMOVE_NOTIFICATION(self, NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA, nil);
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    if (!_bottomView) {
        _bottomView = [[ECOrderDetailBottomView alloc] init];
    }
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(44.f);
    }];
    [_bottomView setClickActionBtn:^(NSString *title) {
        [weakSelf doActionsWithBtnTitle:title];
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    [_collectionView registerClass:[ECOrderDetailStateCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailStateCell)];
    [_collectionView registerClass:[ECOrderDetailOrderNumCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailOrderNumCell)];
    [_collectionView registerClass:[ECOrderDetailLogisticsInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailLogisticsInfoCell)];
    [_collectionView registerClass:[ECOrderDetailAddressCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailAddressCell)];
    [_collectionView registerClass:[ECOrderDetailBillInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailBillInfoCell)];
    [_collectionView registerClass:[ECOrderDetailProductHeaderCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailProductHeaderCell)];
    [_collectionView registerClass:[ECOrderDetailProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailProductCell)];
    [_collectionView registerClass:[ECOrderDetailMessageCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailMessageCell)];
    [_collectionView registerClass:[ECConfirmOrderInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderInfoCell)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void)loadDataSource {
    SHOWSVP
    [ECHTTPServer requestOrderDetailWithOrderId:_orderId
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                DISMISSSVP
                                                _model = [ECOrderListModel yy_modelWithDictionary:result[@"orderInfo"]];
                                                if (_model) {
                                                    _bottomView.model = _model;
                                                    [self initInfoData];
                                                }
                                                [_collectionView reloadData];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                            RequestFailure
                                         }];
}

- (void)loadDataSourceWithoutSVP {
    [ECHTTPServer requestOrderDetailWithOrderId:_orderId
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                DISMISSSVP
                                                _model = [ECOrderListModel yy_modelWithDictionary:result[@"orderInfo"]];
                                                if (_model) {
                                                    _bottomView.model = _model;
                                                    [self initInfoData];
                                                }
                                                [_collectionView reloadData];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                         }];
}

- (void)initInfoData {
    __block NSInteger productCount = 0;
    [_model.productList enumerateObjectsUsingBlock:^(ECOrderProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
        productCount += productModel.count.integerValue;
    }];
    
    [_infoDataSource removeAllObjects];
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"商品数量"
                                                               content:[NSString stringWithFormat:@"%ld", (long)productCount]]];
    
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"商品原价"
                                                               content:[NSString stringWithFormat:@"￥%ld", _model.totalMoney.integerValue + _model.disCountMoney.integerValue]]];
    
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"优惠金额"
                                                               content:[NSString stringWithFormat:@"-￥%@", _model.disCountMoney]]];
    
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"实付总款（含尾款）"
                                                               content:[NSString stringWithFormat:@"￥%@", _model.totalMoney]]];
}

- (void)doActionsWithBtnTitle:(NSString *)btnTitle {
    if ([btnTitle isEqualToString:@"支付尾款"]) {
        [self leftPayWithOrderListModel:_model];
    } else if ([btnTitle isEqualToString:@"取消订单"]) {
        [self cancleOrderWithOrderId:_model.orderId];
    } else if ([btnTitle isEqualToString:@"立即付款"]) {
        [self nowPayWithOrderListModel:_model];
    } else if ([btnTitle isEqualToString:@"确认收货"]) {
        [self confirmReceiveWithOrderId:_model.orderId];
    } else if ([btnTitle isEqualToString:@"查看物流"]) {
        [self gotoLogisticsVCWithModel:_model];
    } else if ([btnTitle isEqualToString:@"立即评价"]) {
        [self gotoCommentVCWithOrderListModel:_model];
    } else if ([btnTitle isEqualToString:@"申请退货"]) {
        [self gotoRrturnGoodVCWithOrderId:_model.orderId];
    } else if ([btnTitle isEqualToString:@"删除订单"]) {
        [self deleteOrderWithOrderId:_model.orderId];
    } else if ([btnTitle isEqualToString:@"查看评价"]){
        [self gotoOrderComment:_model.orderId];
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
                                                                                                                  POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
                                                                                                                  POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                                  [weakSelf loadDataSource];
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
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
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
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
                                                                                                               POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
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

//查看评价
- (void)gotoOrderComment:(NSString *)orderID{
    ECLookOrderCommentViewController *vc = [[ECLookOrderCommentViewController alloc] init];
    vc.orderID = orderID;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"评价"];
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


#pragma mark - UIScrollView Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 65.f) {
        SELF_BASENAVI.titleLabel.textColor = [UIColor whiteColor];
    }else if (offsetY <= 65.f && offsetY >= 30.f){
        SELF_BASENAVI.titleLabel.textColor = UIColorFromRGBA(255.f, 255.f, 255.f, offsetY / 65.f);
    }else{
        SELF_BASENAVI.titleLabel.textColor = ClearColor;
    }
}

#pragma mark - UICollectionView Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
        case 2:
            return _model.productList.count + 2;
        case 3:
            return _infoDataSource.count;
            
        default:
            return 0;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_model) {
        return CGSizeZero;
    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return CGSizeMake(SCREENWIDTH, 65.f);
                case 1:
                    return CGSizeMake(SCREENWIDTH, 44.f);
                case 2:{
                    if (![_model.state isEqualToString:@"For_the_goods"]) {
                        return CGSizeZero;
                    }
                    return CGSizeMake(SCREENWIDTH, 60.f);
                }
                    
                default:
                    return CGSizeZero;
            }
        }
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    return CGSizeMake(SCREENWIDTH, 176.f / 2.f);
                case 1:{
                    if (!_model.billTitle || [_model.billTitle isEqualToString:@""]) {
                        return CGSizeZero;
                    }
                    return CGSizeMake(SCREENWIDTH, 49.f);
                }
                    
                default:
                    return CGSizeZero;
            }
        }
        case 2:
        {
            if (indexPath.row == 0) {
                return CGSizeMake(SCREENWIDTH, 36.f);
            } else if (indexPath.row == _model.productList.count + 1) {
                if (!_model.message || [_model.message isEqualToString:@""]) {
                    return CGSizeZero;
                }
                return CGSizeMake(SCREENWIDTH, 44.f);
            } else {
                return CGSizeMake(SCREENWIDTH, 72.f);
            }
        }
        case 3:
            return CGSizeMake(SCREENWIDTH, 44.f);

        default:
            return CGSizeZero;
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 1.f;
        case 3:
            return 0.f;
        default:
            return 0;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
        case 2:
        case 3:
            return UIEdgeInsetsMake(0, 0, 12.f, 0);
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0);
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                ECOrderDetailStateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailStateCell)
                                                                                         forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            } else if (indexPath.row == 1) {
                ECOrderDetailOrderNumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailOrderNumCell)
                                                                                            forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            } else {
                ECOrderDetailLogisticsInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailLogisticsInfoCell)
                                                                                                 forIndexPath:indexPath];
                if (![_model.state isEqualToString:@"For_the_goods"]) {
                    cell.model = nil;
                    return cell;
                }
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            }
        }
        case 1:
        {
            if (indexPath.row == 0) {
                ECOrderDetailAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailAddressCell)
                                                                                           forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            } else {
                ECOrderDetailBillInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailBillInfoCell)
                                                                                            forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            }
        }
        case 2:
        {
            if (indexPath.row == 0) {
                ECOrderDetailProductHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailProductHeaderCell)
                                                                                                 forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            } else if (indexPath.row == _model.productList.count + 1) {
                ECOrderDetailMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailMessageCell)
                                                                                           forIndexPath:indexPath];
                if (_model) {
                    cell.model = _model;
                }
                return cell;
            } else {
                ECOrderDetailProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailProductCell)
                                                                                           forIndexPath:indexPath];
                if (_model) {
                    ECOrderProductModel *model = [_model.productList objectAtIndexWithCheck:indexPath.row - 1];
                    cell.model = model;
                }
                return cell;
                
            }
        }
        case 3:
        {
            ECConfirmOrderInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderInfoCell)
                                                                                     forIndexPath:indexPath];
            ECConfirmOrderInfoModel *model = [_infoDataSource objectAtIndexWithCheck:indexPath.row];
            cell.model = model;
            return cell;
        }

            
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row > 0 && indexPath.row < _model.productList.count + 1) {
            ECOrderProductModel *model = [_model.productList objectAtIndexWithCheck:indexPath.row - 1];
            ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
            vc.protable = model.protable;
            vc.proId = model.proId;
            [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@""];
        }
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
