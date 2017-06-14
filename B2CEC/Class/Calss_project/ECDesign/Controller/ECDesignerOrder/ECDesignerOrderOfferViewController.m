//
//  ECDesignerOrderOfferViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderOfferViewController.h"

@interface ECDesignerOrderOfferViewController ()<
UITextFieldDelegate
>

@property (nonatomic, weak) UIViewController *superVC;
@property (nonatomic, copy) void(^verifyResultBlock)(CGFloat money);

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UIView *lineView1;

@property (strong,nonatomic) UILabel *basicLab;

@property (strong,nonatomic) UITextField *moneyTF;

@property (strong,nonatomic) UIView *bottomView;

@property (strong,nonatomic) UIButton *cancelBtn;

@property (strong,nonatomic) UIButton *successBtn;

@end

@implementation ECDesignerOrderOfferViewController

+ (void)showOfferVCInSuperViewController:(UIViewController *)superVC verifyResultBlock:(void(^)(CGFloat money))verifyResultBlock{
    ECDesignerOrderOfferViewController *vc = [[self alloc] initWithSuperViewController:superVC];
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
                                                   fromRect:CGRectMake(16.f,160.f, SCREENWIDTH - 32.f, (SCREENWIDTH - 32.f) * (366.f / (750.f - 64.f)))
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
    [_moneyTF resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_moneyTF becomeFirstResponder];
}

- (void)dealloc {
    ECLog(@"支付密码页面挂了");
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"报价";
    _titleLab.textColor = DarkColor;
    _titleLab.font = FONT_32;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_basicLab) {
        _basicLab = [UILabel new];
    }
    _basicLab.text = @"￥";
    _basicLab.font = [UIFont systemFontOfSize:21.f];
    _basicLab.textColor = DarkColor;
    
    if (!_moneyTF) {
        _moneyTF = [UITextField new];
    }
    _moneyTF.keyboardType = UIKeyboardTypeNumberPad;
    _moneyTF.textAlignment = NSTextAlignmentCenter;
    _moneyTF.textColor = DarkColor;
    _moneyTF.font = [UIFont systemFontOfSize:28.f];
    _moneyTF.delegate = self;
    [_moneyTF handleControlEvent:UIControlEventEditingChanged withBlock:^(UITextField *sender) {
        [weakSelf.moneyTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
            make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
            make.height.mas_equalTo(50.f);
            make.width.mas_equalTo([CMPublicMethod getWidthWithContent:sender.text height:50.f font:28.f] + 10.f);
        }];
        [weakSelf.view layoutIfNeeded];
    }];
    
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    _bottomView.backgroundColor = LineDefaultsColor;
    
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
    }
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:DarkColor forState:UIControlStateNormal];
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    _cancelBtn.titleLabel.font = FONT_32;
    [_cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:nil];
    }];
    
    if (!_successBtn) {
        _successBtn = [UIButton new];
    }
    [_successBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_successBtn setTitleColor:DarkColor forState:UIControlStateNormal];
    _successBtn.backgroundColor = [UIColor whiteColor];
    _successBtn.titleLabel.font = FONT_32;
    [_successBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.moneyTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"报价金额不能为空"];
            return ;
        }
        [weakSelf.superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:nil];
        if (weakSelf.verifyResultBlock) {
            weakSelf.verifyResultBlock(weakSelf.moneyTF.text.floatValue);
        }
    }];
    
    [self.view addSubview:_titleLab];
    [self.view addSubview:_lineView1];
    [self.view addSubview:_basicLab];
    [self.view addSubview:_moneyTF];
    [self.view addSubview:_bottomView];
    [_bottomView addSubview:_cancelBtn];
    [_bottomView addSubview:_successBtn];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(44.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(44.f);
    }];
    
    [_basicLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.moneyTF.mas_centerY);
        make.right.mas_equalTo(weakSelf.moneyTF.mas_left).offset(-12.f);
    }];
    
    [_moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.height.mas_equalTo(50.f);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(0.5f);
        make.right.mas_equalTo(weakSelf.successBtn.mas_left).offset(-0.5f);
        make.width.mas_equalTo(weakSelf.successBtn.mas_width);
    }];
    
    [_successBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0.f);
        make.width.top.equalTo(weakSelf.cancelBtn);
        make.left.mas_equalTo(weakSelf.cancelBtn.mas_right).offset(0.5f);
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [CMPublicMethod payTheKeyboardConstraintsTextField:textField string:string];
}

@end
