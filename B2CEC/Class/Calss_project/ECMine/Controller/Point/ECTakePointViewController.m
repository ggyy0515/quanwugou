//
//  ECTakePointViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/26.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECTakePointViewController.h"
#import "ECPointInfoModel.h"
#import "ECTakePointInputCell.h"
#import "ECTakePointDispCell.h"
#import "ECTakePointActionCell.h"
#import "ECPayPasswordViewController.h"

typedef NS_ENUM(NSInteger, TakePointType) {
    TakePointType_all,
    TakePointType_amount
};

@interface ECTakePointViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>


@property (nonatomic, copy) ECPointInfoModel *pointInfoModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *point;

@end

@implementation ECTakePointViewController

#pragma mark - Life Cycle

- (instancetype)initWithPointInfoModel:(ECPointInfoModel *)model {
    if (self = [super init]) {
        _pointInfoModel = model;
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
    [_collectionView registerClass:[ECTakePointInputCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointInputCell)];
    [_collectionView registerClass:[ECTakePointDispCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointDispCell)];
    [_collectionView registerClass:[ECTakePointActionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointActionCell)];
}


#pragma mark - Actions

- (void)takePointWithPoint:(NSString *)point takePointType:(TakePointType)type {
    if (type == TakePointType_amount) {
        if (point.length == 0 || point.floatValue == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入兑现积分"];
            return;
        }
    }
    if (point.floatValue > _pointInfoModel.point.floatValue) {
        [SVProgressHUD showInfoWithStatus:@"可用积分不足"];
        return;
    }
    [ECPayPasswordViewController showPayPasswordVCInSuperViewController:self amount:[NSString stringWithFormat:@"积分%@", point] verifyResultBlock:^(BOOL isPasswordValid) {
        if (isPasswordValid) {
            [ECHTTPServer requestTakePointWithUserId:[Keychain objectForKey:EC_USER_ID]
                                               point:point
                                             succeed:^(NSURLSessionDataTask *task, id result) {
                                                 if (IS_REQUEST_SUCCEED(result)) {
                                                     POST_NOTIFICATION(NOTIFICATION_NAME_USER_POINT_CHANGED, nil);
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
                ECTakePointInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointInputCell)
                                                                                       forIndexPath:indexPath];
                [cell setPointChange:^(NSString *point) {
                    weakSelf.point = point;
                    [weakSelf.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
                }];
                cell.model = _pointInfoModel;
                return cell;
            }
            default:
            {
                ECTakePointDispCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointDispCell)
                                                                                      forIndexPath:indexPath];
                cell.model = _pointInfoModel;
                if (_point) {
                    cell.point = _point;
                }
                return cell;
            }
        }
    } else {
        ECTakePointActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECTakePointActionCell)
                                                                                forIndexPath:indexPath];
        [cell setClickAllBtn:^{
            [weakSelf takePointWithPoint:weakSelf.pointInfoModel.point takePointType:TakePointType_all];
        }];
        [cell setClickConfirmBtn:^{
            [weakSelf takePointWithPoint:weakSelf.point takePointType:TakePointType_amount];
        }];
        cell.model = _pointInfoModel;
        return cell;
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
