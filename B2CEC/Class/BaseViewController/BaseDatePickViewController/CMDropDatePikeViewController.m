//
//  CMDropDatePikeViewController.m
//  TrCommerce
//
//  Created by Tristan on 15/11/23.
//  Copyright © 2015年 Tristan. All rights reserved.
//

#import "CMDropDatePikeViewController.h"

@interface CMDropDatePikeViewController ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *topSepLine;
@property (nonatomic, strong) UILabel *bottomSepline;
@property (nonatomic, strong) UILabel *bottomSetLineH;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIButton *confirmBtn;




@end

@implementation CMDropDatePikeViewController

#pragma mark - life cycle

-(void)viewDidLoad{
    [super viewDidLoad];
    WEAK_SELF
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.cornerRadius = 10;
    
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
    }
    [self.view addSubview:_datePicker];
    _datePicker.datePickerMode = UIDatePickerModeTime;
    [_datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    __block UIDatePicker *blockDatePick = _datePicker;
    [_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIEdgeInsets padding = UIEdgeInsetsMake(60, 10, 60, 10);
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).with.insets(padding);
    }];
    
    //timeLabel
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
    }
//    __block UILabel *blockTimeLabel = _timeLabel;
    _timeLabel.textColor = [UIColor colorWithRed:0.090 green:0.373 blue:0.776 alpha:1.000];
    _timeLabel.text = @"请选择时间";
    [self.view addSubview:_timeLabel];
    [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.left.mas_equalTo(weakSelf.view).with.offset(20);
        make.right.mas_equalTo(weakSelf.view).with.offset(-20);
        make.top.mas_equalTo(weakSelf.view).with.offset(20);
        make.height.mas_equalTo(20);
    }];
    
    
    //topSepLine
    if (!_topSepLine) {
        _topSepLine = [UILabel new];
    }
    [self.view addSubview:_topSepLine];
    [_topSepLine setTranslatesAutoresizingMaskIntoConstraints:NO];
    _topSepLine.backgroundColor = [UIColor colorWithRed:0.090 green:0.373 blue:0.776 alpha:1.000];
    [_topSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).with.offset(0);
        make.right.mas_equalTo(weakSelf.view).with.offset(0);
        make.bottom.mas_equalTo(blockDatePick.mas_top).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //bottomSepLine
    if (!_bottomSepline) {
        _bottomSepline = [UILabel new];
    }
    __block UILabel *blockBottomSepLine = _bottomSepline;
    [self.view addSubview:_bottomSepline];
    _bottomSepline.backgroundColor = [UIColor lightGrayColor];
    _bottomSepline.alpha = 0.5;
    [_bottomSepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).with.offset(0);
        make.right.mas_equalTo(weakSelf.view).with.offset(0);
        make.top.mas_equalTo(blockDatePick.mas_bottom).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //cancleBtn、bottomSepLineH、confirmBtn
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
    }
    __block UIButton *blockCancleBtn = _cancleBtn;
    [self.view addSubview:_cancleBtn];
    _cancleBtn.backgroundColor = ClearColor;
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _cancleBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockBottomSepLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0);
        make.left.mas_equalTo(weakSelf.view).with.offset(0);
        
    }];
    [_cancleBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender){
       [weakSelf.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
           NSLog(@"取消时间选择");
       }];
    }];
    
    
    if (!_bottomSetLineH) {
        _bottomSetLineH = [UILabel new];
    }
    __block UILabel *blockBottomSetLineH = _bottomSetLineH;
    [self.view addSubview:_bottomSetLineH];
    _bottomSetLineH.alpha = 0.5;
    _bottomSetLineH.backgroundColor = [UIColor lightGrayColor];
    _bottomSetLineH.translatesAutoresizingMaskIntoConstraints = NO;
    [_bottomSetLineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockBottomSepLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0);
        make.left.mas_equalTo(blockCancleBtn.mas_right).with.offset(0);
        make.width.mas_equalTo(1);
        
    }];
    
    
    
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
    }
    [self.view addSubview:_confirmBtn];
    _confirmBtn.backgroundColor = ClearColor;
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blockBottomSepLine.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0);
        make.left.mas_equalTo(blockBottomSetLineH.mas_right).with.offset(0);
        make.width.mas_equalTo(blockCancleBtn.mas_width);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(0);
    }];
    [_confirmBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender){
        [weakSelf.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
           weakSelf.hasSelectDate(weakSelf.datePicker.date);
        }];
    }];
    
}




@end
