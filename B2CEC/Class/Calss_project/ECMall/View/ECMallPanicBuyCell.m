//
//  ECMallPanicBuyCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/11.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallPanicBuyCell.h"
#import "ECMallPanicBuySubCell.h"
#import "ECMallPanicBuyProductModel.h"
#import "ECMallProductDetailViewController.h"

@interface ECMallPanicBuyCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ECMallPanicBuyCell

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
    
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
    }
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView setImage:[UIImage imageNamed:@"icon_more"]];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10.f);
        make.right.mas_equalTo(weakSelf.contentView).offset(-10.f);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    
    if (!_moreLabel) {
        _moreLabel = [UILabel new];
    }
    [self.contentView addSubview:_moreLabel];
    _moreLabel.textAlignment = NSTextAlignmentRight;
    _moreLabel.textColor = LightColor;
    _moreLabel.text = @"更多";
    _moreLabel.font = [UIFont systemFontOfSize:14.f];
    [_moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.arrowImageView.mas_centerY);
        make.right.mas_equalTo(weakSelf.arrowImageView.mas_left);
        make.size.mas_equalTo(CGSizeMake(60.f, 14.f));
    }];
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(8.f);
        make.centerY.height.mas_equalTo(weakSelf.moreLabel);
        make.right.mas_equalTo(weakSelf.moreLabel.mas_left);
    }];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"限时抢购"
                                                                              attributes:@{NSFontAttributeName:FONT_B_28,
                                                                                           NSForegroundColorAttributeName:DarkColor}];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@" · "
                                                                  attributes:@{NSFontAttributeName:FONT_B_36,
                                                                               NSForegroundColorAttributeName:LightColor}]];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"特惠好货等你来"
                                                                  attributes:@{NSFontAttributeName:FONT_28,
                                                                               NSForegroundColorAttributeName:LightColor}]];
    _titleLabel.attributedText = title;
    
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 0);
        layout.minimumInteritemSpacing = 10.f;
        layout.itemSize = CGSizeMake(90.f, 120.f);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(150.f);
        make.left.right.mas_equalTo(weakSelf.contentView);
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollsToTop = NO;
    [_collectionView registerClass:[ECMallPanicBuySubCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuySubCell)];
    
}

#pragma mark - Setter

- (void)setDataSource:(NSArray<ECMallPanicBuyProductModel *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallPanicBuySubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMallPanicBuySubCell)
                                                                            forIndexPath:indexPath];
    ECMallPanicBuyProductModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(175.f / 2.f, 150.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ECMallPanicBuyProductModel *model = [_dataSource objectAtIndexWithCheck:indexPath.row];
    ECMallProductDetailViewController *vc = [[ECMallProductDetailViewController alloc] init];
    vc.proId = model.proId;
    vc.protable = model.proTable;
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
