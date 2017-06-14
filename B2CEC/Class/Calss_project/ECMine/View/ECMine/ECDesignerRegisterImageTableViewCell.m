//
//  ECDesignerRegisterImageTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/30.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterImageTableViewCell.h"

@interface ECDesignerRegisterImageTableViewCell()

@property (strong,nonatomic) UIImageView *iconImageView;

@property (strong,nonatomic) UIButton *deleteBtn;

@end

@implementation ECDesignerRegisterImageTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegisterImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterImageTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegisterImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterImageTableViewCell)];
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
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
    }
    [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.deleteImageBlock) {
            weakSelf.deleteImageBlock(weakSelf.indexpath.row);
        }
    }];
    
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_deleteBtn];
    
    [_iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
        make.bottom.right.mas_equalTo(-12.f);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
        make.right.mas_equalTo(weakSelf.iconImageView.mas_right).offset(5.f);
        make.top.mas_equalTo(weakSelf.iconImageView.mas_top).offset(-5.f);
    }];
}

- (void)setIndexpath:(NSIndexPath *)indexpath{
    _indexpath = indexpath;
}

- (void)setIsFlag:(BOOL)isFlag{
    _isFlag = isFlag;
}

- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    _iconImageView.image = iconImage;
    [self updateSize:iconImage];
}

- (void)setIconImageUrl:(NSString *)iconImageUrl{
    _iconImageUrl = iconImageUrl;
    WEAK_SELF

    [_iconImageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(iconImageUrl)]
                           placeholder:[UIImage imageNamed:@"placeholder_News2"]
                               options:YYWebImageOptionAllowInvalidSSLCertificates
                            completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        [weakSelf updateSize:image];
    }];
}

- (void)updateSize:(UIImage *)image{
    if (_isFlag) {
        return;
    }
    
    CGSize size = image.size;
    
    CGFloat height = size.height;
    if (size.width > (SCREENWIDTH - 24.f)) {
        height = ((SCREENWIDTH - 24.f) / size.width ) * size.height;
    }
    if (_getImageSizeBlock) {
        _getImageSizeBlock(self.indexpath.row,height);
    }
}

@end
