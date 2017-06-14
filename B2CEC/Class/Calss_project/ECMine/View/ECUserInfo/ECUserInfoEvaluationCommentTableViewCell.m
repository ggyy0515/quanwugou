//
//  ECUserInfoEvaluationCommentTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEvaluationCommentTableViewCell.h"

#import "ECUserInfoEvaluationCommentImageCollectionViewCell.h"

#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ECUserInfoEvaluationCommentTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (nonatomic, strong) HCSStarRatingView *ratingView;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UILabel *commentLab;

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UIView *lineView2;

@end

@implementation ECUserInfoEvaluationCommentTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoEvaluationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationCommentTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoEvaluationCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationCommentTableViewCell)];
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
    if (!_topView) {
        _topView = [UIView new];
    }
    
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    _iconImageView.image = [UIImage imageNamed:@"face1"];
    _iconImageView.layer.cornerRadius = 16.f;
    _iconImageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.text = @"我是昵称";
    _nameLab.textColor = LightColor;
    _nameLab.font = FONT_32;
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 5;
    _ratingView.accurateHalfStars = YES;
    _ratingView.allowsHalfStars = YES;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    _ratingView.userInteractionEnabled = NO;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_commentLab) {
        _commentLab = [UILabel new];
    }
    _commentLab.numberOfLines = 0.f;
    _commentLab.textColor = DarkMoreColor;
    _commentLab.font = FONT_32;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 8.f;
        layout.minimumLineSpacing = 8.f;
        layout.itemSize = CGSizeMake(80.f, 80.f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[ECUserInfoEvaluationCommentImageCollectionViewCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationCommentImageCollectionViewCell)];
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.textColor = LightColor;
    _dateLab.font = FONT_22;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_topView];
    [_topView addSubview:_iconImageView];
    [_topView addSubview:_nameLab];
    [_topView addSubview:_ratingView];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_commentLab];
    [self.contentView addSubview:_collectionView];
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_lineView2];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.topView.mas_centerY);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(8.f);
        make.centerY.mas_equalTo(weakSelf.topView.mas_centerY);
    }];
    
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12.f);
        make.centerY.mas_equalTo(weakSelf.topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(weakSelf.topView.mas_bottom);
    }];
    
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.lineView1);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom).offset(16.f);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.commentLab);
        make.top.mas_equalTo(weakSelf.commentLab.mas_bottom).offset(12.f);
        make.height.mas_equalTo(80.f);
    }];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.bottom.mas_equalTo(-16.f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineView1);
        make.bottom.mas_equalTo(0.f);
    }];
}

- (void)setModel:(ECUserInfoCommentModel *)model{
    _model = model;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.title_img)] placeholder:[UIImage imageNamed:@"face1"]];
    _nameLab.text = model.name;
    _ratingView.value = model.star_level.integerValue;
    _commentLab.text = model.comment;
    _dateLab.text = model.createdate;
    _collectionView.hidden = model.imgurls == 0;
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.imgurls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECUserInfoEvaluationCommentImageCollectionViewCell *cell = [ECUserInfoEvaluationCommentImageCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.imageUrl = self.model.imgurls[indexPath.row];
    return cell;
}

@end
