//
//  ECCommentOrderCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import <HCSStarRatingView/HCSStarRatingView.h>

#import "ECCommentOrderCell.h"
#import "ECOrderProductModel.h"
#import "ECCommentOrderPicCell.h"

@interface ECCommentOrderCell ()
<
    UITextViewDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SHTextView *textView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *lengthLabel;

@end

@implementation ECCommentOrderCell

#pragma mark - UICollection Method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
        make.top.mas_equalTo(weakSelf.imageView.mas_top).offset(8.f);
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
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.imageView.mas_right).offset(12.f);
        make.bottom.mas_equalTo(weakSelf.imageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];
    [_ratingView addTarget:self action:@selector(starLevelChange:) forControlEvents:UIControlEventValueChanged];
    
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
    
    if (!_textView) {
        _textView = [[SHTextView alloc] initWithFrame:CGRectZero textChangeBlock:^(UITextView *textView) {
            
        }];
    }
    [self.contentView addSubview:_textView];
    _textView.placeholder = @"写下你的评价，让更多的人看到！";
    _textView.font = FONT_32;
    _textView.placeholderColor = UIColorFromHexString(@"#cccccc");
    _textView.textColor = DarkColor;
    _textView.delegate = self;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8.f);
        make.right.mas_equalTo(-8.f);
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(20.f);
        make.height.mas_equalTo(150.f);
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
        make.top.mas_equalTo(weakSelf.textView.mas_bottom).offset(20.f);
        make.height.mas_equalTo((SCREENWIDTH - 12.f * 6) / 5.f);
    }];
    [_collectionView registerClass:[ECCommentOrderPicCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderPicCell)];
    
    if (!_lengthLabel) {
        _lengthLabel = [UILabel new];
    }
    [self.contentView addSubview:_lengthLabel];
    _lengthLabel.textAlignment = NSTextAlignmentRight;
    _lengthLabel.font = FONT_24;
    _lengthLabel.textColor = UIColorFromHexString(@"#cccccc");
    _lengthLabel.text = @"0/500";
    [_lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-16.f);
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).offset(9.f);
        make.height.mas_equalTo(weakSelf.lengthLabel.font.lineHeight);
    }];
}

#pragma mark - Actions

- (void)starLevelChange:(HCSStarRatingView *)ratingView {
    if (_starLevelChanged) {
        NSString *starLevel = [NSString stringWithFormat:@"%.1lf", ratingView.value];
        _starLevelChanged(starLevel, self.indexPath);
    }
}


#pragma mark - Setter

- (void)setModel:(ECOrderProductModel *)model {
    _model = model;
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
    _nameLabel.text = model.name;
    
}

- (void)setStarLevel:(NSString *)starLevel {
    _ratingView.value = starLevel.floatValue;
}

- (void)setComment:(NSString *)comment {
    _textView.text = comment;
    _lengthLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)comment.length];
}

- (void)setImageList:(NSMutableArray *)imageList {
    _imageList = imageList;
    [_collectionView reloadData];
}

#pragma mark - UITextView Method

- (void)textViewDidChange:(UITextView *)textView{
    NSString *comment = textView.text;
    if (textView.text.length > 500) {
        comment = textView.text = [textView.text substringToIndex:500];
    }
    _lengthLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)textView.text.length];
    if (_commentChanged) {
        _commentChanged(comment, self.indexPath);
    }
}

#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_imageList.count == 5) {
        return 5;
    }
    return _imageList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    ECCommentOrderPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECCommentOrderPicCell)
                                                                            forIndexPath:indexPath];
    if (indexPath.row == _imageList.count) {
        cell.image = nil;
    } else {
        UIImage *image = [_imageList objectAtIndexWithCheck:indexPath.row];
        cell.image = image;
    }
    
    [cell setClickDeleteBtn:^(NSIndexPath *cellIndexPath) {
        [weakSelf.imageList removeObjectAtIndex:cellIndexPath.row];
        [weakSelf.lastSelectArray removeObjectAtIndex:cellIndexPath.row];
        [weakSelf.collectionView reloadData];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _imageList.count && _addImageAction) {
        _addImageAction(self.indexPath);
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
