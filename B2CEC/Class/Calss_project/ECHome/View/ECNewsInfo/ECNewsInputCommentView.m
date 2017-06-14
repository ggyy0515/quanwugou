//
//  ECNewsInputCommentView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsInputCommentView.h"

@interface ECNewsInputCommentView()<
UITextViewDelegate
>
//
@property (strong,nonatomic) UIView *commentInputView;

@property (strong,nonatomic) UIView *commentInputLineView;

@property (strong,nonatomic) UIView *commentTextBgView;

@property (strong,nonatomic) SHTextView *commentTextView;
//
@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UILabel *inputLab;

@property (strong,nonatomic) UIButton *inputBtn;

@property (strong,nonatomic) UIButton *commentBtn;

@property (strong,nonatomic) UILabel *commentLab;

@property (strong,nonatomic) UIButton *collecBtn;

@property (strong,nonatomic) UIButton *shareBtn;

@end

@implementation ECNewsInputCommentView{
    BOOL isAddInputView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        isAddInputView = NO;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    if (!_inputView) {
        _inputView = [UIView new];
    }
    _inputView.layer.cornerRadius = 18.f;
    _inputView.layer.masksToBounds = YES;
    
    if (!_inputLab) {
        _inputLab = [UILabel new];
    }
    _inputLab.text = @"写评论...";
    _inputLab.textColor = LightColor;
    _inputLab.font = FONT_28;
    
    if (!_inputBtn) {
        _inputBtn = [UIButton new];
    }
    [_inputBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.isInput) {//弹出输入框
            [weakSelf createCommentInputView];
            weakSelf.hidden = YES;
            weakSelf.commentInputView.hidden = NO;
            [weakSelf.commentTextView becomeFirstResponder];
        }
        if (weakSelf.inputClickBlock) {
            weakSelf.inputClickBlock();
        }
    }];
    
    if (!_commentBtn) {
        _commentBtn = [UIButton new];
    }
    [_commentBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.commentClickBlock) {
            weakSelf.commentClickBlock();
        }
    }];
    
    if (!_commentLab) {
        _commentLab = [UILabel new];
    }
    _commentLab.textColor = [UIColor whiteColor];
    _commentLab.backgroundColor = CompColor;
    _commentLab.font = [UIFont systemFontOfSize:10.f];
    _commentLab.textAlignment = NSTextAlignmentCenter;
    _commentLab.layer.cornerRadius = 7.f;
    _commentLab.layer.masksToBounds = YES;
    _commentLab.hidden = YES;
    
    if (!_collecBtn) {
        _collecBtn = [UIButton new];
    }
    [_collecBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.collecClickBlock) {
            weakSelf.collecClickBlock();
        }
    }];
    
    if (!_shareBtn) {
        _shareBtn = [UIButton new];
    }
    [_shareBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.shareClickBlock) {
            weakSelf.shareClickBlock();
        }
    }];
    
    //
    if (!_commentInputView) {
        _commentInputView = [UIView new];
    }
    _commentInputView.backgroundColor = [UIColor whiteColor];
    
    if (!_commentInputLineView) {
        _commentInputLineView = [UIView new];
    }
    _commentInputLineView.backgroundColor = LineDefaultsColor;
    
    if (!_commentTextBgView) {
        _commentTextBgView = [UIView new];
    }
    _commentTextBgView.layer.cornerRadius = 18.f;
    _commentTextBgView.layer.masksToBounds = YES;
    _commentTextBgView.backgroundColor = BaseColor;
    
    if (!_commentTextView) {
        _commentTextView = [SHTextView new];
    }
    _commentTextView.placeholder = @"写评论...";
    _commentTextView.placeholderColor = LightColor;
    _commentTextView.textColor = MainColor;
    _commentTextView.font = [UIFont systemFontOfSize:16.f];
    _commentTextView.returnKeyType = UIReturnKeySend;
    _commentTextView.scrollEnabled = NO;
    _commentTextView.delegate = self;

    [self addSubview:_lineView];
    [self addSubview:_inputView];
    [self addSubview:_inputLab];
    [self addSubview:_inputBtn];
    [self addSubview:_commentBtn];
    [self addSubview:_commentLab];
    [self addSubview:_collecBtn];
    [self addSubview:_shareBtn];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(36.f);
        make.right.mas_equalTo(weakSelf.commentBtn.mas_left).offset(-18.f);
    }];
    
    [_inputLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.inputView.mas_left).offset(18.f);
        make.right.mas_equalTo(weakSelf.inputView.mas_right).offset(-18.f);
        make.top.bottom.equalTo(weakSelf.inputView);
    }];
    
    [_inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.inputLab);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
        make.centerY.mas_equalTo(weakSelf.inputLab.mas_centerY);
        make.right.mas_equalTo(weakSelf.collecBtn.mas_left).offset(-18.f);
    }];
    
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22.f, 14.f));
        make.centerX.mas_equalTo(weakSelf.commentBtn.mas_right).offset(-3.f);
        make.centerY.mas_equalTo(weakSelf.commentBtn.mas_top).offset(3.f);
    }];
    
    [_collecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.commentBtn);
        make.right.mas_equalTo(weakSelf.shareBtn.mas_left).offset(-18.f);
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.commentBtn);
        make.right.mas_equalTo(-18.f);
    }];
}

- (void)createCommentInputView{
    if (!isAddInputView) {
        isAddInputView = YES;
        [self.superview addSubview:_commentInputView];
        [_commentInputView addSubview:_commentInputLineView];
        [_commentInputView addSubview:_commentTextBgView];
        [_commentTextBgView addSubview:_commentTextView];
        
        [_commentInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0.f);
            make.height.mas_equalTo(49.f);
            make.bottom.mas_equalTo(0.f);
        }];
        
        [_commentInputLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0.f);
            make.height.mas_equalTo(0.5f);
        }];
        
        [_commentTextBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18.f);
            make.right.mas_equalTo(-18.f);
            make.top.mas_equalTo(6.5f);
            make.bottom.mas_equalTo(-6.5f);
        }];
        
        [_commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18.f);
            make.right.mas_equalTo(-18.f);
            make.bottom.mas_equalTo(0.f);
            make.height.mas_equalTo(36.f);
        }];
        
        [self.superview layoutIfNeeded];
    }
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.commentInputView.hidden = YES;
    self.hidden = NO;
    self.inputLab.text = textView.text.length == 0 ? @"写评论..." : textView.text;
    self.inputLab.textColor = textView.text.length == 0 ? LightColor : MainColor;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    CGSize size = [textView sizeThatFits:CGSizeMake((SCREENWIDTH - 36.f), 150.f)];
    CGFloat height = fmax(36.f, size.height);
    WEAK_SELF
    [_commentInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(height + 13.f);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
    
    [_commentInputLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_commentTextBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.top.mas_equalTo(6.5f);
        make.bottom.mas_equalTo(-6.5f);
    }];
    
    [_commentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.right.mas_equalTo(-18.f);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(height);
    }];
    
    [self.superview layoutIfNeeded];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (self.sendCommentTextBlock) {
            self.sendCommentTextBlock(textView.text);
        }
        textView.text = @"";
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)setIsInput:(BOOL)isInput{
    _isInput = isInput;
}

- (void)setIsStyleBlack:(BOOL)isStyleBlack{
    _isStyleBlack = isStyleBlack;
    self.backgroundColor = isStyleBlack ? [UIColor colorWithHexString:@"000000" alpha:0.8] : [UIColor whiteColor];
    self.lineView.hidden = isStyleBlack;
    _inputView.backgroundColor = isStyleBlack ? [UIColor colorWithHexString:@"ffffff" alpha:0.1] : BaseColor;
    [_commentBtn setImage:isStyleBlack ? [UIImage imageNamed:@"icon_comment_w"] : [UIImage imageNamed:@"article_tabbar_commert_b"] forState:UIControlStateNormal];
    [_collecBtn setImage:isStyleBlack ? [UIImage imageNamed:@"follow_w"] : [UIImage imageNamed:@"article_tabbar_like_b"] forState:UIControlStateNormal];
    [_collecBtn setImage:isStyleBlack ? [UIImage imageNamed:@"follow_r"] : [UIImage imageNamed:@"follow_b"] forState:UIControlStateSelected];
    [_shareBtn setImage:isStyleBlack ? [UIImage imageNamed:@"share_w"] : [UIImage imageNamed:@"article_tabbar_share_b"] forState:UIControlStateNormal];
}

- (void)setCommentCount:(NSString *)commentCount{
    _commentCount = commentCount;
    
    if (commentCount.integerValue == 0) {
        _commentLab.hidden = YES;
        return;
    }
    _commentLab.hidden = NO;
    _commentLab.text = commentCount.integerValue > 99 ? @"99+" : commentCount;
}

- (void)setIsCollect:(NSString *)isCollect{
    _isCollect = isCollect;
    _collecBtn.selected = [isCollect isEqualToString:@"1"];
}

@end
