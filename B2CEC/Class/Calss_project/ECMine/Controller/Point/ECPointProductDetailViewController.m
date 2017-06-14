//
//  ECPointProductDetailViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPointProductDetailViewController.h"
#import "ECPointProductListModel.h"
#import "ECProductCycleCell.h"
#import "ECPointProductDetailInfoModel.h"
#import "ECPointProductDetailBottomView.h"
#import "ECPointProductDetailInfoCell.h"
#import "ECPointProductDetailWebCell.h"
#import "ECPointConfirmOrderViewController.h"
#import "ECPointInfoModel.h"

@interface ECPointProductDetailViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) ECPointProductListModel *listModel;
@property (nonatomic, strong) ECPointProductDetailBottomView *bottomView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *cycleImageList;
@property (nonatomic, strong) ECPointProductDetailInfoModel *infoModel;
@property (nonatomic, assign) CGFloat webCellHeight;


@end

@implementation ECPointProductDetailViewController

#pragma mark - Life Cycle

- (instancetype)initWithModel:(ECPointProductListModel *)listModel {
    if (self = [super init]) {
        _listModel = listModel;
        _cycleImageList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webCellHeight = 0.f;
    [self createUI];
    [self loadDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = BaseColor;
    
    if (!_bottomView) {
        _bottomView = [[ECPointProductDetailBottomView alloc] init];
    }
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(64.f);
    }];
    [_bottomView setClickBuyBtn:^{
        [weakSelf buy];
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECProductCycleCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductCycleCell)];
    [_collectionView registerClass:[ECPointProductDetailInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointProductDetailInfoCell)];
    [_collectionView registerClass:[ECPointProductDetailWebCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointProductDetailWebCell)];

}

#pragma mark - Actions

- (void)loadDataSource {
    [ECHTTPServer requestPointProductDetailWithProId:_listModel.proId
                                             succeed:^(NSURLSessionDataTask *task, id result) {
                                                 if (IS_REQUEST_SUCCEED(result)) {
                                                     ECLog(@"%@",result);
                                                     //轮播图数据解析
                                                     [_cycleImageList removeAllObjects];
                                                     [result[@"integraData"][@"imgJSON"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                                                         NSString *str = IMAGEURL(dic[@"img_url"]);
                                                         [_cycleImageList addObject:str];
                                                     }];
                                                     //商品信息解析
                                                     _infoModel = [ECPointProductDetailInfoModel yy_modelWithDictionary:[result[@"integraData"][@"integraJSON"] objectAtIndexWithCheck:0]];
                                                     [_collectionView reloadData];
                                                 } else {
                                                     EC_SHOW_REQUEST_ERROR_INFO
                                                 }
                                             }
                                              failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                 RequestFailure
                                              }];
}

- (void)buy {
    if (!EC_USER_WHETHERLOGIN) {
        [APP_DELEGATE callLoginWithViewConcontroller:self
                                          jumpToMian:NO
                               clearCurrentLoginInfo:YES
                                             succeed:^{
                                                 
                                             }];
        return;
    }
    if (_infoModel.stock.integerValue < 1) {
        [SVProgressHUD showInfoWithStatus:@"库存不足"];
        return;
    }
    SHOWSVP
    [ECHTTPServer requestPointInfoWithUserId:[Keychain objectForKey:EC_USER_ID]
                                     succeed:^(NSURLSessionDataTask *task, id result) {
                                         if (IS_REQUEST_SUCCEED(result)) {
                                             ECPointInfoModel *model = [ECPointInfoModel yy_modelWithDictionary:result[@"info"]];
                                             if (model.point.floatValue < _infoModel.point.floatValue) {
                                                 [SVProgressHUD showInfoWithStatus:@"可用积分不足"];
                                             } else {
                                                 DISMISSSVP
                                                 ECPointConfirmOrderViewController *vc = [[ECPointConfirmOrderViewController alloc] initWithModel:_listModel];
                                                 [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"确认订单"];
                                             }
                                         } else {
                                             EC_SHOW_REQUEST_ERROR_INFO
                                         }
                                     }
                                      failed:^(NSURLSessionDataTask *task, NSError *error) {
                                         RequestFailure
                                      }];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return CGSizeMake(SCREENWIDTH, SCREENWIDTH);

        case 1:
            return CGSizeMake(SCREENWIDTH, 90.f);
        case 2:
            return _webCellHeight == 0.f ? CGSizeMake(SCREENWIDTH, 200.f) : CGSizeMake(SCREENWIDTH, _webCellHeight);
        default:
            return CGSizeZero;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    switch (indexPath.row) {
        case 0:
        {
            ECProductCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductCycleCell)
                                                                                 forIndexPath:indexPath];
            cell.moreBtn.hidden = YES;
            cell.imageUrlArr = _cycleImageList;
            return cell;
        }
        case 1:
        {
            ECPointProductDetailInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointProductDetailInfoCell)
                                                                                           forIndexPath:indexPath];
            if (_infoModel) {
                cell.model = _infoModel;
            }
            return cell;
        }
        case 2:
        {
            ECPointProductDetailWebCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPointProductDetailWebCell)
                                                                                          forIndexPath:indexPath];
            [cell setDidLoadWenHeight:^(CGFloat height) {
                weakSelf.webCellHeight = height;
                [weakSelf.collectionView reloadData];
            }];
            if (_infoModel) {
                cell.content = _infoModel.detail;
            }
            return cell;
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
