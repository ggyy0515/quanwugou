//
//  ECTakeMoneyViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTakeMoneyViewController.h"
#import "ECTakeMoneyCardCell.h"
#import "ECTakeMoneyAmountCell.h"
#import "ECTakeMoneyActionCell.h"
#import "ECWalletInfoModel.h"
#import "ECBankCardListModel.h"
#import "ECMyBankCardViewController.h"
#import "ECPayPasswordViewController.h"

#import "ECAccountResetPasswordViewController.h"

typedef NS_ENUM(NSInteger, TakeMoneyType) {
    TakeMoneyType_all,
    TakeMoneyType_amount
};

@interface ECTakeMoneyViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECWalletInfoModel *walletModel;
@property (nonatomic, strong) ECBankCardListModel *cardModel;
@property (nonatomic, copy) NSString *amount;

@end

@implementation ECTakeMoneyViewController

#pragma mark - Life Cycle

- (instancetype)initWithWalletInfoModel:(ECWalletInfoModel *)model {
    if (self = [super init]) {
        _walletModel = model;
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

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[ECTakeMoneyAmountCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyAmountCell)];
    [_collectionView registerClass:[ECTakeMoneyCardCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyCardCell)];
    [_collectionView registerClass:[ECTakeMoneyActionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyActionCell)];
    
}

#pragma mark - Actions

- (void)takeMoneyWithAmount:(NSString *)amount takeMoneyType:(TakeMoneyType)type {
    if (type == TakeMoneyType_amount) {
        if (_amount.length == 0 || _amount.floatValue == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入提现金额"];
            return;
        }
    }
    if (!_cardModel || _cardModel.bankId.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请选择银行卡"];
        return;
    }
    if (amount.floatValue > _walletModel.balance.floatValue) {
        [SVProgressHUD showInfoWithStatus:@"余额不足"];
        return;
    }
    
    if ([[USERDEFAULT objectForKey:EC_USER_ISSETPAYWD] isEqualToString:@"0"]) {
        ECAccountResetPasswordViewController *vc = [[ECAccountResetPasswordViewController alloc] init];
        vc.type = 2;
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"设置支付密码"];
    }else{
        [ECPayPasswordViewController showPayPasswordVCInSuperViewController:self amount:[NSString stringWithFormat:@"提现￥%@", amount] verifyResultBlock:^(BOOL isPasswordValid) {
            if (isPasswordValid) {
                [ECHTTPServer requestWalletBalanceTakeMoneyWithUserId:[Keychain objectForKey:EC_USER_ID]
                                                               amount:amount
                                                           bankCardId:_cardModel.bankId
                                                              succeed:^(NSURLSessionDataTask *task, id result) {
                                                                  if (IS_REQUEST_SUCCEED(result)) {
                                                                      POST_NOTIFICATION(NOTIFICATION_NAME_WALLET_BLANCEN_CHANGE, nil);
                                                                      RequestSuccess(result)
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  } else {
                                                                      EC_SHOW_REQUEST_ERROR_INFO
                                                                  }
                                                              }
                                                               failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                                   RequestFailure;
                                                               }];
            }
        }];
    }
}

#pragma mark - UICollection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(12.f, 0, 0, 0);
    }
    return UIEdgeInsetsMake(28.f, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, 52.f);
    }
    return CGSizeMake(SCREENWIDTH, 49.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //提现金额
                ECTakeMoneyAmountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyAmountCell)
                                                                                        forIndexPath:indexPath];
                [cell setAmountChange:^(NSString *amount) {
                    weakSelf.amount = amount;
                }];
                cell.model = _walletModel;
                return cell;
            }
                
            default:
            {
                //选择银行卡
                ECTakeMoneyCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyCardCell)
                                                                                      forIndexPath:indexPath];
                if (_cardModel) {
                    cell.model = _cardModel;
                }
                return cell;
            }
        }
    } else {
        //点击操作
        ECTakeMoneyActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakeMoneyActionCell)
                                                                                forIndexPath:indexPath];
        [cell setClickAllBtn:^{
            [weakSelf takeMoneyWithAmount:weakSelf.walletModel.balance takeMoneyType:TakeMoneyType_all];
        }];
        [cell setClickConfirmBtn:^{
            [weakSelf takeMoneyWithAmount:weakSelf.amount takeMoneyType:TakeMoneyType_amount];
        }];
        cell.model = _walletModel;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0 && indexPath.row == 1) {
        ECMyBankCardViewController *vc = [[ECMyBankCardViewController alloc] initWithMyBankCardType:MyBankCardType_select];
        [vc setDidSelectCard:^(ECBankCardListModel *cardModel) {
            weakSelf.cardModel = cardModel;
            [weakSelf.collectionView reloadData];
        }];
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择银行"];
    }
}



#pragma mark - UICollectionView Method

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
