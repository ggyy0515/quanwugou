//
//  ECDesignerOrderCommentTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderCommentTableViewCell.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ECDesignerOrderCommentTableViewCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) HCSStarRatingView *ratingView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) SHTextView *textView;
@property (nonatomic, strong) SHImageListView *imageListView;
@property (nonatomic, strong) UILabel *lengthLabel;

@end

@implementation ECDesignerOrderCommentTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderCommentTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderCommentTableViewCell)];
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
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    
    [_iconImageView setImage:[UIImage imageNamed:@"placeholder_goods1"]];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = LightMoreColor;
    _nameLabel.text = @"我是昵称";
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 5;
    _ratingView.accurateHalfStars = NO;
    _ratingView.allowsHalfStars = NO;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    [_ratingView addTarget:self action:@selector(starLevelChange:) forControlEvents:UIControlEventValueChanged];
    
    if (!_line) {
        _line = [UIView new];
    }
    _line.backgroundColor = BaseColor;
    
    if (!_textView) {
        _textView = [[SHTextView alloc] initWithFrame:CGRectZero textChangeBlock:^(UITextView *textView) {
            if (textView.text.length > 500) {
                textView.text = [textView.text substringToIndex:500];
            }
            _lengthLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)textView.text.length];
            if (weakSelf.commentChanged) {
                weakSelf.commentChanged(textView.text);
            }
        }];
    }
    _textView.placeholder = @"写下你的评价，让更多的人看到！";
    _textView.font = FONT_32;
    _textView.placeholderColor = UIColorFromHexString(@"#cccccc");
    _textView.textColor = DarkColor;
    
    if (!_imageListView) {
        _imageListView = [[SHImageListView alloc] initWithFrame:CGRectZero];
    }
    _imageListView.isAdd = YES;
    _imageListView.itemSize = CGSizeMake(60.f, 60.f);
    [_imageListView setImageClickBlock:^(NSInteger index) {
        if (weakSelf.imageClickBlock) {
            weakSelf.imageClickBlock(index);
        }
    }];
    [_imageListView setAddImageClickBlock:^{
        if (weakSelf.addImageClickBlock) {
            weakSelf.addImageClickBlock();
        }
    }];
    
    if (!_lengthLabel) {
        _lengthLabel = [UILabel new];
    }
    _lengthLabel.textAlignment = NSTextAlignmentRight;
    _lengthLabel.font = FONT_24;
    _lengthLabel.textColor = UIColorFromHexString(@"#cccccc");
    _lengthLabel.text = @"0/500";
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_ratingView];
    [self.contentView addSubview:_line];
    [self.contentView addSubview:_textView];
    [self.contentView addSubview:_imageListView];
    [self.contentView addSubview:_lengthLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_top).offset(36.f);
        make.left.mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(55.f, 55.f));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_top).offset(8.f);
    }];
    
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(12.f);
        make.bottom.mas_equalTo(weakSelf.iconImageView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];

    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(72.f);
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.line.mas_bottom).offset(20.f);
        make.height.mas_equalTo(150.f);
    }];

    [_imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.textView);
        make.top.mas_equalTo(weakSelf.textView.mas_bottom).offset(20.f);
        make.bottom.mas_equalTo(weakSelf.lengthLabel.mas_top).offset(-9.f);
    }];
    
    [_lengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-16.f);
        make.bottom.mas_equalTo(-8.f);
        make.height.mas_equalTo(15.f);
    }];
}

- (void)setIconImage:(NSString *)iconImage{
    _iconImage = iconImage;
    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(iconImage)] placeholder:[UIImage imageNamed:@"face1"]];
}

- (void)setName:(NSString *)name{
    _name = name;
    _nameLabel.text = name;
}

- (void)starLevelChange:(HCSStarRatingView *)ratingView {
    if (_starLevelChanged) {
        NSString *starLevel = [NSString stringWithFormat:@"%.1lf", ratingView.value];
        _starLevelChanged(starLevel);
    }
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    _imageListView.imageArray = imageArray;
}

@end
