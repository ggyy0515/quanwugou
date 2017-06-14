//
//  ECDesignerRegisterTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerRegisterTableViewCell.h"

@interface ECDesignerRegisterTableViewCell()<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (strong,nonatomic) UILabel *nameLab;

@property (strong,nonatomic) UITextField *nameTF;

@property (strong,nonatomic) UILabel *nameDataLab;

@property (strong,nonatomic) UIView *nameLineView;

@property (strong,nonatomic) UIPickerView *pickerView;

@property (strong,nonatomic) UIDatePicker *birthPickerView;

@property (strong,nonatomic) CMWorksTypeListModel *worksTypeListModel;

@end

@implementation ECDesignerRegisterTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerRegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerRegisterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerRegisterTableViewCell)];
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
    self.worksTypeListModel = [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model;
    WEAK_SELF
    
    if (!_nameLab) {
        _nameLab = [UILabel new];
    }
    _nameLab.textColor = LightMoreColor;
    _nameLab.font = FONT_32;
    
    if (!_nameTF) {
        _nameTF = [UITextField new];
    }
    [_nameTF setValue:LightColor forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
    _nameTF.font = FONT_32;
    _nameTF.textColor = DarkMoreColor;
    [_nameTF handleControlEvent:UIControlEventEditingDidEnd withBlock:^(UITextField *sender) {
        if (weakSelf.changeDataBlock) {
            weakSelf.changeDataBlock(weakSelf.indexpath,sender.text);
        }
    }];
    
    if (!_nameDataLab) {
        _nameDataLab = [UILabel new];
    }
    _nameDataLab.textColor = LightColor;
    _nameDataLab.font = FONT_32;
    
    if (!_nameLineView) {
        _nameLineView = [UIView new];
    }
    _nameLineView.backgroundColor = LineDefaultsColor;
    
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
    }
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    if (!_birthPickerView) {
        _birthPickerView = [UIDatePicker new];
    }
    _birthPickerView.backgroundColor = [UIColor whiteColor];
    _birthPickerView.datePickerMode = UIDatePickerModeDate;
    _birthPickerView.maximumDate = [NSDate date];
    [_birthPickerView addTarget:self action:@selector(changeBirth:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_nameTF];
    [self.contentView addSubview:_nameDataLab];
    [self.contentView addSubview:_nameLineView];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(76.f);
    }];
    
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0.f);
        make.left.mas_equalTo(weakSelf.nameLab.mas_right);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_nameDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf.nameTF);
    }];
    
    [_nameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.nameTF);
        make.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)changeBirth:(UIDatePicker *)picker{
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    _nameTF.text = [outputFormatter stringFromDate:picker.date];
}

- (void)setIsInput:(BOOL)isInput{
    _isInput = isInput;
    _nameTF.hidden = !isInput;
    _nameDataLab.hidden = isInput;
}

- (void)setIndexpath:(NSIndexPath *)indexpath{
    _indexpath = indexpath;
}

- (void)setName:(NSString *)name WithPlaceholder:(NSString *)placeholder{
    _nameLab.text = name;
    _nameTF.placeholder = placeholder;
    _nameDataLab.text = placeholder;
}

- (void)setDataStr:(NSString *)dataStr{
    _dataStr = dataStr;
    if (dataStr.length != 0) {
        _nameDataLab.text = dataStr;
        _nameDataLab.textColor = DarkMoreColor;
    }
    _nameTF.text = dataStr;
}

- (void)setJobsArray:(NSArray *)jobsArray{
    _jobsArray = jobsArray;
}

- (void)setKeyboardType:(NSInteger)keyboardType{
    _keyboardType = keyboardType;
    switch (keyboardType) {
        case 0:{
            [_pickerView reloadAllComponents];
            _nameTF.inputView = _pickerView;
        }
            break;
        case 1:{
            _nameTF.inputView = _birthPickerView;
        }
            break;
        case 2:{
            _nameTF.inputView = nil;
            _nameTF.keyboardType = UIKeyboardTypePhonePad;
        }
            break;
        case 3:{
            _nameTF.inputView = nil;
            _nameTF.keyboardType = UIKeyboardTypeDecimalPad;
        }
            break;
        case 4:
        case 5:{
            [_pickerView reloadAllComponents];
            _nameTF.inputView = _pickerView;
        }
            break;
        default:{
            _nameTF.inputView = nil;
            _nameTF.keyboardType = UIKeyboardTypeDefault;
        }
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.keyboardType == 0) {
        return 3;
    }else if (self.keyboardType == 4){
        return self.worksTypeListModel.allcasestyle.count;
    }else if (self.keyboardType == 5){
        return self.jobsArray.count;
    }else{
        return 0.f;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.keyboardType == 0) {
        switch (row) {
            case 0:{
                return @"男";
            }
                break;
            case 1:{
                return @"女";
            }
                break;
            default:{
                return @"保密";
            }
                break;
        }
    }else if (self.keyboardType == 4){
        CMWorksTypeModel *model = self.worksTypeListModel.allcasestyle[row];
        return model.NAME;
    }else if (self.keyboardType == 5){
        CMWorksTypeModel *model = self.jobsArray[row];
        return model.NAME;
    }else{
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.keyboardType == 0) {
        switch (row) {
            case 0:{
                _nameTF.text = @"男";
            }
                break;
            case 1:{
                _nameTF.text = @"女";
            }
                break;
            default:{
                _nameTF.text = @"保密";
            }
                break;
        }
    }else if (self.keyboardType == 4){
        CMWorksTypeModel *model = self.worksTypeListModel.allcasestyle[row];
        _nameTF.text = model.NAME;
        if (self.changeStyleBlock) {
            self.changeStyleBlock(self.indexpath,model.NAME,model.BIANMA);
        }
    }else if (self.keyboardType == 5){
        CMWorksTypeModel *model = self.jobsArray[row];
        _nameTF.text = model.NAME;
        if (self.changeJobsBlock) {
            self.changeJobsBlock(self.indexpath,model.NAME,model.BIANMA);
        }
    }else{
    }
}

@end
