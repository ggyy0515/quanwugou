//
//  ECConfirmOrderViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCartFactoryModel.h"
#import "ECCartProductModel.h"
#import "ECConfirmOrderViewController.h"
#import "ECConfirmOrderBottomView.h"
#import "ECConfirmOrderAddressCell.h"
#import "ECAddressModel.h"
#import "ECConfirmOrderBillInfoCell.h"
#import "ECConfirmOrderQcodeCell.h"
#import "ECConfirmOrderInfoCell.h"
#import "ECConfirmOrderFactoryHeader.h"
#import "ECConfirmOrderFactoryFooter.h"
#import "ECConfirmOrderProductCell.h"
#import "ECConfirmOrderInfoModel.h"
#import "ECSelectAddressViewController.h"
#import "ECPaymentViewController.h"
#import "ECCommitOrderInfoModel.h"
#import "ECCartViewController.h"
#import "ECMallProductDetailViewController.h"

@interface ECConfirmOrderViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECConfirmOrderBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *infoDataSource;
@property (nonatomic, strong) ECAddressModel *addressModel;
@property (nonatomic, assign) BOOL isNeedBill;
/**
 这个字段仅仅表示是否使用Q码（用于调整高度），不表示Q码验证通过，若果Q码验证通过，需要修改数据模型中的useQCode
 */
@property (nonatomic, assign) BOOL useQCode;
@property (nonatomic, copy) NSString *billInfo;
@property (nonatomic, copy) NSString *qcode;
/**
 当前应付金额
 */
@property (nonatomic, copy) NSString *payMoney;
/**
 实付商品总额（含尾款）
 */
@property (nonatomic, copy) NSString *totalMoney;


@end

@implementation ECConfirmOrderViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        _infoDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self requestAddressList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    _isNeedBill = NO;
    _useQCode = NO;
    
    if (!_bottomView) {
        _bottomView = [[ECConfirmOrderBottomView alloc] init];
    }
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49.f);
    }];
    [_bottomView setClickPayBtn:^{
        if (weakSelf.confirmType == ConfirmOrderType_cartCommit) {
            [weakSelf commitCartOrder];
        } else {
            [weakSelf commitOrder];
        }
        
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    [_collectionView registerClass:[ECConfirmOrderAddressCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderAddressCell)];
    [_collectionView registerClass:[ECConfirmOrderBillInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderBillInfoCell)];
    [_collectionView registerClass:[ECConfirmOrderQcodeCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderQcodeCell)];
    [_collectionView registerClass:[ECConfirmOrderInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderInfoCell)];
    [_collectionView registerClass:[ECConfirmOrderFactoryHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderFactoryHeader)];
    [_collectionView registerClass:[ECConfirmOrderProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderProductCell)];
    [_collectionView registerClass:[ECConfirmOrderFactoryFooter class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderFactoryFooter)];
    
    [self setDataSource:_dataSource];
}

#pragma mark - Setter 

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    if ([[USERDEFAULT objectForKey:EC_USER_STATUS] integerValue] != 0 ) {
        //如果不是普通用户，设置使用vip价格
        [self setUseQCodeWithState:YES];
    }
    
    __block NSInteger totalCount = 0;//商品数量
    __block CGFloat nowTotalPrice = 0;//当前应付金额、有可能不含尾款
    __block CGFloat totalOriginPrice = 0;//原价总额，不打折、不使用Q码、含尾款
    __block CGFloat totalPrice = 0;//应付总额 = nowTotalPrice + 尾款
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //遍历工厂
        __block CGFloat factoryPrice = 0;//每个工厂的当前的实付款(不含尾款)
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
            //遍历商品
            totalCount += productModel.count.integerValue;
            NSString *productPrice = nil;
            if (productModel.useQcode) {
                //使用Q码或会员价
                if (productModel.useEasyPay) {
                    //使用分期
                    productPrice = productModel.nowVipPay;
                } else {
                    //不使用分期
                    productPrice = productModel.vipPrice;
                }
                totalPrice += productModel.vipPrice.floatValue * productModel.count.integerValue;
            } else {
                //不使用Q码或非会员价
                if (productModel.useEasyPay) {
                    //使用分期
                    productPrice = productModel.nowPay;
                } else {
                    //不使用分期
                    productPrice = productModel.price;
                }
                totalPrice += productModel.price.integerValue * productModel.count.integerValue;
            }
            factoryPrice += productPrice.floatValue * productModel.count.integerValue;
            totalOriginPrice += productModel.price.floatValue * productModel.count.integerValue;
        }];
        nowTotalPrice += factoryPrice;
    }];
    
    
    
    [_infoDataSource removeAllObjects];
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"商品数量" content:[NSString stringWithFormat:@"%ld", (long)totalCount]]];
    //--------尾货或者抢购，这些项目不显示
    NSString *lastTitle = @"实付总款";
    if (!_isLeftProduct) {
        [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"商品原价" content:[NSString stringWithFormat:@"￥%.0lf", totalOriginPrice]]];
        [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:@"优惠金额" content:[NSString stringWithFormat:@"-￥%.0lf", totalOriginPrice - totalPrice]]];
        if (!_isPanicBuy) {
            lastTitle = @"实付总款（含尾款）";
        }
    }
    //--------尾货或者抢购，这些项目不显示
    [_infoDataSource addObject:[ECConfirmOrderInfoModel modelWithTitle:lastTitle content:[NSString stringWithFormat:@"￥%.0lf", totalPrice]]];
    _payMoney = [NSString stringWithFormat:@"%.0lf", nowTotalPrice];//当前应付金额、有可能不含尾款
    _totalMoney = [NSString stringWithFormat:@"%.0lf", totalPrice];//实付商品总额（含尾款）
    _bottomView.price = nowTotalPrice;
    [_collectionView reloadData];
}

#pragma mark - Actions

- (void)requestAddressList{
    SHOWSVP
    [ECHTTPServer requestAddressListsucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            for (NSDictionary *dict in result[@"list"]) {
                _addressModel = [ECAddressModel yy_modelWithDictionary:dict];
                if (_addressModel.is_default.integerValue == 1) {
                    break;
                }
            }
            [_collectionView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)setUseQCodeWithState:(BOOL)isValid {
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            model.useQcode = isValid;
        }];
    }];
}

//获取通过购物车提交订单时需要的cartInfo
- (NSString *)loadCartInfoJsonString {
    NSMutableArray *infoArray = [NSMutableArray array];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{
                                  @"ord_cart_id":productModel.cartId,
                                  @"iseasypay":productModel.useEasyPay ? @"1" : @"0"
                                  };
            [infoArray addObject:dic];
        }];
    }];
    return [infoArray JSONString];
}

- (BOOL)orderUseQcode {
    //如果是vip用户，直接返回YES
    
    __block BOOL isUse = NO;
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL needStop = NO;
        [factoryModel.productList enumerateObjectsUsingBlock:^(ECCartProductModel * _Nonnull productModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (productModel.useQcode) {
                isUse = YES;
                needStop = YES;
                *stop = YES;
            }
        }];
        if (needStop) {
            *stop = YES;
        }
    }];
    return isUse;
}

//获取给卖家的留言
- (NSString *)loadMessages {
    NSMutableDictionary *messages = [NSMutableDictionary dictionary];
    [_dataSource enumerateObjectsUsingBlock:^(ECCartFactoryModel * _Nonnull factoryModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [messages setValue:STR_EXISTS(factoryModel.message) forKey:factoryModel.sellerId];
    }];
    return [messages JSONString];
}

//提交购物车订单
- (void)commitCartOrder {
    if (!(_addressModel && _addressModel.delivery_id)) {
        [SVProgressHUD showInfoWithStatus:@"请完善收货信息"];
        return;
    }
    [SVProgressHUD show];
    [ECHTTPServer requestCartCommitOrderWithUserId:[Keychain objectForKey:EC_USER_ID]
                                          cartInfo:[self loadCartInfoJsonString]
                                         addressId:_addressModel.delivery_id
                                        totalPrice:_totalMoney
                                            nowPay:_payMoney
                                        isDiscount:[self orderUseQcode] ? @"1" : @"0"
                                             qcode:_qcode
                                         billTitle:_billInfo
                                           message:[self loadMessages]
                                           succeed:^(NSURLSessionDataTask *task, id result) {
                                               ECLog(@"%@", result);
                                               if (IS_REQUEST_SUCCEED(result)) {
                                                   //RequestSuccess(result)
                                                   [APP_DELEGATE updateCartNumberCacheFromNetwork];
                                                   POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_CART_DATA, nil);
                                                   POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                                   DISMISSSVP
                                                   ECCommitOrderInfoModel *model = [ECCommitOrderInfoModel yy_modelWithDictionary:result];
                                                   model.type = @"nowpay";
                                                   [self gotoPaymentVCWithInfoModel:model];
                                               } else {
                                                   EC_SHOW_REQUEST_ERROR_INFO
                                               }
                                           }
                                            failed:^(NSURLSessionDataTask *task, NSError *error) {
                                               RequestFailure
                                            }];
}

//提交立即购买订单
- (void)commitOrder {
    if (!(_addressModel && _addressModel.delivery_id)) {
        [SVProgressHUD showInfoWithStatus:@"请完善收货信息"];
        return;
    }
    [SVProgressHUD show];
    [ECHTTPServer requestCommitOrderWithUserId:[Keychain objectForKey:EC_USER_ID]
                                   addressInfo:_addressModel.delivery_id
                                    totalPrice:_totalMoney
                                        nowPay:_payMoney
                                    isDiscount:[self orderUseQcode] ? @"1" : @"0"
                                         qcode:_qcode
                                     billTitle:_billInfo
                                       message:[self loadMessages]
                                      protable:((ECCartProductModel *)[(((ECCartFactoryModel *)[_dataSource objectAtIndex:0]).productList) objectAtIndex:0]).protable
                                         proId:((ECCartProductModel *)[(((ECCartFactoryModel *)[_dataSource objectAtIndex:0]).productList) objectAtIndex:0]).proId
                                         count:@"1"
                                     isEasyPay:((ECCartProductModel *)[(((ECCartFactoryModel *)[_dataSource objectAtIndex:0]).productList) objectAtIndex:0]).useEasyPay ? @"1" : @"0"
                                       succeed:^(NSURLSessionDataTask *task, id result) {
                                           ECLog(@"%@", result);
                                           if (IS_REQUEST_SUCCEED(result)) {
                                               POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
                                               DISMISSSVP
                                               ECCommitOrderInfoModel *model = [ECCommitOrderInfoModel yy_modelWithDictionary:result];
                                               model.type = @"nowpay";
                                               [self gotoPaymentVCWithInfoModel:model];
                                           } else {
                                               EC_SHOW_REQUEST_ERROR_INFO
                                           }
                                       }
                                        failed:^(NSURLSessionDataTask *task, NSError *error) {
                                           RequestFailure
                                        }];
}

- (void)gotoPaymentVCWithInfoModel:(ECCommitOrderInfoModel *)model {
    Class cls;
    if (_confirmType == ConfirmOrderType_cartCommit) {
        cls = [ECCartViewController class];
    } else {
        cls = [ECMallProductDetailViewController class];
    }
    ECPaymentViewController *vc = [[ECPaymentViewController alloc] initWithPopClass:cls];
    vc.model = model;
    [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"支付总额"];
}

#pragma mark - UICollectionView Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (!_dataSource) {
        return 0;
    }
    return _dataSource.count + 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        //地址
        return 1;
    }else if (section == _dataSource.count + 1) {
        //发票信息
        return 1;
    } else if (section == _dataSource.count + 2) {
        //Q码
        if ([[USERDEFAULT objectForKey:EC_USER_STATUS] integerValue] != 0 || _isLeftProduct || _isPanicBuy) {
            return 0;
        }
        return 1;
    } else if (section == _dataSource.count + 3) {
        //信息
        return _infoDataSource.count;
    } else {
        //商品
        ECCartFactoryModel *model = [_dataSource objectAtIndexWithCheck:section - 1];
        return model.productList.count + 1;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section > 0 && section < _dataSource.count + 1) {
        return CGSizeMake(SCREENWIDTH, 36.f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 0 && indexPath.section < _dataSource.count + 1) {
        ECCartFactoryModel *model = [_dataSource objectAtIndexWithCheck:indexPath.section - 1];
        if (kind == UICollectionElementKindSectionHeader) {
            ECConfirmOrderFactoryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                     withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderFactoryHeader)
                                                                                            forIndexPath:indexPath];
            header.model = model;
            return header;
            
        }
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        //地址
        NSString *addressStr = [NSString stringWithFormat:@"%@%@",_addressModel.area,_addressModel.address];
        CGFloat addressHeight = ceilf([addressStr boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f - 22.f - 12.f, 10000)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:FONT_28}
                                                               context:nil].size.height);
        return CGSizeMake(SCREENWIDTH, 80.f - 14.f + addressHeight);
    } else if (indexPath.section == _dataSource.count + 1) {
        //发票信息
        if (_isNeedBill) {
            return CGSizeMake(SCREENWIDTH, 170.f);
        } else {
            return CGSizeMake(SCREENWIDTH, 54.f);
        }
    } else if (indexPath.section == _dataSource.count + 2) {
        //Q码
        if (_useQCode) {
            return CGSizeMake(SCREENWIDTH, 108.f);
        } else {
            return CGSizeMake(SCREENWIDTH, 54.f);
        }
    } else if (indexPath.section == _dataSource.count + 3) {
        //信息
        return CGSizeMake(SCREENWIDTH, 44.f);
    } else {
        //商品
        ECCartFactoryModel *factoryModel = [_dataSource objectAtIndexWithCheck:indexPath.section - 1];
        if (indexPath.row == factoryModel.productList.count) {
            return CGSizeMake(SCREENWIDTH, 44.f);
        } else {
            return CGSizeMake(SCREENWIDTH, 92.f);
        }
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(8, 0, 8, 0);
    } else if (section == _dataSource.count + 2) {
        if ([[USERDEFAULT objectForKey:EC_USER_STATUS] integerValue] != 0 || _isPanicBuy || _isLeftProduct) {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            return UIEdgeInsetsMake(0, 0, 8, 0);
        }
    } else {
        return UIEdgeInsetsMake(0, 0, 8, 0);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == _dataSource.count + 3) {
        return 0.f;
    }
    return 1.f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    
    if (indexPath.section == 0) {
        //地址
        ECConfirmOrderAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderAddressCell)
                                                                                    forIndexPath:indexPath];
        cell.model = _addressModel;
        return cell;
    } else if (indexPath.section == _dataSource.count + 1) {
        //发票信息
        ECConfirmOrderBillInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderBillInfoCell)
                                                                                     forIndexPath:indexPath];
        [cell setBillSateChanged:^(BOOL isNeed) {
            weakSelf.isNeedBill = isNeed;
            [weakSelf.collectionView reloadData];
        }];
        [cell setDidInputBillInfo:^(NSString *billInfo) {
            weakSelf.billInfo = billInfo;
        }];
        return cell;
    } else if (indexPath.section == _dataSource.count + 2) {
        //Q码
        ECConfirmOrderQcodeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderQcodeCell)
                                                                                  forIndexPath:indexPath];
        //控制开关
        [cell setUseQCodel:^(BOOL useQCode) {
            weakSelf.useQCode = useQCode;
            if (!useQCode) {
                weakSelf.qcode = nil;
            }
            //设置数据模型中的useQcode为NO
            [weakSelf setUseQCodeWithState:NO];
            [weakSelf setDataSource:weakSelf.dataSource];
        }];
        //验证Qcode
        [cell setDidLoadQcodeValidState:^(NSString *qcode, BOOL isValid) {
            weakSelf.qcode = qcode;
            if (isValid) {
                //设置数据模型中的useQcode为YES
                [weakSelf setUseQCodeWithState:YES];
            } else {
                //设置数据模型中的useQcode为NO
                [weakSelf setUseQCodeWithState:NO];
            }
            
            [weakSelf setDataSource:weakSelf.dataSource];
        }];
        cell.qCode = _qcode;
        return cell;
    } else if (indexPath.section == _dataSource.count + 3) {
        //信息
        ECConfirmOrderInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderInfoCell)
                                                                                 forIndexPath:indexPath];
        ECConfirmOrderInfoModel *model = [_infoDataSource objectAtIndexWithCheck:indexPath.row];
        cell.model = model;
        return cell;
    } else {
        //商品
        ECCartFactoryModel *factoryModel = [_dataSource objectAtIndexWithCheck:indexPath.section - 1];
        if (indexPath.row == factoryModel.productList.count) {
            //footer作为一个cell，解决布局问题
            ECConfirmOrderFactoryFooter *footer = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderFactoryFooter)
                                                                                            forIndexPath:indexPath];
            footer.model = factoryModel;
            return footer;
        } else {
            ECCartProductModel *model = [factoryModel.productList objectAtIndexWithCheck:indexPath.row];
            ECConfirmOrderProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderProductCell)
                                                                                        forIndexPath:indexPath];
            [cell setRefreshPrice:^{
                [weakSelf setDataSource:weakSelf.dataSource];
            }];
            cell.model = model;
            return cell;
        }
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0) {
        //选择地址
        ECSelectAddressViewController *vc = [[ECSelectAddressViewController alloc] init];
        if (_addressModel) {
            vc.addressID = _addressModel.delivery_id;
        }
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择收货地址"];
        [vc setSelectAddressBlock:^(ECAddressModel *model) {
            weakSelf.addressModel = model;
            [weakSelf setDataSource:weakSelf.dataSource];
        }];
    }
}

//*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
