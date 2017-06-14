//
//  ECOrderCommentTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/18.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ECOrderCommentTableViewCell.h"
#import "ECCommentOrderPicCell.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ECOrderCommentTableViewCell()
<
UITextViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ECOrderCommentTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECOrderCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderCommentTableViewCell)];
    if (cell == nil) {
        cell = [[ECOrderCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECOrderCommentTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = BaseColor;
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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    [self.contentView addSubview:_iconImageView];
    [_iconImageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_top).offset(36.f);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = LightMoreColor;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_top).offset(8.f);
    }];
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    [self.contentView addSubview:_ratingView];
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 5;
    _ratingView.accurateHalfStars = YES;
    _ratingView.allowsHalfStars = YES;
    _ratingView.userInteractionEnabled = NO;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
        make.bottom.mas_equalTo(weakSelf.iconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(144.f / 2.f);
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(1.f);
    }];
    
    if (!_contentLab) {
        _contentLab = [UILabel new];
    }
    [self.contentView addSubview:_contentLab];
    _contentLab.font = FONT_32;
    _contentLab.textColor = DarkColor;
    _contentLab.numberOfLines = 0;
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.f);
        make.right.mas_equalTo(-8.f);
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(20.f);
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        layout.minimumInteritemSpacing = 12.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 12.f * 6) / 5.f, (SCREENWIDTH - 12.f * 6) / 5.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.contentView addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.top.mas_equalTo(weakSelf.contentLab.mas_bottom).offset(20.f);
        make.height.mas_equalTo((SCREENWIDTH - 12.f * 6) / 5.f);
    }];
    [_collectionView registerClass:[ECCommentOrderPicCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderPicCell)];
}

- (void)setModel:(ECOrderCommentModel *)model{
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.imageTitle)]
                           placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    _nameLabel.text = model.proName;
    _ratingView.value = model.star_level.integerValue;
    _contentLab.text = model.comment;
    if (model.imgurls.count == 0) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.imgurls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECCommentOrderPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderPicCell)
                                                                            forIndexPath:indexPath];
    cell.imageUrl = [_model.imgurls objectAtIndexWithCheck:indexPath.row];
    cell.showDelete = NO;
    return cell;
}

@end
