//
//  ECFilterPriceTableViewCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/15.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECFilterPriceTableViewCell.h"

@interface ECFilterPriceTableViewCell ()
<
    UITextFieldDelegate
>

@property (strong,nonatomic) UITextField *minTextField;

@property (strong,nonatomic) UITextField *maxTextField;

@property (strong,nonatomic) UIView *lineView;

/**
 *  用以表示价格区间or时间段
 */
@property (nonatomic, assign) BOOL isPickDate;


@end

@implementation ECFilterPriceTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView isPickDate:(BOOL)isPickDate {
    ECFilterPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterPriceTableViewCell)];
    if (cell == nil) {
        cell = [self alloc];
        cell.isPickDate = isPickDate;
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECFilterPriceTableViewCell)];
        //        cell = [[ECScreenPriceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECScreenPriceTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    if (!_minTextField) {
        _minTextField = [UITextField new];
    }
    _minTextField.textAlignment = NSTextAlignmentCenter;
    _minTextField.backgroundColor = BaseColor;
    _minTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _minTextField.font = [UIFont systemFontOfSize:14.f];
    _minTextField.textColor = DarkColor;
    _minTextField.delegate = self;
    [_minTextField setValue:LightColor forKeyPath:@"_placeholderLabel.textColor"];
    [_minTextField handleControlEvent:UIControlEventEditingChanged withBlock:^(UITextField *sender) {
        if (weakSelf.isPickDate) {
            if (weakSelf.changeDateBlock) {
                weakSelf.changeDateBlock(weakSelf.minTextField.text, weakSelf.maxTextField.text);
            }
        } else {
            if (weakSelf.changePriceBlock) {
                weakSelf.changePriceBlock(weakSelf.minTextField.text.floatValue,weakSelf.maxTextField.text.floatValue);
            }
        }
    }];
    
    if (!_maxTextField) {
        _maxTextField = [UITextField new];
    }
    _maxTextField.textAlignment = NSTextAlignmentCenter;
    _maxTextField.backgroundColor = BaseColor;
    _maxTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _maxTextField.font = [UIFont systemFontOfSize:14.f];
    _maxTextField.textColor = DarkColor;
    _maxTextField.delegate = self;
    [_maxTextField setValue:LightColor forKeyPath:@"_placeholderLabel.textColor"];
    [_maxTextField handleControlEvent:UIControlEventEditingChanged withBlock:^(UITextField *sender) {
        if (weakSelf.isPickDate) {
            if (weakSelf.changeDateBlock) {
                weakSelf.changeDateBlock(weakSelf.minTextField.text, weakSelf.maxTextField.text);
            }
        } else {
            if (weakSelf.changePriceBlock) {
                weakSelf.changePriceBlock(weakSelf.minTextField.text.floatValue,weakSelf.maxTextField.text.floatValue);
            }
        }
    }];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LightColor;
    
    [self.contentView addSubview:_minTextField];
    [self.contentView addSubview:_maxTextField];
    [self.contentView addSubview:_lineView];
    
    [_minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(10.f);
        make.right.mas_equalTo(weakSelf.lineView.mas_left).offset(-7.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(13.f);
        make.height.mas_equalTo(2.f);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.maxTextField.mas_centerY);
    }];
    
    [_maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16.f);
        make.left.mas_equalTo(weakSelf.lineView.mas_right).offset(7.f);
        make.top.height.equalTo(weakSelf.minTextField);
    }];
    
    
    //-------------------------选择时间-------------------------//
    
    if (_isPickDate) {
        _minTextField.keyboardType = UIKeyboardTypeNumberPad;
        _maxTextField.keyboardType = UIKeyboardTypeNumberPad;
        _minTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"开始时间(如20160808)"
                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
                                                                                           NSForegroundColorAttributeName:LightColor}];
        _maxTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"结束时间(如20160808)"
                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
                                                                                           NSForegroundColorAttributeName:LightColor}];
    }
    
    //-------------------------选择时间-------------------------//
}

- (void)setLeftString:(NSString *)leftString{
    _leftString = leftString;
    _minTextField.placeholder = leftString;
}

- (void)setRightString:(NSString *)rightString{
    _rightString = rightString;
    _maxTextField.placeholder = rightString;
}

- (void)setMinPrice:(CGFloat)minPrice{
    _minPrice = minPrice;
    if (_minPrice == 0.f) {
        _minTextField.text = @"";
    }else{
        _minTextField.text = [NSString stringWithFormat:@"%.2f",_minPrice];
    }
}

- (void)setMaxPrice:(CGFloat)maxPrice{
    _maxPrice = maxPrice;
    if (_maxPrice == 0.f) {
        _maxTextField.text = @"";
    }else{
        _maxTextField.text = [NSString stringWithFormat:@"%.2f",_maxPrice];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian){//text中还没有小数点
                    isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else{
        return YES;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
