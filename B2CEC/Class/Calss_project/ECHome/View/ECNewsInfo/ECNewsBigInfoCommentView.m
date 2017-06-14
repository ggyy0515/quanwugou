//
//  ECNewsBigInfoCommentView.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsBigInfoCommentView.h"

@interface ECNewsBigInfoCommentView()<
UITextViewDelegate
>
@property (strong,nonatomic) UIView *commentInputView;

@property (strong,nonatomic) UIView *commentInputLineView;

@property (strong,nonatomic) UIView *commentTextBgView;

@property (strong,nonatomic) SHTextView *commentTextView;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UILabel *inputLab;

@property (strong,nonatomic) UIButton *inputBtn;

@end

@implementation ECNewsBigInfoCommentView{
    BOOL isAddInputView;
    CGSize currentTextViewContentSize;
    NSInteger textLine;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        isAddInputView = NO;
        textLine = -1;
        self.backgroundColor = [UIColor whiteColor];
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
    _inputView.backgroundColor = BaseColor;
    
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
        [weakSelf createCommentInputView];
        weakSelf.hidden = YES;
        weakSelf.commentInputView.hidden = NO;
        [weakSelf.commentTextView becomeFirstResponder];
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
    _commentTextView.delegate = self;
    
    [self addSubview:_lineView];
    [self addSubview:_inputView];
    [self addSubview:_inputLab];
    [self addSubview:_inputBtn];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.height.mas_equalTo(36.f);
        make.right.mas_equalTo(-18.f);
    }];
    
    [_inputLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.inputView.mas_left).offset(18.f);
        make.right.mas_equalTo(weakSelf.inputView.mas_right).offset(-18.f);
        make.top.bottom.equalTo(weakSelf.inputView);
    }];
    
    [_inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.inputLab);
    }];
}

- (void)createCommentInputView{
    if (!isAddInputView) {
        isAddInputView = YES;
        [self.superview addSubview:_commentInputView];
        [_commentInputView addSubview:_commentInputLineView];
        [_commentInputView addSubview:_commentTextBgView];
        [_commentTextBgView addSubview:_commentTextView];
    }
    [self updateCommenttextViewHeight:_commentTextView WithReturnLine:NO WithSetBasic:YES];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.commentInputView.hidden = YES;
    self.hidden = NO;
    self.inputLab.text = textView.text.length == 0 ? @"写评论..." : textView.text;
    self.inputLab.textColor = textView.text.length == 0 ? LightColor : MainColor;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (!currentTextViewContentSize.width) {
        currentTextViewContentSize = textView.contentSize;
    } else {
        if (currentTextViewContentSize.height < textView.contentSize.height) {
            [self updateCommenttextViewHeight:textView WithReturnLine:YES WithSetBasic:NO];
        } else if (currentTextViewContentSize.height > textView.contentSize.height) {
            [self updateCommenttextViewHeight:textView WithReturnLine:NO WithSetBasic:NO];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if (self.sendCommentTextBlock) {
            self.sendCommentTextBlock(textView.text);
        }
        textView.text = @"";
        textLine = -1;
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)updateCommenttextViewHeight:(UITextView *)textView WithReturnLine:(BOOL)isLine WithSetBasic:(BOOL)isBasic{
    if (!isBasic) {//如果是输入的
        isLine ? textLine ++ : textLine -- ;
    }
    
    currentTextViewContentSize = textView.contentSize;
    CGFloat height = 36.f + 20.f +  textLine * 20.f;
    
    if (height >= 100.f) {
        height = 100.f;
    }
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

- (void)setIsBecomeInput:(BOOL)isBecomeInput{
    _isBecomeInput = isBecomeInput;
    if (isBecomeInput) {
        [self createCommentInputView];
        self.hidden = YES;
        self.commentInputView.hidden = NO;
        [self.commentTextView becomeFirstResponder];
    }
}

@end
