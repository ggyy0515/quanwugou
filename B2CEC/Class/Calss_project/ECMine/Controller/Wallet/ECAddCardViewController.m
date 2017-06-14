//
//  ECAddCardViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECAddCardViewController.h"
#import "ECAddCardInfoCell.h"
#import "ECAddCardConfirmCell.h"
#import "ECBankListModel.h"
#import "ECSelectCityViewController.h"
#import "ECCityModel.h"
#import "ECBankListViewController.h"

@interface ECAddCardViewController ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, strong) ECBankListModel *bankModel;
@property (nonatomic, strong) ECCityModel *cityModel;
@property (nonatomic, strong) ECCityModel *provinceModel;

@end

@implementation ECAddCardViewController

#pragma mark - Life Cycle

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
    self.view.backgroundColor = BaseColor;
    
    _titleArray = @[@"持卡人", @"卡号", @"开卡银行", @"所在城市"];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _collectionView.backgroundColor = BaseColor;
    _collectionView.backgroundColor = BaseColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ECAddCardInfoCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardInfoCell)];
    [_collectionView registerClass:[ECAddCardConfirmCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardConfirmCell)];
    
}

#pragma mark - Actions

- (void)confirmAction {
    if (_name.length == 0) {
        [SVProgressHUD showWithStatus:@"请填写持卡人姓名"];
        return;
    }
    if (_number.length == 0) {
        [SVProgressHUD showWithStatus:@"请输入银行卡号"];
        return;
    }
    if (!_bankModel) {
        [SVProgressHUD showWithStatus:@"请选择开卡银行"];
        return;
    }
    if (!_provinceModel && !_cityModel) {
        [SVProgressHUD showWithStatus:@"请选择所在城市"];
        return;
    }
    SHOWSVP
    [ECHTTPServer requestbindBankCardWithUserId:[Keychain objectForKey:EC_USER_ID]
                                     cardHolder:_name
                                         cardNo:_number
                                       province:_provinceModel.NAME
                                           city:_cityModel ? _cityModel.NAME : _provinceModel.NAME
                                         bankId:_bankModel.ids
                                        succeed:^(NSURLSessionDataTask *task, id result) {
                                            if (IS_REQUEST_SUCCEED(result)) {
                                                RequestSuccess(result)
                                                POST_NOTIFICATION(NOTIFICATION_NAME_ADD_BANK_CARD, nil);
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                EC_SHOW_REQUEST_ERROR_INFO
                                            }
                                        }
                                         failed:^(NSURLSessionDataTask *task, NSError *error) {
                                            RequestFailure
                                         }];
}

#pragma mark - UICollection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleArray.count;
    }
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREENWIDTH, 50.f);
    }
    return CGSizeMake(SCREENWIDTH - 24.f, 49.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(12.f, 0, 0, 0);
    }
    return UIEdgeInsetsMake(12.f, 12.f, 12.f, 12.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ECAddCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardInfoCell)
                                                                                    forIndexPath:indexPath];
                cell.titleLabel.text = [_titleArray objectAtIndexWithCheck:indexPath.row];
                cell.arrow.hidden = YES;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                cell.textField.enabled = YES;
                cell.textField.placeholder = @"";
                cell.line.hidden = NO;
                cell.textField.text = _name;
                [cell setContentChanged:^(NSIndexPath *cellIndexPath, NSString *content) {
                    weakSelf.name = content;
                }];
                return cell;
            }
            case 1:
            {
                ECAddCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardInfoCell)
                                                                                    forIndexPath:indexPath];
                cell.titleLabel.text = [_titleArray objectAtIndexWithCheck:indexPath.row];
                cell.arrow.hidden = YES;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.enabled = YES;
                cell.textField.placeholder = @"";
                cell.line.hidden = NO;
                cell.textField.text = _number;
                [cell setContentChanged:^(NSIndexPath *cellIndexPath, NSString *content) {
                    weakSelf.number = content;
                }];
                return cell;
            }
            case 2:
            {
                ECAddCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardInfoCell)
                                                                                    forIndexPath:indexPath];
                cell.titleLabel.text = [_titleArray objectAtIndexWithCheck:indexPath.row];
                cell.arrow.hidden = YES;
                cell.textField.enabled = NO;
                cell.textField.placeholder = @"";
                [cell.textField setValue:UIColorFromHexString(@"#cccccc") forKeyPath:TEXTFIELD_PLACEHORDER_TEXTCOLOR];
                [cell.textField setValue:FONT_28 forKeyPath:TEXTFIELD_PLACEHORDER_FONT];
                cell.line.hidden = NO;
                if (_bankModel) {
                    cell.textField.text = _bankModel.name;
                } else {
                    cell.textField.text = @"";
                }
                return cell;
            }
            case 3:
            {
                ECAddCardInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardInfoCell)
                                                                                    forIndexPath:indexPath];
                cell.titleLabel.text = [_titleArray objectAtIndexWithCheck:indexPath.row];
                cell.arrow.hidden = NO;
                cell.textField.enabled = NO;
                cell.textField.placeholder = @"请选择城市";
                cell.line.hidden = YES;
                if (_cityModel && _provinceModel) {
                    cell.textField.text = [NSString stringWithFormat:@"%@ %@", _provinceModel.NAME, _cityModel.NAME];
                } else if (_provinceModel && !_cityModel) {
                    cell.textField.text = _provinceModel.NAME;
                } else {
                    cell.textField.text = @"";
                }
                return cell;
            }
                
            default:
                return nil;
        }
    } else {
        ECAddCardConfirmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECAddCardConfirmCell)
                                                                               forIndexPath:indexPath];
        [cell setClickConfirmBtn:^{
            [weakSelf confirmAction];
        }];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 2:
            {
                //选择银行
                ECBankListViewController *vc = [[ECBankListViewController alloc] init];
                [vc setDidSelectBank:^(ECBankListModel *model) {
                    weakSelf.bankModel = model;
                    [weakSelf.collectionView reloadData];
                }];
                [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择银行"];
            }
                break;
            case 3:
            {
                //选择城市
                ECSelectCityViewController *vc = [[ECSelectCityViewController alloc] init];
                [SELF_BASENAVI pushViewController:vc animated:YES titleLabel:@"选择城市"];
                [vc setSelectCityBlock:^(ECCityModel *provinceModel, ECCityModel *cityModel) {
                    weakSelf.provinceModel = provinceModel;
                    weakSelf.cityModel = cityModel;
                    [weakSelf.collectionView reloadData];
                }];
            }
                break;
                
            default:
                break;
        }
    }
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
