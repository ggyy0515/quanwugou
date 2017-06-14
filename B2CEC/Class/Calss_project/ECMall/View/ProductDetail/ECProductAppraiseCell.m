//
//  ECProductAppraiseCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <HCSStarRatingView/HCSStarRatingView.h>

#import "ECProductAppraiseCell.h"
#import "ECProductAppraiseImageCell.h"
#import "ECProductAppraiseModel.h"
#import "ECProductAppraiseImageModel.h"
#import "CMImageBrowser.h"


@interface ECProductAppraiseCell ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *appraiseTimeLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *buyTimeLabel;


@end

@implementation ECProductAppraiseCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.backgroundColor = [UIColor whiteColor];
    
    if (!_headImageView) {
        _headImageView = [UIImageView new];
    }
    [self.contentView  addSubview:_headImageView];
    [_headImageView setImage:[UIImage imageNamed:@"face1"]];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
    }];
    _headImageView.layer.cornerRadius = 20.f;
    _headImageView.layer.masksToBounds = YES;
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = FONT_28;
    _nameLabel.textColor = DarkColor;
    
    if (!_appraiseTimeLabel) {
        _appraiseTimeLabel = [UILabel new];
    }
    [self.contentView addSubview:_appraiseTimeLabel];
    _appraiseTimeLabel.font = FONT_22;
    _appraiseTimeLabel.textColor = LightColor;
    _appraiseTimeLabel.textAlignment = NSTextAlignmentRight;
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.contentView addSubview:_line];
    _line.backgroundColor = BaseColor;
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    [self.contentView addSubview:_ratingView];
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 0;
    _ratingView.accurateHalfStars = YES;
    _ratingView.allowsHalfStars = YES;
    _ratingView.userInteractionEnabled = NO;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = FONT_32;
    _contentLabel.textColor = DarkMoreColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 12.f, 0, 0);
        layout.minimumInteritemSpacing = 8.f;
        layout.itemSize = CGSizeMake(80.f, 80.f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
    }
    _collectionView.scrollsToTop = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECProductAppraiseImageCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseImageCell)];
    [self.contentView addSubview:_collectionView];
    
    if (!_buyTimeLabel) {
        _buyTimeLabel = [UILabel new];
    }
    [self.contentView addSubview:_buyTimeLabel];
    _buyTimeLabel.font = FONT_22;
    _buyTimeLabel.textColor = LightColor;
    
    
}

- (void)setModel:(ECProductAppraiseModel *)model {
    WEAK_SELF
    _model = model;
    
   [ _headImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.headImage)]
                           placeholder:[UIImage imageNamed:@"face1"]];
    
    _nameLabel.text = model.name;
    CGFloat width = [CMPublicMethod getWidthWithLabel:_nameLabel];
    [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(width, _nameLabel.font.lineHeight));
        make.centerY.mas_equalTo(weakSelf.headImageView.mas_centerY);
    }];
    
    NSDateFormatter *inDateFt = [[NSDateFormatter alloc] init];
    [inDateFt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *outDateFt = [[NSDateFormatter alloc] init];
    [outDateFt setDateFormat:@"yyyy-MM-dd"];
    NSString *appraiseTime = [outDateFt stringFromDate:[inDateFt dateFromString:model.appraiseTime]];
    _appraiseTimeLabel.text = appraiseTime;
    width = [CMPublicMethod getWidthWithLabel:_appraiseTimeLabel];
    [_appraiseTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.size.mas_equalTo(CGSizeMake(width, _appraiseTimeLabel.font.lineHeight));
        make.centerY.mas_equalTo(weakSelf.nameLabel.mas_centerY);
    }];
    
    [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.contentView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(weakSelf.headImageView.mas_bottom).offset(12.f);
    }];
    
    [_ratingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(20.f);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];
    _ratingView.value = model.score.floatValue;
    
    CGFloat height = ceil([model.content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 24.f, 100000)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:_contentLabel.font}
                                                      context:nil].size.height);
    _contentLabel.text = model.content;
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.top.mas_equalTo(weakSelf.ratingView.mas_bottom).offset(12.f);
        make.height.mas_equalTo(height);
    }];
    
    if (model.imageList.count > 0) {
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom).offset(16.f);
            make.left.right.mas_equalTo(weakSelf.contentView);
            make.height.mas_equalTo(80.f);
        }];
    } else {
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentLabel.mas_bottom);
            make.left.right.mas_equalTo(weakSelf.contentView);
            make.height.mas_equalTo(0);
        }];
    }
    
    NSString *butTime = [NSString stringWithFormat:@"购买时间：%@", [outDateFt stringFromDate:[inDateFt dateFromString:model.buyTime]]];
    _buyTimeLabel.text = butTime;
    [_buyTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).offset(12.f);
        make.height.mas_equalTo(weakSelf.buyTimeLabel.font.lineHeight);
    }];
    
    [_collectionView reloadData];
    
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECProductAppraiseImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECProductAppraiseImageCell)
                                                                                 forIndexPath:indexPath];
    ECProductAppraiseImageModel *model = [_model.imageList objectAtIndexWithCheck:indexPath.row];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [NSMutableArray array];
    [_model.imageList enumerateObjectsUsingBlock:^(ECProductAppraiseImageModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:IMAGEURL(model.image)];
    }];
    [CMImageBrowser showBrowserInView:SELF_VC_BASEVAV.view backgroundColor:[UIColor blackColor] imageUrls:array fromIndex:indexPath.row];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
