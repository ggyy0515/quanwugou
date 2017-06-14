//
//  ECMallAllView.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallAllView.h"
#import "ECMallCycleCell.h"
#import "ECMallHouseCell.h"
#import "ECMallPanicBuyCell.h"
#import "ECMallCatCell.h"
#import "ECMallTagModel.h"
#import "ECMallViewController.h"
#import "ECMallFloorModel.h"
#import "ECMallPanicBuyViewController.h"

@interface ECMallAllView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
/**
 轮播图数据源
 */
@property (nonatomic, strong) NSMutableArray *cycleDataSource;
/**
 馆的数据源
 */
@property (nonatomic, strong) NSMutableArray *houseDataSouce;
/**
 抢购数据源
 */
@property (nonatomic, strong) NSMutableArray *panicBuyDataSource;
/**
 楼层数据源(cell是cat的)
 */
@property (nonatomic, strong) NSMutableArray *floorDataSource;

@end

@implementation ECMallAllView

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        [self createUI];
//        _cycleDataSource = [NSMutableArray array];
//        _houseDataSouce = [NSMutableArray array];
//        _panicBuyDataSource = [NSMutableArray array];
//        _floorDataSource = [NSMutableArray array];
        [_collectionView.mj_header beginRefreshing];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECMallCycleCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCycleCell)];
    [_collectionView registerClass:[ECMallHouseCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallHouseCell)];
    [_collectionView registerClass:[ECMallPanicBuyCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuyCell)];
    [_collectionView registerClass:[ECMallCatCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCatCell)];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataSource];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    }];
    [_collectionView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - Setter

- (void)setCycleDataSource:(NSMutableArray *)cycleDataSource
            houseDataSouce:(NSMutableArray *)houseDataSouce
        PanicBuyDataSource:(NSMutableArray *)panicBuyDataSource
           floorDataSource:(NSMutableArray *)floorDataSource {
    _cycleDataSource = cycleDataSource;
    _houseDataSouce = houseDataSouce;
    _panicBuyDataSource = panicBuyDataSource;
    _floorDataSource = floorDataSource;
    [_collectionView reloadData];
}


#pragma mark - Actions

- (void)loadDataSource {
    [(ECMallViewController *)self.viewController loadDataSource];
}

- (void)endRefresh {
    [_collectionView.mj_header endRefreshing];
}

#pragma mark - UICollection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        //分类商品
        return _floorDataSource.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //轮播图
            ECMallCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCycleCell)
                                                                              forIndexPath:indexPath];
            if (_cycleDataSource) {
                cell.cycleViewDataSource = _cycleDataSource;
            }
            return cell;
        }
        case 1:
        {
            //五个馆
            ECMallHouseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallHouseCell)
                                                                              forIndexPath:indexPath];
            if (_houseDataSouce) {
                cell.dataSource = _houseDataSouce;
            }
            return cell;
        }
        case 2:
        {
            //抢购
            ECMallPanicBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuyCell)
                                                                                 forIndexPath:indexPath];
            if (_panicBuyDataSource) {
                cell.dataSource = _panicBuyDataSource;
            }
            return cell;
        }
        case 3:
        {
            //楼层
            ECMallCatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCatCell)
                                                                            forIndexPath:indexPath];
            ECMallFloorModel *model = [_floorDataSource objectAtIndexWithCheck:indexPath.row];
            cell.model = model;
            return cell;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //轮播图
            if (_cycleDataSource.count > 0) {
                return CGSizeMake(SCREENWIDTH, SCREENWIDTH * (360.f / 750.f));
            }
            return CGSizeZero;
        }
        case 1:
        {
            //五个馆
            if (_houseDataSouce.count > 0) {
                return CGSizeMake(SCREENWIDTH, (SCREENWIDTH - 60.f) / 5.f + 28.f);
            }
            return CGSizeZero;
        }
        case 2:
        {
            //抢购
            if (_panicBuyDataSource.count > 0) {
                return CGSizeMake(SCREENWIDTH, 195.f);
            }
            return CGSizeZero;
        }
        case 3:
        {
            //楼层
            return CGSizeMake(SCREENWIDTH, (((SCREENWIDTH - 32.f) / 3.f + 30.f + 12.f +16.f) * 2 + 10.f) + SCREENWIDTH * (300.f / 750.f) + 38.f + 10);
        }
        
            
        default:
            return CGSizeZero;
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //间隔随前一个cell
    switch (section) {
        case 0:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
            
        default:
            return UIEdgeInsetsMake(0, 0, 8, 0);
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return 8;
    }
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2:
        {
            //点击抢购
            ECMallPanicBuyViewController *vc = [[ECMallPanicBuyViewController alloc] init];
            [((CMBaseNavigationController *)self.viewController.navigationController) pushViewController:vc
                                                                                                animated:YES
                                                                                              titleLabel:@"限时抢购"];
        }
            break;
        case 3:
        {
            //点击楼层
            ECMallFloorModel *model = [_floorDataSource objectAtIndexWithCheck:indexPath.row];
            if (_didClickFloor) {
                _didClickFloor(model.attrCode, model.attrValue, model.code);
            }
        }
            break;
            
        default:
            break;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
