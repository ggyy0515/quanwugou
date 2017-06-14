//
//  ECUserInfoEditViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEditViewController.h"
#import "ECUserInfoEditHeadImageTableViewCell.h"
#import "ECDesignerRegisterTableViewCell.h"
#import "ECUserInfoModel.h"

#import "ECSelectCityViewController.h"
#import "ECUserInfoEditDesignerViewController.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECUserInfoEditViewController ()

@property (strong,nonatomic) UIButton *saveBtn;

@property (strong,nonatomic) UIButton *editDesignerBtn;

@property (strong,nonatomic) NSArray *nameArray;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;
//头像
@property (strong,nonatomic) UIImage *iconImage;
//普通用户资料
@property (strong,nonatomic) ECEditUserInfoModel *model;

@end

@implementation ECUserInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self requestUserInfo];
}

- (void)createData{
    self.view.backgroundColor = BaseColor;
    _nameArray = @[@[@"昵称",@"必填"],
                   @[@"性别",@"选填"],
                   @[@"生日",@"选填"],
                   @[@"籍贯",@"选填"],
                   @[@"邮箱",@"选填"]
                   ];
}

- (void)createUI{
    WEAK_SELF
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = FONT_32;
    [_saveBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        if (weakSelf.model.NAME.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
            return ;
        }
        if (weakSelf.model.NAME.length > 12) {
            [SVProgressHUD showInfoWithStatus:@"昵称长度请不要大于12位"];
            return ;
        }
        if (weakSelf.iconImage == nil) {
            [weakSelf requestSaveUserInfo];
        }else{
            [weakSelf requestUploadIcoImageSucceed:^(NSArray *pathArr) {
                weakSelf.model.TITLE_IMG = pathArr[0][@"path"];
                [weakSelf requestSaveUserInfo];
            }];
        }
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_saveBtn];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.scrollEnabled = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0.f);
        make.height.mas_equalTo(weakSelf.nameArray.count * 52.f + 82.f + 24.f);
    }];
    
    if (!_editDesignerBtn) {
        _editDesignerBtn = [UIButton new];
    }
    [_editDesignerBtn setTitle:@"编辑设计师资料" forState:UIControlStateNormal];
    [_editDesignerBtn setTitleColor:LightMoreColor forState:UIControlStateNormal];
    _editDesignerBtn.titleLabel.font = FONT_32;
    _editDesignerBtn.layer.borderColor = LineDefaultsColor.CGColor;
    _editDesignerBtn.layer.borderWidth = 0.5f;
    _editDesignerBtn.layer.cornerRadius = 5.f;
    _editDesignerBtn.layer.masksToBounds = YES;
    _editDesignerBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_editDesignerBtn];
    [_editDesignerBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        ECUserInfoEditDesignerViewController *editDesignerVC = [[ECUserInfoEditDesignerViewController alloc] init];
        [WEAKSELF_BASENAVI pushViewController:editDesignerVC animated:YES titleLabel:@"编辑设计师资料"];
    }];
    
    [_editDesignerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.mas_equalTo(weakSelf.tableView.mas_bottom).offset(20.f);
        make.height.mas_equalTo(49.f);
    }];
}

- (void)requestUserInfo{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestSelectUserInfoWithUserID:[Keychain objectForKey:EC_USER_ID] succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            weakSelf.model = [ECEditUserInfoModel yy_modelWithDictionary:result[@"user"]];
            weakSelf.editDesignerBtn.hidden = weakSelf.model.RIGHTS.integerValue != 2;
            [weakSelf.tableView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestUploadIcoImageSucceed:(void(^)(NSArray *pathArr))succeed{
    SHOWSVP
    [ECHTTPServer requestUploadFileWithFilesData:@[[CMPublicMethod getFitImageWithImage:self.iconImage]] succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            succeed(result[@"results"]);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestSaveUserInfo{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestUpdateUserInfoWithUserInfoID:self.model.USERINFO_ID
                                        WithHeadImage:self.model.TITLE_IMG
                                            WithBirth:self.model.BIRTH
                                              WithSex:self.model.SEX
                                             WithName:self.model.NAME
                                          WithAddress:self.model.NATIVEPLACE
                                            WithEmail:self.model.EMAIL
                                              succeed:^(NSURLSessionDataTask *task, id result) {
                                                  RequestSuccess(result)
                                                  if (IS_REQUEST_SUCCEED(result)) {
                                                      POST_NOTIFICATION(NOTIFICATION_USER_UPDATE_USERINFO, nil);
                                                      [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
                                                  }
                                              } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                  RequestFailure
                                              }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            ECUserInfoEditHeadImageTableViewCell *cell = [ECUserInfoEditHeadImageTableViewCell cellWithTableView:tableView];
            //优先选择的照片
            if (self.iconImage == nil && self.model.TITLE_IMG.length != 0) {//&& self.model.headImgUrl.length != 0
                cell.iconImageUrl = self.model.TITLE_IMG;
            }else{
                cell.iconImage = self.iconImage;
            }
            return cell;
        }
            break;
        default:{
            ECDesignerRegisterTableViewCell *cell = [ECDesignerRegisterTableViewCell cellWithTableView:tableView];
            cell.indexpath = indexPath;
            [cell setName:self.nameArray[indexPath.row][0] WithPlaceholder:self.nameArray[indexPath.row][1]];
            cell.isInput = YES;
            cell.keyboardType = -1;
            switch (indexPath.row) {
                case 0:{
                    cell.dataStr = self.model.NAME;
                }
                    break;
                case 1:{
                    cell.keyboardType = 0;
                    cell.dataStr = self.model.SEX;
                }
                    break;
                case 2:{
                    cell.keyboardType = 1;
                    cell.dataStr = self.model.BIRTH;
                }
                    break;
                case 3:{
                    cell.isInput = NO;
                    cell.dataStr = self.model.NATIVEPLACE;
                }
                    break;
                case 4:{
                    cell.dataStr = self.model.EMAIL;
                }
                    break;
            }
            [cell setChangeDataBlock:^(NSIndexPath *indexpath,NSString *text) {
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.model.NAME = text;
                    }
                        break;
                    case 1:{
                        weakSelf.model.SEX = text;
                    }
                        break;
                    case 2:{
                        weakSelf.model.BIRTH = text;
                    }
                        break;
                    case 3:{
                    }
                        break;
                    case 4:{
                        weakSelf.model.EMAIL = text;
                    }
                        break;
                }
            }];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 82.f;
        }
            break;
        default:{
            return 52.f;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            self.actionSheet = [[ZLPhotoActionSheet alloc] init];
            self.actionSheet.maxSelectCount = 1;
            [self.actionSheet showWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                weakSelf.iconImage = selectPhotos.firstObject;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
        default:{
            if (indexPath.row == 3) {
                ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
                [WEAKSELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
                [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
                    if (detailModel == nil) {
                        weakSelf.model.NATIVEPLACE = model.NAME;
                    }else{
                        weakSelf.model.NATIVEPLACE = [NSString stringWithFormat:@"%@%@",model.NAME,model.NAME];
                    }
                    [weakSelf.tableView reloadData];
                }];
            }
        }
            break;
    }
}

@end
