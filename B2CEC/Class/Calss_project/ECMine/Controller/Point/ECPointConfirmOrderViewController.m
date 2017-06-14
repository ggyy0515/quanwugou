//
//  ECPointConfirmOrderViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointConfirmOrderViewController.h"
#import "ECPointProductListModel.h"
#import "ECPointConfirmOrderBottomView.h"
#import "ECConfirmOrderAddressCell.h"
#import "ECAddressModel.h"
#import "ECConfirmOrderProductCell.h"
#import "ECSelectAddressViewController.h"
#import "ECPayPasswordViewController.h"
#import "ECSettingPayPasswordViewController.h"

@interface ECPointConfirmOrderViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>


@property (nonatomic, strong) ECPointProductListModel *listModel;
@property (nonatomic, strong) ECAddressModel *addressModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ECPointConfirmOrderBottomView *bottomView;


@end

@implementation ECPointConfirmOrderViewController

#pragma mark - Life Cycle

- (instancetype)initWithModel:(ECPointProductListModel *)model {
    if (self = [super init]) {
        _listModel = model;
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
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_bottomView) {
        _bottomView = [[ECPointConfirmOrderBottomView alloc] init];
    }
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(49.f);
    }];
    [_bottomView setClickPayBtn:^{
        [weakSelf commitOrder];
    }];
    _bottomView.point = _listModel.point.integerValue;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(12.f, 0.f, 0.f, 0.f);
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
    [_collectionView registerClass:[ECConfirmOrderProductCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderProductCell)];
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

- (void)commitOrder {
    if (![USERDEFAULT objectForKey:EC_USER_ISSETPAYWD]) {
        ECSettingPayPasswordViewController *vc = [[ECSettingPayPasswordViewController alloc] init];
        [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"设置支付密码"];
        return;
    }
    [ECPayPasswordViewController showPayPasswordVCInSuperViewController:self amount:[NSString stringWithFormat:@"%@积分", _listModel.point] verifyResultBlock:^(BOOL isPasswordValid) {
        if (isPasswordValid) {
            [ECHTTPServer requestCommitPointOrderWithUserId:[Keychain objectForKey:EC_USER_ID]
                                                      proId:_listModel.proId
                                                  addressId:_addressModel.delivery_id
                                                    succeed:^(NSURLSessionDataTask *task, id result) {
                                                        if (IS_REQUEST_SUCCEED(result)) {
                                                            RequestSuccess(result);
                                                            POST_NOTIFICATION(NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
                                                            [self.navigationController popViewControllerAnimated:YES];
                                                        } else {
                                                            EC_SHOW_REQUEST_ERROR_INFO
                                                        }
                                                    }
                                                     failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                         RequestFailure
                                                     }];
        }
    }];
}

#pragma mark - UICollectionView Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NSString *addressStr = [NSString stringWithFormat:@"%@%@",_addressModel.area,_addressModel.address];
            CGFloat addressHeight = ceilf([addressStr boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f - 22.f - 12.f, 10000)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:FONT_28}
                                                                   context:nil].size.height);
            return CGSizeMake(SCREENWIDTH, 80.f - 14.f + addressHeight);
        }
        case 1:
            return CGSizeMake(SCREENWIDTH, 92.f);
            
            
        default:
            return CGSizeZero;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //地址
        ECConfirmOrderAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderAddressCell)
                                                                                    forIndexPath:indexPath];
        cell.model = _addressModel;
        return cell;
    } else {
        //商品
        ECConfirmOrderProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECConfirmOrderProductCell)
                                                                                    forIndexPath:indexPath];
        if (_listModel) {
            cell.pointModel = _listModel;
        }
        return cell;
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
            [weakSelf.collectionView reloadData];
        }];
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
