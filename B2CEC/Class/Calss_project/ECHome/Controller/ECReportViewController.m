//
//  ECReportViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2017/1/17.
//  Copyright © 2017年 Tristan. All rights reserved.
//

#import "ECReportViewController.h"

@interface ECReportViewController ()

@property (nonatomic, weak) UIViewController *superVC;
@property (nonatomic, copy) void(^verifyResultBlock)(NSString *type,NSString *content);

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIButton *closeBtn;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UIButton *typeBtn1;

@property (strong,nonatomic) UIButton *typeBtn2;

@property (strong,nonatomic) UIButton *typeBtn3;

@property (strong,nonatomic) UILabel *contentTitleLab;

@property (strong,nonatomic) UIView *lineView2;

@property (strong,nonatomic) UITextView *reportTextView;

@property (strong,nonatomic) UIButton *sumbitBtn;

@property (assign,nonatomic) NSInteger type;

@end

@implementation ECReportViewController

+ (void)showReportVCInSuperViewController:(UIViewController *)superVC verifyResultBlock:(void(^)(NSString *type,NSString *content))verifyResultBlock{
    ECReportViewController *vc = [[self alloc] initWithSuperViewController:superVC];
    vc.verifyResultBlock = verifyResultBlock;
    
    //animate
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    vc.popinOptions = BKTPopinDisableAutoDismiss;
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    vc.view.layer.cornerRadius = 5.f;
    vc.view.layer.masksToBounds = YES;
    [vc setBlurParameters:blurParameters];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [vc.superVC.navigationController presentPopinController:vc
                                                   fromRect:CGRectMake(16.f,160.f, SCREENWIDTH - 32.f, (SCREENWIDTH - 32.f) * (630.f / (750.f - 64.f)))
                                           needComputeFrame:NO
                                                   animated:YES
                                                 completion:nil];
}

- (instancetype)initWithSuperViewController:(UIViewController *)superVC {
    if (self = [super init]) {
        _superVC = superVC;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _type = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = NO;
    keyboardManager.enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.enable = YES;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    ECLog(@"举报页面挂了");
}

- (void)createUI {
    WEAK_SELF
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"请选择举报类型";
    _titleLab.textColor = LightMoreColor;
    _titleLab.font = FONT_36;
    
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
    }
    [_closeBtn setImage:[UIImage imageNamed:@"navdown_close2"] forState:UIControlStateNormal];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:nil];
    }];
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_typeBtn1) {
        _typeBtn1 = [UIButton new];
    }
    [_typeBtn1 setTitle:@"违法" forState:UIControlStateNormal];
    _typeBtn1.titleLabel.font = FONT_28;
    _typeBtn1.layer.cornerRadius = 5.f;
    _typeBtn1.layer.masksToBounds = YES;
    [_typeBtn1 handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.type = 1;
        [weakSelf updateTypeBtn];
    }];
    
    if (!_typeBtn2) {
        _typeBtn2 = [UIButton new];
    }
    [_typeBtn2 setTitle:@"涉黄" forState:UIControlStateNormal];
    _typeBtn2.titleLabel.font = FONT_28;
    _typeBtn2.layer.cornerRadius = 5.f;
    _typeBtn2.layer.masksToBounds = YES;
    [_typeBtn2 handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.type = 2;
        [weakSelf updateTypeBtn];
    }];
    
    if (!_typeBtn3) {
        _typeBtn3 = [UIButton new];
    }
    [_typeBtn3 setTitle:@"侵权" forState:UIControlStateNormal];
    _typeBtn3.titleLabel.font = FONT_28;
    _typeBtn3.layer.cornerRadius = 5.f;
    _typeBtn3.layer.masksToBounds = YES;
    [_typeBtn3 handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        weakSelf.type = 3;
        [weakSelf updateTypeBtn];
    }];
    
    if (!_contentTitleLab) {
        _contentTitleLab = [UILabel new];
    }
    _contentTitleLab.text = @"备注信息";
    _contentTitleLab.textColor = LightMoreColor;
    _contentTitleLab.font = FONT_36;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    if (!_reportTextView) {
        _reportTextView = [UITextView new];
    }
    _reportTextView.layer.borderColor = LineDefaultsColor.CGColor;
    _reportTextView.layer.borderWidth = 0.5f;
    _reportTextView.layer.cornerRadius = 5.f;
    _reportTextView.layer.masksToBounds = YES;
    _reportTextView.font = FONT_32;
    
    if (!_sumbitBtn) {
        _sumbitBtn = [UIButton new];
    }
    [_sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_sumbitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sumbitBtn.backgroundColor = DarkColor;
    _sumbitBtn.titleLabel.font = FONT_36;
    _sumbitBtn.layer.cornerRadius = 5.f;
    _sumbitBtn.layer.masksToBounds = YES;
    [_sumbitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.reportTextView endEditing:YES];
        [weakSelf.superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:nil];
        if (weakSelf.verifyResultBlock) {
            weakSelf.verifyResultBlock(weakSelf.type == 1 ? @"违法" : weakSelf.type == 2 ? @"涉黄" : @"",weakSelf.reportTextView.text);
        }
    }];
    
    [self.view addSubview:_titleLab];
    [self.view addSubview:_closeBtn];
    [self.view addSubview:_lineView1];
    [self.view addSubview:_typeBtn1];
    [self.view addSubview:_typeBtn2];
    [self.view addSubview:_typeBtn3];
    [self.view addSubview:_contentTitleLab];
    [self.view addSubview:_lineView2];
    [self.view addSubview:_reportTextView];
    [self.view addSubview:_sumbitBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16.f);
        make.right.mas_equalTo(-16.f);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
        make.right.mas_equalTo(-16.f);
        make.centerY.mas_equalTo(weakSelf.titleLab.mas_centerY);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(12.f);
    }];
    
    [_typeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLab.mas_left);
        make.top.mas_equalTo(weakSelf.lineView1.mas_bottom).offset(12.f);
        make.width.mas_equalTo(weakSelf.typeBtn2.mas_width);
        make.right.mas_equalTo(weakSelf.typeBtn2.mas_left).offset(-16.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_typeBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(weakSelf.typeBtn1);
        make.left.mas_equalTo(weakSelf.typeBtn1.mas_right).offset(16.f);
        make.right.mas_equalTo(weakSelf.typeBtn3.mas_left).offset(-16.f);
    }];
    
    [_typeBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(weakSelf.typeBtn1);
        make.left.mas_equalTo(weakSelf.typeBtn2.mas_right).offset(16.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_contentTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.top.mas_equalTo(weakSelf.typeBtn1.mas_bottom).offset(12.f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineView1);
        make.top.mas_equalTo(weakSelf.contentTitleLab.mas_bottom).offset(8.f);
    }];
    
    [_reportTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.height.mas_equalTo(80.f);
        make.top.mas_equalTo(weakSelf.lineView2.mas_bottom).offset(12.f);
    }];
    
    [_sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.height.mas_equalTo(44.f);
        make.top.mas_equalTo(weakSelf.reportTextView.mas_bottom).offset(16.f);
    }];
    
    [self updateTypeBtn];
}

- (void)updateTypeBtn{
    [_typeBtn1 setTitleColor:(_type == 1 ? [UIColor whiteColor] : LightColor) forState:UIControlStateNormal];
    _typeBtn1.backgroundColor = _type == 1 ? DarkColor : BaseColor;
    
    [_typeBtn2 setTitleColor:(_type == 2 ? [UIColor whiteColor] : LightColor) forState:UIControlStateNormal];
    _typeBtn2.backgroundColor = _type == 2 ? DarkColor : BaseColor;
    
    [_typeBtn3 setTitleColor:(_type == 3 ? [UIColor whiteColor] : LightColor) forState:UIControlStateNormal];
    _typeBtn3.backgroundColor = _type == 3 ? DarkColor : BaseColor;
}

@end
