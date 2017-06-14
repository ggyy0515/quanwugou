//
//  ECCommentOrderPicCell.m
//  B2CEC
//
//  Created by Tristan on 2016/12/14.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECCommentOrderPicCell.h"

@interface ECCommentOrderPicCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ECCommentOrderPicCell

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
    [_imageView setImage:[UIImage imageNamed:@"evaluate_add"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
    }
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn setImage:[UIImage imageNamed:@"evaluate_delete"] forState:UIControlStateNormal];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
    _deleteBtn.hidden = YES;
    [_deleteBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickDeleteBtn) {
            weakSelf.clickDeleteBtn(weakSelf.indexPath);
        }
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (_image) {
        [_imageView setImage:image];
        _deleteBtn.hidden = NO;
    } else {
        [_imageView setImage:[UIImage imageNamed:@"evaluate_add"]];
        _deleteBtn.hidden = YES;
    }
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(imageUrl)] placeholder:[UIImage imageNamed:@"placeholder_goods1"]];
}

- (void)setShowDelete:(BOOL)showDelete{
    _showDelete = showDelete;
    _deleteBtn.hidden = !showDelete;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
