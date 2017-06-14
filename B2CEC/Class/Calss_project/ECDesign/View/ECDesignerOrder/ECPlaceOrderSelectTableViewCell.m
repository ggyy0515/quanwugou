//
//  ECPlaceOrderSelectTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPlaceOrderSelectTableViewCell.h"
#import "ECPlaceOrderSelectCollectionViewCell.h"

@interface ECPlaceOrderSelectTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UILabel *typelab;

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation ECPlaceOrderSelectTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECPlaceOrderSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderSelectTableViewCell)];
    if (cell == nil) {
        cell = [[ECPlaceOrderSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderSelectTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    if (!_typelab) {
        _typelab = [UILabel new];
    }
    _typelab.font = FONT_32;
    _typelab.textColor = LightMoreColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = (SCREENWIDTH - 24.f - 76.f * floorf((SCREENWIDTH - 24.f) / 76.f)) / (floorf((SCREENWIDTH - 24.f) / 76.f) - 1);
        layout.minimumLineSpacing = 12.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerClass:[ECPlaceOrderSelectCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderSelectCollectionViewCell)];
    
    [self.contentView addSubview:_typelab];
    [self.contentView addSubview:_collectionView];
    
    [_typelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(0.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.typelab);
        make.top.mas_equalTo(weakSelf.typelab.mas_bottom).offset(12.f);
        make.bottom.mas_equalTo(-12.f);
    }];
}

- (void)setType:(NSString *)type{
    _type = type;
    _typelab.text = type;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
}

- (void)setNameArray:(NSArray *)nameArray{
    _nameArray = nameArray;
    [self.collectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPlaceOrderSelectCollectionViewCell *cell = [ECPlaceOrderSelectCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.name = _nameArray[indexPath.row];
    cell.isCurrent = indexPath.row == _currentIndex;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(76.f, 25.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    [self.collectionView reloadData];
    if (self.currentModelBlock) {
        self.currentModelBlock(self.nameArray[indexPath.row],self.dataArray[indexPath.row]);
    }
}

@end
