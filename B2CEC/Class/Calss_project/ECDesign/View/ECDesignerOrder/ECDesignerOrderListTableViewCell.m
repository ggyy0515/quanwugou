//
//  ECDesignerOrderListTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/21.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderListTableViewCell.h"
#import "ECPlaceOrderSelectCollectionViewCell.h"

@interface ECDesignerOrderListTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UIView *topView;

@property (strong,nonatomic) UIImageView *iconimageView;

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UILabel *dateNameLab;

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UIView *centerView;

@property (strong,nonatomic) UILabel *detaillab;

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UIView *bottomView;

@property (strong,nonatomic) UILabel *moneyLab;

@property (strong,nonatomic) UIButton *leftBtn;

@property (strong,nonatomic) UIButton *rightBtn;

@property (strong,nonatomic) UIView *endDateView;

@property (strong,nonatomic) UILabel *endDateNameLab;

@property (strong,nonatomic) UILabel *endDateLab;

@property (strong,nonatomic) UIView *lineView1;
@property (strong,nonatomic) UIView *lineView2;

@property (strong,nonatomic) NSArray *nameArray;
@property (assign,nonatomic) NSInteger leftType;
@property (assign,nonatomic) NSInteger rightType;

@end

@implementation ECDesignerOrderListTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderListTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderListTableViewCell)];
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
    if (!_topView) {
        _topView = [UIView new];
    }
    
    if (!_iconimageView) {
        _iconimageView = [UIImageView new];
    }
    _iconimageView.image = [UIImage imageNamed:@"face1"];
    _iconimageView.layer.cornerRadius = 21.5f;
    _iconimageView.layer.masksToBounds = YES;
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = LightMoreColor;
    _nameLab.font = FONT_28;
    
    if (!_dateNameLab) {
        _dateNameLab = [UILabel new];
    }
    _dateNameLab.text = @"下单时间";
    _dateNameLab.font = FONT_24;
    _dateNameLab.textColor = LightMoreColor;
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.font = FONT_24;
    _dateLab.textColor = LightColor;
    
    if (!_centerView) {
        _centerView = [UIView new];
    }
    
    if (!_detaillab) {
        _detaillab = [UILabel new];
    }
    _detaillab.font = FONT_32;
    _detaillab.textColor = DarkColor;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = (SCREENWIDTH - 24.f - 76.f * floorf((SCREENWIDTH - 24.f) / 76.f)) / (floorf((SCREENWIDTH - 24.f) / 76.f) - 1);
        layout.minimumLineSpacing = 12.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _collectionView.backgroundColor = self.backgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.userInteractionEnabled = NO;
    
    [_collectionView registerClass:[ECPlaceOrderSelectCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECPlaceOrderSelectCollectionViewCell)];
    
    if (!_bottomView) {
        _bottomView = [UIView new];
    }
    
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
    }
    
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
    }
    _leftBtn.titleLabel.font = FONT_28;
    _leftBtn.layer.cornerRadius = 4.f;
    _leftBtn.layer.masksToBounds = YES;
    [_leftBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickOperationBlock) {
            weakSelf.clickOperationBlock(weakSelf.leftType,weakSelf.indexPath.section);
        }
    }];
    
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
    }
    _rightBtn.titleLabel.font = FONT_28;
    _rightBtn.layer.cornerRadius = 4.f;
    _rightBtn.layer.masksToBounds = YES;
    [_rightBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.clickOperationBlock) {
            weakSelf.clickOperationBlock(weakSelf.rightType,weakSelf.indexPath.section);
        }
    }];
    
    if (!_endDateView) {
        _endDateView = [UIView new];
    }
    
    if (!_endDateNameLab) {
        _endDateNameLab = [UILabel new];
    }
    _endDateNameLab.text = @"完成时间";
    _endDateNameLab.textColor = LightMoreColor;
    _endDateNameLab.font = FONT_24;
    
    if (!_endDateLab) {
        _endDateLab = [UILabel new];
    }
    _endDateLab.textColor = LightColor;
    _endDateLab.font = FONT_24;
    
    if (!_lineView1) {
        _lineView1 = [UIView new];
    }
    _lineView1.backgroundColor = LineDefaultsColor;
    
    if (!_lineView2) {
        _lineView2 = [UIView new];
    }
    _lineView2.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_topView];
    [_topView addSubview:_iconimageView];
    [_topView addSubview:_nameLab];
    [_topView addSubview:_dateNameLab];
    [_topView addSubview:_dateLab];
    [self.contentView addSubview:_centerView];
    [_centerView addSubview:_detaillab];
    [_centerView addSubview:_collectionView];
    [self.contentView addSubview:_bottomView];
    [_bottomView addSubview:_moneyLab];
    [_bottomView addSubview:_leftBtn];
    [_bottomView addSubview:_rightBtn];
    [_bottomView addSubview:_endDateView];
    [_endDateView addSubview:_endDateNameLab];
    [_endDateNameLab addSubview:_endDateLab];
    [self.contentView addSubview:_lineView1];
    [self.contentView addSubview:_lineView2];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(50.f);
    }];
    
    [_iconimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(43.f, 43.f));
        make.left.mas_equalTo(12.f);
        make.centerY.mas_equalTo(weakSelf.topView.mas_centerY);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.iconimageView.mas_right).offset(17.f);
    }];
    
    [_dateNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-84.f);
        make.bottom.mas_equalTo(weakSelf.topView.mas_centerY).offset(-5.f);
    }];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.dateNameLab.mas_left);
        make.top.mas_equalTo(weakSelf.topView.mas_centerY).offset(5.f);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.topView.mas_bottom);
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
    
    [_detaillab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.bottom.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.detaillab.mas_bottom).offset(19.f);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(50.f);
    }];
    
    [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90.f, 32.f));
        make.centerY.mas_equalTo(weakSelf.bottomView.mas_centerY);
        make.right.mas_equalTo(weakSelf.rightBtn.mas_left).offset(-12.f);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(weakSelf.leftBtn);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_endDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0.f);
        make.width.mas_equalTo(84.f + [CMPublicMethod getWidthWithLabel:weakSelf.endDateNameLab]);
    }];
    
    [_endDateNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.endDateView.mas_centerY).offset(-5.f);
    }];
    
    [_endDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.mas_equalTo(weakSelf.endDateView.mas_centerY).offset(5.f);
    }];
    
    [_lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.topView.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(weakSelf.lineView1);
        make.top.mas_equalTo(weakSelf.bottomView.mas_top);
    }];
}
//0:白底黑字黑边  1：黑底白字无边
- (void)setBtnUI:(UIButton *)btn WithType:(NSInteger)type WithTitle:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    switch (type) {
        case -1:{
            [btn setTitleColor:LightColor forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = ClearColor.CGColor;
            btn.layer.borderWidth = 0.f;
            btn.enabled = NO;
        }
            break;
        case 0:{
            [btn setTitleColor:DarkMoreColor forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = UIColorFromHexString(@"c7c7c7").CGColor;
            btn.layer.borderWidth = 1.f;
            btn.enabled = YES;
        }
            break;
        case 1:{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = MainColor;
            btn.layer.borderColor = ClearColor.CGColor;
            btn.layer.borderWidth = 0.f;
            btn.enabled = YES;
        }
            break;
        default:{
        
        }
            break;
    }
}

- (NSAttributedString *)getMoneyAttriStr:(NSString *)money{
    money = [NSString stringWithFormat:@"%.2f",[money floatValue]];
    NSMutableAttributedString *attStr = [NSMutableAttributedString new];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"报价：￥" attributes:@{NSFontAttributeName:FONT_28,NSForegroundColorAttributeName:DarkMoreColor}]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[money substringToIndex:money.length - 3] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.f],NSForegroundColorAttributeName:DarkMoreColor}]];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[money substringFromIndex:money.length - 3] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f],NSForegroundColorAttributeName:DarkMoreColor}]];
    return attStr;
}

- (void)setIsDesigner:(BOOL)isDesigner{
    _isDesigner = isDesigner;
}

- (void)setModel:(ECDesignerOrderModel *)model{
    _model = model;
    
    _dateLab.text = model.createdate;
    _detaillab.text = model.describe;
    
    _nameArray = @[[NSString stringWithFormat:@"%@ M²",model.housearea],
                   [NSString stringWithFormat:@"%@ 天",model.cycle],
                   model.housetype,
                   model.decoratetype,
                   model.style];
    [self.collectionView reloadData];
    
    if (_isDesigner) {
        [_iconimageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.utitle_img)] placeholder:[UIImage imageNamed:@"face1"]];
        _nameLab.text = model.uname;
        if ([model.state isEqualToString:@"yixiadan"]) {//待接单
            _moneyLab.hidden = YES;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _leftType = 0;
            _rightType = 1;
            
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"婉拒"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"报价接单"];
        }else if ([model.state isEqualToString:@"daiqueren"]){//已报价
            _moneyLab.hidden = NO;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _leftType = 0;
            _rightType = 9;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"取消"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"修改"];
        }else if ([model.state isEqualToString:@"jinxingzhong"]){//进行中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _rightType = 5;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认完工"];
        }else if ([model.state isEqualToString:@"Designer_complate"]){//设计师完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"待用户确认"];
        }else if ([model.state isEqualToString:@"daipingjia"] || [model.state isEqualToString:@"complate"]){//待评价//已完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = YES;
            _endDateView.hidden = NO;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            _endDateLab.text = model.updatedate;
        }else if ([model.state isEqualToString:@"yiquxiao"]){//已取消
            _moneyLab.hidden = YES;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已取消"];
        }else if ([model.state isEqualToString:@"reback_money_ing"]){//退款中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"退款中"];
        }else if ([model.state isEqualToString:@"yituikuan"]){//已退款
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已退款"];
        }
    }else{
        [_iconimageView yy_setImageWithURL:[NSURL URLWithString:IMAGEURL(model.dtitle_img)] placeholder:[UIImage imageNamed:@"face1"]];
        _nameLab.text = model.dname;
        if ([model.state isEqualToString:@"yixiadan"]) {//已下单
            _moneyLab.hidden = YES;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _leftType = 2;
            _rightType = 3;
            
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"取消订单"];
            [self setBtnUI:_rightBtn WithType:0 WithTitle:@"修改"];
        }else if ([model.state isEqualToString:@"daiqueren"]){//待确认
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _rightType = 4;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认并支付"];
        }else if ([model.state isEqualToString:@"jinxingzhong"]){//进行中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _rightType = 7;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:0 WithTitle:@"申请退款"];
        }else if ([model.state isEqualToString:@"Designer_complate"]){//设计师完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = NO;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _leftType = 7;
            _rightType = 6;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_leftBtn WithType:0 WithTitle:@"申请退款"];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"确认完工"];
        }else if ([model.state isEqualToString:@"daipingjia"]){//待评价
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            _rightType = 8;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:1 WithTitle:@"去评价"];
        }else if ([model.state isEqualToString:@"complate"]){//已完成
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = YES;
            _endDateView.hidden = NO;

            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            _endDateLab.text = model.updatedate;
        }else if ([model.state isEqualToString:@"yiquxiao"]){//已取消
            _moneyLab.hidden = YES;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已取消"];
        }else if ([model.state isEqualToString:@"reback_money_ing"]){//退款中
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"退款中"];
        }else if ([model.state isEqualToString:@"yituikuan"]){//已退款
            _moneyLab.hidden = NO;
            _leftBtn.hidden = YES;
            _rightBtn.hidden = NO;
            _endDateView.hidden = YES;
            
            _moneyLab.attributedText = [self getMoneyAttriStr:model.money];
            [self setBtnUI:_rightBtn WithType:-1 WithTitle:@"已退款"];
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ECPlaceOrderSelectCollectionViewCell *cell = [ECPlaceOrderSelectCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.name = _nameArray[indexPath.row];
    cell.isCurrent = NO;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(76.f, 25.f);
}

@end
