//
//  ECMoreProductDetailViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/11/24.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMoreProductDetailViewController.h"
#import "ECMallProductModel.h"

@interface ECMoreProductDetailViewController ()

@property (nonatomic, strong) ECMallProductModel *model;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *toDetailBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation ECMoreProductDetailViewController

#pragma mark - Life Cycle

- (instancetype)initWithProductModel:(ECMallProductModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    [self.view addSubview:_imageView];
    [_imageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(_model.image)]
                       placeholder:[UIImage imageNamed:@"placeholder_goods2"]];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(470.f / 2.f);
    }];
    
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
    }
    [self.view addSubview:_nameLabel];
    _nameLabel.font = FONT_32;
    _nameLabel.textColor = DarkMoreColor;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom).offset(12.f);
        make.height.mas_equalTo(weakSelf.nameLabel.font.lineHeight);
    }];
    _nameLabel.text = _model.name;
    
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
    }
    [self.view addSubview:_priceLabel];
    _priceLabel.font = FONT_B_36;
    _priceLabel.textColor = UIColorFromHexString(@"#1a191e");
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.nameLabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(weakSelf.priceLabel.font.lineHeight);
    }];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.price];
    
    if (!_collectBtn) {
        _collectBtn = [UIButton new];
    }
    [self.view addSubview:_collectBtn];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = FONT_32;
    _collectBtn.backgroundColor = UIColorFromHexString(@"#48474b");
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.priceLabel.mas_bottom).offset(10.f);
    }];
    [_collectBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.collectBtnClick) {
            weakSelf.collectBtnClick();
        }
    }];
    
    if (!_toDetailBtn) {
        _toDetailBtn = [UIButton new];
    }
    [self.view addSubview:_toDetailBtn];
    [_toDetailBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [_toDetailBtn setTitleColor:UIColorFromHexString(@"#ffffff") forState:UIControlStateNormal];
    _toDetailBtn.titleLabel.font = FONT_32;
    _toDetailBtn.backgroundColor = UIColorFromHexString(@"#1a191e");
    [_toDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(weakSelf.view);
        make.top.width.mas_equalTo(weakSelf.collectBtn);
        make.left.mas_equalTo(weakSelf.collectBtn.mas_right);
    }];
    [_toDetailBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.toDetailBtnClick) {
            weakSelf.toDetailBtnClick();
        }
    }];
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
