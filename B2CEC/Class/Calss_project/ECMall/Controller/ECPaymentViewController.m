//
//  ECPaymentViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/7.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <objc/runtime.h>
#import <AlipaySDK/AlipaySDK.h>

#import "WXApiObject.h"
#import "WXApi.h"

#import "UPPaymentControl.h"

#import "ECPaymentViewController.h"
#import "ECPaymentInfoCell.h"
#import "ECPaymentHeaderCell.h"
#import "ECPaymentMethodCell.h"
#import "ECPaymentFooterView.h"
#import "ECCommitOrderInfoModel.h"
#import "ECWalletInfoModel.h"
#import "ECPayPasswordViewController.h"
#import "ECSettingPayPasswordViewController.h"

@interface ECPaymentViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) Class popClass;

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;//导航栏底部的黑线
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *picArray;
@property (nonatomic, strong) ECWalletInfoModel *walletInfoModel;

@end

@implementation ECPaymentViewController

- (instancetype)initWithPopClass:(Class)cls {
    if (self = [super init]) {
        _popClass = cls;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    _titleArray = @[@"我的钱包",
                    @"支付宝",
                    @"微信",
                    @"银联"];
    _picArray = @[@"shop_wallet",
                  @"shop_zhifubao",
                  @"shop_weixinzhifu",
                  @"shop_bank"];
    
    [SELF_BASENAVI.backBtn addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    SELF_BASENAVI.backBtn.selected = YES;
    
    [self createUI];
    [self loadWalletInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    SELF_BASENAVI.interactivePopGestureRecognizer.enabled = NO;
    [SELF_BASENAVI.backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    SELF_BASENAVI.titleLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yy_imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
    self.navBarHairlineImageView.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    SELF_BASENAVI.interactivePopGestureRecognizer.enabled = YES;
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
        layout.minimumLineSpacing = 1.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BaseColor;
    _collectionView.bounces = NO;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECPaymentInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentInfoCell)];
    [_collectionView registerClass:[ECPaymentHeaderCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentHeaderCell)];
    [_collectionView registerClass:[ECPaymentMethodCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentMethodCell)];
    [_collectionView registerClass:[ECPaymentFooterView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentFooterView)];
}

#pragma mark - Setter

- (void)setModel:(ECCommitOrderInfoModel *)model {
    _model = model;
    [_collectionView reloadData];
}


#pragma mark - Actions

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)backItemClick {
    __block UIViewController *popVC = nil;
    [SELF_BASENAVI.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:_popClass]) {
            popVC = vc;
            *stop = YES;
        }
    }];
    if (popVC) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        SELF_BASENAVI.interactivePopGestureRecognizer.enabled = YES;
        [SELF_BASENAVI.backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        SELF_BASENAVI.titleLabel.textColor = MainColor;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navBarHairlineImageView.hidden = NO;
        [self.navigationController popToViewController:popVC animated:YES];
    }
}

- (void)loadWalletInfo {
    [ECHTTPServer requestMyWalletInfoWithUserId:[Keychain objectForKey:EC_USER_ID]
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                _walletInfoModel = [ECWalletInfoModel yy_modelWithDictionary:result[@"account"]];
                                                [_collectionView reloadData];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                            RequestFailure
                                         }];
}

- (void)paySucceedAction {
    if ([_model.type isEqualToString:@"designpay"]) {//如果是设计订单
        POST_NOTIFICATION(NOTIFICATION_DESIGNER_PAY_SUCCESS, nil);
    }else{
        POST_NOTIFICATION(NOTIFICATION_NEED_RELOAD_MINE_DATA, nil);
        POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_LIST_DATA, nil);
        POST_NOTIFICATION(NOTIFICATION_NAME_RELOAD_ORDER_DETAIL_DATA, nil);
    }
    [self backItemClick];
}


//显示支付密码界面
- (void)showPayPasswordVC {
    if (_walletInfoModel.balance.floatValue < _model.nowPay.floatValue) {
        [SVProgressHUD showInfoWithStatus:@"钱包余额不足"];
        return;
    }
    if ([[USERDEFAULT objectForKey:EC_USER_ISSETPAYWD] integerValue] == 0) {
        ECSettingPayPasswordViewController *vc = [[ECSettingPayPasswordViewController alloc] init];
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"设置支付密码"];
        return;
    }
    [ECPayPasswordViewController showPayPasswordVCInSuperViewController:self amount:[NSString stringWithFormat:@"￥%@", _model.nowPay] verifyResultBlock:^(BOOL isPasswordValid) {
        if (isPasswordValid) {
            [self payUseWallet];
        }
    }];
}

//钱包支付
- (void)payUseWallet {
    NSString *orderNum = [_model.orderNumbers componentsJoinedByString:@","];
    if ([_model.type isEqualToString:@"designpay"]) {//如果是设计订单
        [ECHTTPServer requestDesignerOrderWalletPayWithID:orderNum WithMoney:_model.nowPay succeed:^(NSURLSessionDataTask *task, id result) {
            if (IS_REQUEST_SUCCEED(result)) {
                RequestSuccess(result);
                [self paySucceedAction];
            } else {
                EC_SHOW_REQUEST_ERROR_INFO
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            RequestFailure
        }];
    }else{
        [ECHTTPServer requestPayOrderUseWalletWithOrderNum:orderNum
                                                    amount:_model.nowPay
                                                      type:_model.type
                                                   succeed:^(NSURLSessionDataTask *task, id result) {
                                                       if (IS_REQUEST_SUCCEED(result)) {
                                                           RequestSuccess(result);
                                                           [self paySucceedAction];
                                                       } else {
                                                           EC_SHOW_REQUEST_ERROR_INFO
                                                       }
                                                   }
                                                    failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                        RequestFailure
                                                    }];
    }
}

//支付宝支付
- (void)payUseAliPay {
    WEAK_SELF
    NSString *orderNo = [_model.orderNumbers componentsJoinedByString:@","];
    SHOWSVP
    [ECHTTPServer requestAliSignWithBody:@"全屋构订单支付"
                                 orderNo:orderNo
                                  amount:_model.nowPay
                                    type:_model.type
                                 succeed:^(NSURLSessionDataTask *task, id result) {
                                     DISMISSSVP
                                     NSData *data = (NSData *)result;
                                     NSString *orderString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                     NSString *scheme = [[NSBundle mainBundle] bundleIdentifier];
                                     
                                     if ([orderString isEqualToString:@"0"]) {
                                         [SVProgressHUD showErrorWithStatus:@"网络状况不佳"];
                                         return ;
                                     }
                                     [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
                                         NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                                         if ([resultStatus isEqualToString:@"6001"]) {
                                             [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                                         }else{
                                             if ([resultStatus isEqualToString:@"9000"]) {
                                                 [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                                                 [weakSelf paySucceedAction];
                                             } else {
                                                 [SVProgressHUD showErrorWithStatus:@"支付失败"];
                                             }
                                         }
                                     }];
                                 }
                                  failed:^(NSURLSessionDataTask *task, NSError *error) {
                                      RequestFailure
                                  }];
}

//微信支付
- (void)payUseWxPay {
    WEAK_SELF
    NSString *orderNo = [_model.orderNumbers componentsJoinedByString:@","];
    SHOWSVP
    [ECHTTPServer requestWxSignWithBody:@"全屋构订单支付"
                                orderNo:orderNo
                                 amount:_model.nowPay
                                   type:_model.type
                                succeed:^(NSURLSessionDataTask *task, id result) {
                                    if (IS_REQUEST_SUCCEED(result)) {
                                        DISMISSSVP
                                        
                                        [APP_DELEGATE setWeChatPaySuccessBlock:^(int payCode) {
                                            if (payCode == WXErrCodeUserCancel) {//取消支付
                                                [SVProgressHUD showErrorWithStatus:@"用户取消支付"];
                                            }else{
                                                [weakSelf paySucceedAction];
                                            }
                                        }];
                                        
                                        NSDictionary *signDict = result[@"sign"];
                                        PayReq *req = [[PayReq alloc] init];
                                        req.partnerId = [signDict objectForKey:@"partnerid"];
                                        req.prepayId = [signDict objectForKey:@"prepayid"];
                                        req.nonceStr = [signDict objectForKey:@"noncestr"];
                                        req.timeStamp = [[signDict objectForKey:@"timestamp"] intValue];
                                        req.package = [signDict objectForKey:@"package"];
                                        req.sign = [signDict objectForKey:@"sign"];
                                        BOOL successful =  [WXApi sendReq:req];
                                        if (!successful) {
                                            [CMPublicMethod showInfoWithString:@"请求失败请重试！"];
                                        }
                                    } else {
                                        EC_SHOW_REQUEST_ERROR_INFO
                                    }
                                }
                                 failed:^(NSURLSessionDataTask *task, NSError *error) {
                                     RequestFailure
                                 }];
}


//银联支付
- (void)payUseUnionPay {
    WEAK_SELF
    NSString *orderNo = [_model.orderNumbers componentsJoinedByString:@","];
    SHOWSVP
    [ECHTTPServer requestUnionPaySignWithUserId:[Keychain objectForKey:EC_USER_ID]
                                        orderNo:orderNo
                                         amount:_model.nowPay
                                           type:_model.type
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                DISMISSSVP
                                                
                                                [APP_DELEGATE setUPPaymentSuccessBlock:^(NSString *code ,NSDictionary *data) {
                                                    if ([code isEqualToString:@"success"]) {
                                                        [CMPublicMethod showInfoWithString:@"银联支付成功!"];
                                                        [weakSelf paySucceedAction];
                                                        return;
                                                    }
                                                    if ([code isEqualToString:@"fail"]) {
                                                        [CMPublicMethod showInfoWithString:@"银联支付失败！请重试！"];
                                                        return;
                                                    }
                                                    if ([code isEqualToString:@"cancel"]) {
                                                        [CMPublicMethod showInfoWithString:@"银联支付取消"];
                                                        return;
                                                    }
                                                }];
                                                
                                                NSString *scheme = [[NSBundle mainBundle] bundleIdentifier];
                                                [[UPPaymentControl defaultControl] startPay:result[@"tn"]
                                                                                 fromScheme:scheme
                                                                                       mode:result[@"mode"]
                                                                             viewController:self];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                         }];
}

#pragma mark - UIcollectionView Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 1;
        case 2:
            return _titleArray.count;
        default:
            return 0;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return UIEdgeInsetsMake(0, 0, 12.f, 0);
        case 1:
            return UIEdgeInsetsMake(0, 12.f, 1.f, 12.f);
        case 2:
            return UIEdgeInsetsMake(0, 12.f, 12.f, 12.f);
            
        default:
            return UIEdgeInsetsMake(0, 0, 0, 0);
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(SCREENWIDTH, 150.f);
        case 1:
            return CGSizeMake(SCREENWIDTH - 24.f, 44.f);
        case 2:
            return CGSizeMake(SCREENWIDTH - 24.f, 80.f);
            
        default:
            return CGSizeZero;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            ECPaymentInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentInfoCell)
                                                                                forIndexPath:indexPath];
            cell.model = _model;
            return cell;
        }
        case 1:
        {
            ECPaymentHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentHeaderCell)
                                                                                  forIndexPath:indexPath];
            return cell;
        }
        case 2:
        {
            ECPaymentMethodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentMethodCell)
                                                                                  forIndexPath:indexPath];
            if (indexPath.row == 0) {
                if (_walletInfoModel) {
                    cell.contentLabel.hidden = NO;
                    cell.contentLabel.text = [NSString stringWithFormat:@"￥%@", _walletInfoModel.balance];
                }
                
            } else {
                cell.contentLabel.hidden = YES;
            }
            cell.titleLabel.text = [_titleArray objectAtIndexWithCheck:indexPath.row];
            [cell.imageView setImage:[UIImage imageNamed:[_picArray objectAtIndexWithCheck:indexPath.row]]];
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREENWIDTH - 24.f, 44.f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && kind == UICollectionElementKindSectionFooter) {
        ECPaymentFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                         withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPaymentFooterView)
                                                                                forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                //钱包支付
                [self showPayPasswordVC];
            }
                break;
            case 1:
            {
                //支付宝支付
                [self payUseAliPay];
            }
                break;
            case 2:
            {
                //微信支付
                [self payUseWxPay];
            }
                break;
            default:
            {
                //银联支付
                [self payUseUnionPay];
            }
                break;
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
