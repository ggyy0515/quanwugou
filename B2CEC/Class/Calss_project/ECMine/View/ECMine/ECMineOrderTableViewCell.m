//
//  ECMineOrderTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMineOrderTableViewCell.h"
#import "ECMineOrderCollectionViewCell.h"

@interface ECMineOrderTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@property (strong,nonatomic) NSArray *nameArray;

@end

@implementation ECMineOrderTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECMineOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineOrderTableViewCell)];
    if (cell == nil) {
        cell = [[ECMineOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineOrderTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameArray = @[@[@"daifukuan",@"待付款"],
                       @[@"daifahuo",@"待发货"],
                       @[@"daishouhuo",@"待收货"],
                       @[@"daipingjia",@"待评价"],
                       @[@"tuihuanhuo",@"退换货"]];
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.scrollEnabled = NO;
    _contentCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:_contentCollectionView];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_contentCollectionView registerClass:[ECMineOrderCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECMineOrderCollectionViewCell)];
}

- (void)setModel:(ECMineModel *)model{
    _model = model;
    [self.contentCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECMineOrderCollectionViewCell *cell = [ECMineOrderCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.iconImage = self.nameArray[indexPath.row][0];
    cell.title = self.nameArray[indexPath.row][1];
    switch (indexPath.row) {
        case 0:{
            cell.count = self.model.WAITPAY;
        }
            break;
        case 1:{
            cell.count = self.model.WAITSENDGOODS;
        }
            break;
        case 2:{
            cell.count = self.model.WAITGETGOODS;
        }
            break;
        case 3:{
            cell.count = self.model.WAITCOMMENT;
        }
            break;
        case 4:{
            cell.count = self.model.RETURNOREXCHANGE;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH - 24.f) / 5.f, 93.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.orderTypeBlock) {
        self.orderTypeBlock(indexPath.row);
    }
}

@end
