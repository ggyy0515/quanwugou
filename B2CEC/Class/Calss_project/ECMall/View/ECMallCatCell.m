//
//  ECMallCatCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallCatCell.h"
#import "ECMallCatSubCell.h"
#import "ECMallFloorModel.h"
#import "ECMallFloorProductModel.h"
#import "ECMallProductDetailViewController.h"

@interface ECMallCatCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    CLLocationManagerDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation ECMallCatCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = FONT_B_36;
    _titleLabel.textColor = DarkColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10.f);
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(18.f);
    }];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_1"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(SCREENWIDTH * (300.f / 750.f));
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 32.f) / 3.f, (SCREENWIDTH - 32.f) / 3.f + 30.f + 12.f +16.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.contentView addSubview:_collectionView];
    _collectionView.scrollEnabled = NO;
    _collectionView.scrollsToTop = NO;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(10.f);
        make.height.mas_equalTo(((SCREENWIDTH - 32.f) / 3.f + 30.f + 12.f +16.f) * 2 + 10.f);
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECMallCatSubCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCatSubCell)];
    
}

#pragma mark - Setter

- (void)setModel:(ECMallFloorModel *)model {
    _model = model;
    _titleLabel.text = model.floorName;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_1"]];
    [_collectionView reloadData];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_model) {
        return _model.productList.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallCatSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallCatSubCell)
                                                                       forIndexPath:indexPath];
    ECMallFloorProductModel *model = [_model.productList objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallFloorProductModel *model = [_model.productList objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.protable = model.proTable;
    vc.proId = model.proId;
    [SELF_VC_BASEVAV pushViewController:vc animated:YES titleLabel:@""];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
