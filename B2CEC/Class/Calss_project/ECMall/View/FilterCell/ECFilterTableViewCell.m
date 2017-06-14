//
//  ECFilterTableViewCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECFilterTableViewCell.h"
#import "ECFilterCollectionViewCell.h"
#import "ECMallHouseModel.h"
#import "ECMallTagModel.h"

@interface ECFilterTableViewCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UICollectionView *contentCollectionView;
@property (nonatomic, assign) ConditionCellType cellType;

@end

@implementation ECFilterTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView conditionType:(ConditionCellType)type {
    ECFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterTableViewCell)];
    if (cell == nil) {
        cell = [[ECFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterTableViewCell)];
        cell.cellType = type;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 10.f;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentCollectionView];
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-16.f);
    }];
    
    [_contentCollectionView registerClass:[ECFilterCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterCollectionViewCell)];
}

- (void)setHouseDataSource:(NSArray *)houseDataSource {
    _houseDataSource = houseDataSource;
    [_contentCollectionView reloadData];
}

- (void)setSecondTypeDataSource:(NSArray *)secondTypeDataSource {
    _secondTypeDataSource = secondTypeDataSource;
    [_contentCollectionView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_contentCollectionView reloadData];
}


- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [_contentCollectionView reloadData];
}

#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (_cellType) {
        case ConditionCellType_house:
            return _houseDataSource.count;
        case ConditionCellType_secondType:
            return _secondTypeDataSource.count;
        default:
            return _dataArray.count;
            break;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECFilterCollectionViewCell *cell = [ECFilterCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.titleLab.backgroundColor = _currentIndex == indexPath.row ? MainColor : UIColorFromHexString(@"#ececec");
    cell.titleLab.textColor = _currentIndex == indexPath.row ? [UIColor whiteColor] : DarkColor;
    [cell.titleLab setAdjustsFontSizeToFitWidth:YES];
    if (_cellType == ConditionCellType_house) {
        cell.titleLab.cornerRadius = (CGRectGetWidth(self.frame) - 46.f)/5.5f/2.f;
    } else {
        cell.titleLab.cornerRadius = 4.f;
    }
    switch (_cellType) {
        case ConditionCellType_house:
        {
            ECMallHouseModel *model = [_houseDataSource objectAtIndexWithCheck:indexPath.row];
            cell.title = model.name;
        }
            break;
        case ConditionCellType_secondType:
        {
            ECMallTagModel *model = [_secondTypeDataSource objectAtIndexWithCheck:indexPath.row];
            cell.title = model.name;
        }
            break;
        default:
        {
            cell.title = _dataArray[indexPath.row][@"NAME"];
        }
            break;
    }
    return cell;
}
#pragma mark  UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellType == ConditionCellType_house) {
        return CGSizeMake((CGRectGetWidth(self.frame) - 46.f)/5.5f, (CGRectGetWidth(self.frame) - 46.f)/5.5f);
    } else {
        return CGSizeMake((CGRectGetWidth(self.frame) - 46.f)/3.f, 30.f);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentIndex = indexPath.row;
    if (self.currentClick) {
        self.currentClick(indexPath.row, _cellType);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (_cellType == ConditionCellType_house) {
        return 5.f;
    } else {
        return 10.f;
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
