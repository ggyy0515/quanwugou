//
//  ECPayPasswordViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/16.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPayPasswordViewController.h"
#import "ECPayPasswordCell.h"

@interface ECPayPasswordViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, weak) UIViewController *superVC;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) void(^verifyResultBlock)(BOOL isPasswordValid);
@property (nonatomic, strong) UITextField *textTF;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ECPayPasswordViewController

#pragma mark - Life Cycle

+ (void)showPayPasswordVCInSuperViewController:(UIViewController *)superVC amount:(NSString *)amount verifyResultBlock:(void(^)(BOOL isPasswordValid))verifyResultBlock {
    ECPayPasswordViewController *vc = [[self alloc] initWithSuperViewController:superVC amount:amount];
    vc.verifyResultBlock = verifyResultBlock;
    
    //animate
    [vc setPopinTransitionStyle:BKTPopinTransitionStyleSlide];
    BKTBlurParameters *blurParameters = [[BKTBlurParameters alloc] init];
    vc.popinOptions = BKTPopinDisableAutoDismiss;
    blurParameters.tintColor = [UIColor colorWithWhite:0 alpha:0.5];
    blurParameters.radius = 0.3;
    [vc setBlurParameters:blurParameters];
    [vc setPopinTransitionDirection:BKTPopinTransitionDirectionTop];
    [vc.superVC.navigationController presentPopinController:vc
                                                   fromRect:CGRectMake(16.f, 92.f, SCREENWIDTH - 32.f, (SCREENWIDTH - 32.f) * (458.f / (750.f - 64.f)))
                                           needComputeFrame:NO
                                                   animated:YES
                                                 completion:nil];
}

- (instancetype)initWithSuperViewController:(UIViewController *)superVC amount:(NSString *)amount {
    if (self = [super init]) {
        _superVC = superVC;
        _amount = amount;
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
    [_textTF resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textTF becomeFirstResponder];
}

- (void)dealloc {
    ECLog(@"支付密码页面挂了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_textTF) {
        _textTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    }
    [self.view addSubview:_textTF];
    _textTF.hidden = YES;
    _textTF.keyboardType = UIKeyboardTypeNumberPad;
    [_textTF addTarget:self action:@selector(passwordDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    [self.view addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:19.f];
    _titleLabel.textColor = DarkColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"请输入支付密码";
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.view.mas_top).offset(59.f / 2.f);
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(59.f);
    }];
    
    if (!_line) {
        _line = [UIView new];
    }
    [self.view addSubview:_line];
    _line.backgroundColor = UIColorFromHexString(@"#dddddd");
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(1.f);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom);
    }];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 52.f - 5.f - 32.f) / 6.f, (SCREENWIDTH - 52.f - 5.f - 32.f) / 6.f);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = UIColorFromHexString(@"#eeeeee");
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.layer.borderWidth = 1.f;
    _collectionView.layer.borderColor = UIColorFromHexString(@"#cccccc").CGColor;
    _collectionView.scrollEnabled = NO;
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-32.f);
        make.left.mas_equalTo(26.f);
        make.right.mas_equalTo(-26.f);
        make.height.mas_equalTo((SCREENWIDTH - 52.f - 5.f - 32.f) / 6.f);
    }];
    [_collectionView registerClass:[ECPayPasswordCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPayPasswordCell)];
    
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
    }
    [self.view addSubview:_amountLabel];
    _amountLabel.font = [UIFont systemFontOfSize:32.f];
    _amountLabel.textColor = DarkMoreColor;
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.line.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.collectionView.mas_top);
    }];
    _amountLabel.text = [NSString stringWithFormat:@"%@", _amount];
    
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
    }
    [self.view addSubview:_closeBtn];
    [_closeBtn setImage:[UIImage imageNamed:@"navdown_close"] forState:UIControlStateNormal];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.size.mas_equalTo(CGSizeMake(22.f, 22.f));
    }];
    [_closeBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - Actions

- (void)passwordDidChanged:(UITextField *)textField {
    WEAK_SELF
    [_collectionView reloadData];
    if (textField.text.length == 6) {
        SHOWSVP
        [ECHTTPServer requestValidPasswordWithLoginPassword:nil
                                            WithPayPassword:textField.text
                                                    succeed:^(NSURLSessionDataTask *task, id result) {
                                                        if (IS_REQUEST_SUCCEED(result)) {
                                                            STRONG_SELF
                                                            [_superVC.navigationController dismissCurrentPopinControllerAnimated:YES completion:^{
                                                                if (strongSelf.verifyResultBlock) {
                                                                    strongSelf.verifyResultBlock(YES);
                                                                }
                                                            }];
                                                        } else {
                                                            EC_SHOW_REQUEST_ERROR_INFO
                                                            [self clearInupt];
                                                            if (_verifyResultBlock) {
                                                                _verifyResultBlock(NO);
                                                            }
                                                        }
                                                    }
                                                     failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                        RequestFailure
                                                         [self clearInupt];
                                                         if (_verifyResultBlock) {
                                                             _verifyResultBlock(NO);
                                                         }
                                                     }];
    }
}

- (void)clearInupt {
    _textTF.text = @"";
    [_collectionView reloadData];
}

#pragma mark - UICollection Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPayPasswordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPayPasswordCell)
                                                                        forIndexPath:indexPath];
    if (indexPath.row + 1 > _textTF.text.length) {
        cell.isShow = NO;
    } else {
        cell.isShow = YES;
    }
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
