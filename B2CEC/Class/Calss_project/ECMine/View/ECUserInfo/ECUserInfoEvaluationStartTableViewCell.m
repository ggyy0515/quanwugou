//
//  ECUserInfoEvaluationStartTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/19.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEvaluationStartTableViewCell.h"

#import <HCSStarRatingView/HCSStarRatingView.h>

@interface ECUserInfoEvaluationStartTableViewCell()

@property (nonatomic, strong) UILabel *tipsLab;

@property (nonatomic, strong) HCSStarRatingView *ratingView;

@end

@implementation ECUserInfoEvaluationStartTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECUserInfoEvaluationStartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationStartTableViewCell)];
    if (cell == nil) {
        cell = [[ECUserInfoEvaluationStartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECUserInfoEvaluationStartTableViewCell)];
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
    if (!_tipsLab) {
        _tipsLab = [UILabel new];
    }
    _tipsLab.text = @"设计师满意度";
    _tipsLab.textColor = DarkMoreColor;
    _tipsLab.font = FONT_32;
    
    if (!_ratingView) {
        _ratingView = [HCSStarRatingView new];
    }
    _ratingView.backgroundColor = BaseColor;
    _ratingView.minimumValue = 0;
    _ratingView.maximumValue = 5;
    _ratingView.value = 5;
    _ratingView.accurateHalfStars = YES;
    _ratingView.allowsHalfStars = YES;
    _ratingView.filledStarImage = [UIImage imageNamed:@"rate_star_on"];
    _ratingView.emptyStarImage = [UIImage imageNamed:@"rate_star_off"];
    _ratingView.userInteractionEnabled = NO;

    [self.contentView addSubview:_tipsLab];
    [self.contentView addSubview:_ratingView];
    
    [_tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.right.mas_equalTo(weakSelf.contentView.mas_centerX).offset(-6.f);
    }];
    
    [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_centerX).offset(6.f);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(170.f / 2.f, 30.f));
    }];
}

- (void)setScore:(NSString *)score{
    _score = score;
    _ratingView.value = score.integerValue;
}

@end
