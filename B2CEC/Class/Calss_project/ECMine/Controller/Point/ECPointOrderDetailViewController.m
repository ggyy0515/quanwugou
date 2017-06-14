//
//  ECPointOrderDetailViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointOrderDetailViewController.h"
#import "ECPointOrderDetailInfoModel.h"
#import "ECPointOrderListCell.h"
#import "ECPointOrderListModel.h"
#import "ECOrderDetailAddressCell.h"
#import "ECPointOrderDetailExpressHeader.h"
#import "ECPointOrderExpressListCell.h"

@interface ECPointOrderDetailViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) ECPointOrderDetailInfoModel *infoModel;
@property (nonatomic, strong) ECPointOrderListModel *listModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *expressDataSource;

@end

@implementation ECPointOrderDetailViewController

#pragma mark - Life Cycle

- (instancetype)initWithOrderId:(NSString *)orderId {
    if (self = [super init]) {
        _orderId = orderId;
        _expressDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_collectionView registerClass:[ECPointOrderListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderListCell)];
    [_collectionView registerClass:[ECOrderDetailAddressCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailAddressCell)];
    [_collectionView registerClass:[ECPointOrderDetailExpressHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderDetailExpressHeader)];
    [_collectionView registerClass:[ECPointOrderExpressListCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderExpressListCell)];
}

#pragma mark - Action

- (void)loadDataSource {
    SHOWSVP
    [ECHTTPServer requestPointOrderDetailWithOrderId:_orderId
                                             succeed:^(NSURLSessionDataTask *task, id result) {
                                                 if (IS_REQUEST_SUCCEED(result)) {
                                                     _infoModel = [ECPointOrderDetailInfoModel yy_modelWithDictionary:result[@"integralPd"]];
                                                     _listModel = [[ECPointOrderListModel alloc] initWithECPointOrderDetailInfoModel:_infoModel];
                                                     if (!_listModel) {
                                                         DISMISSSVP
                                                         [_collectionView reloadData];
                                                     } else {
                                                         [self loadExpressList];
                                                     }
                                                 } else {
                                                     EC_SHOW_REQUEST_ERROR_INFO
                                                 }
                                             }
                                              failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                 RequestFailure
                                              }];
}

- (void)loadExpressList {
    [ECHTTPServer requestExpressDeliveryWithCom:_infoModel.expressCode
                                    OrderNumber:_infoModel.expressNumber
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            DISMISSSVP
                                            _expressDataSource = result[@"queryLogistics"][@"data"];
                                            [_collectionView reloadData];
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                             RequestFailure
                                         }];
}

#pragma mark - UICollectionView Methd

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return _expressDataSource.count;
        default:
            return 0;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0:
            return UIEdgeInsetsMake(12.f, 0, 12.f, 0);
        default:
            return UIEdgeInsetsMake(0, 0, 12.f, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return CGSizeMake(SCREENWIDTH, 60.f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && kind == UICollectionElementKindSectionHeader) {
        ECPointOrderDetailExpressHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                     withReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderDetailExpressHeader)
                                                                                            forIndexPath:indexPath];
        header.model = _infoModel;
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(SCREENWIDTH, 116.f);
        case 1:
            return CGSizeMake(SCREENWIDTH, 176.f / 2.f);
        case 2:
        {
            NSString *str = @"【深圳市】 快件已到达 深圳转运中心我的大屌早已饥渴难耐";
            CGFloat addressHeight = [CMPublicMethod getHeightWithContent:str width:SCREENWIDTH-48 font:14.f];
            return CGSizeMake(SCREENWIDTH, 68.f+addressHeight-20.f);
        }
            
        default:
            return CGSizeZero;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            ECPointOrderListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderListCell)
                                                                                   forIndexPath:indexPath];
            if (_listModel) {
                cell.model = _listModel;
            }
            return cell;
        }
        case 1:
        {
            ECOrderDetailAddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderDetailAddressCell)
                                                                                       forIndexPath:indexPath];
            if (_infoModel) {
                cell.pointModel = _infoModel;
            }
            return cell;
        }
        case 2:
        {
            ECPointOrderExpressListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointOrderExpressListCell)
                                                                                          forIndexPath:indexPath];
            cell.addressLabel.text = [_expressDataSource objectAtIndexWithCheck:indexPath.row-1][@"context"];
            cell.dateLabel.text = [_expressDataSource objectAtIndexWithCheck:indexPath.row-1][@"time"];
            if (indexPath.row == 0) {
                cell.isFristOrFinall = 1;
            }else if (indexPath.row == _expressDataSource.count - 1) {
                cell.isFristOrFinall = 2;
            }else{
                cell.isFristOrFinall = 0;
            }
            
        }
        default:
            return nil;
            break;
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
