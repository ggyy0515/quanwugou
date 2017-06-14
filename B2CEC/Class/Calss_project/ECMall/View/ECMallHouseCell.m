//
//  ECMallHouseCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallHouseCell.h"
#import "ECMallHouseSubCell.h"
#import "ECMallHouseModel.h"
#import "ECMallHouseViewController.h"

@interface ECMallHouseCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ECMallHouseCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREENWIDTH - 60.f) / 5.f, (SCREENWIDTH - 60.f) / 5.f);
        layout.sectionInset = UIEdgeInsetsMake(14.f, 10.f, 14.f, 10.f);
        layout.minimumInteritemSpacing = 10.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECMallHouseSubCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallHouseSubCell)];
}

#pragma mark - Setter

- (void)setDataSource:(NSArray<ECMallHouseModel *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}


#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   ECMallHouseSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallHouseSubCell)
                                                                        forIndexPath:indexPath];
    ECMallHouseModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallHouseModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECMallHouseViewController *houseVC = [[ECMallHouseViewController alloc] init];
    houseVC.houseCode = model.code;
    if ([model.code isEqualToString:@"PRODUCT_HALL_TEJIAGUAN"]) {
        houseVC.isBarginPriceHouse = YES;
    } else {
        houseVC.isBarginPriceHouse = NO;
    }
    [((CMBaseNavigationController *)self.viewController.navigationController) pushViewController:houseVC
                                                                                        animated:YES
                                                                                      titleLabel:model.name];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
