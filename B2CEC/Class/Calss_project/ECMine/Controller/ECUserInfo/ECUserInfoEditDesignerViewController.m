//
//  ECUserInfoEditDesignerViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECUserInfoEditDesignerViewController.h"
#import "ECDesignerRegiserUserImageTableViewCell.h"
#import "ECDesignerRegisterTitleTableViewCell.h"
#import "ECDesignerRegisterJobCourseTableViewCell.h"
#import "ECDesignerRegisterAddImageTableViewCell.h"
#import "ECDesignerRegisterImageTableViewCell.h"
#import "ECDesignerRegisterTableViewCell.h"
#import "ECDesignerRegisterModel.h"

#import "ECSelectCityViewController.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECUserInfoEditDesignerViewController ()

@property (strong,nonatomic) UIButton *sumbitBtn;

@property (strong,nonatomic) UITextView *getHeightTextView;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@property (strong,nonatomic) NSArray *infoArray;

@property (strong,nonatomic) NSArray *phoneArray;

@property (strong,nonatomic) ECDesignerRegisterModel *model;

@end

@implementation ECUserInfoEditDesignerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArray = @[@[@"姓名",@"必填"],
                   @[@"现居",@"必填"],
                   @[@"职业",@"必填"],
                   @[@"毕业院校",@"必填"],
                   @[@"从业年限",@"必填"],
                   @[@"收费标准",@"￥/m²"],
                   @[@"擅长风格",@"必填"]
                   ];
    _phoneArray = @[@[@"手机",@"必填"],@[@"所属公司",@"选填"]];
    [self addBasicData];
    [self createUI];
    [self requestGetDesignerInfo];
}

- (void)createUI{
    WEAK_SELF
    if (!_sumbitBtn) {
        _sumbitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 44.f)];
    }
    [_sumbitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_sumbitBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _sumbitBtn.titleLabel.font = FONT_32;
    [_sumbitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        //判断是否填写所有信息
        if (weakSelf.model.iconImage == nil && weakSelf.model.headImgUrl.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择展示照片"];
            return ;
        }
        //判断必填项是否完整
        if (weakSelf.model.name.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        if (weakSelf.model.province.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择现居地"];
            return ;
        }
        if (weakSelf.model.name.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入姓名"];
            return ;
        }
        if (weakSelf.model.profession.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入职业"];
            return ;
        }
        if (weakSelf.model.school.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入毕业院校"];
            return ;
        }
        if (weakSelf.model.obtainyears.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入从业年限"];
            return ;
        }
        if (weakSelf.model.charge.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入收费标准"];
            return ;
        }
        if (weakSelf.model.type.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择擅长风格"];
            return ;
        }
        if (weakSelf.model.phone.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号码"];
            return ;
        }
        if (self.model.introduceArray.count == 1 && ((NSString *)self.model.introduceArray.firstObject).length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入个人介绍"];
            return ;
        }
        //上传头像
        SHOWSVP
        [weakSelf requestUploadImageListSucceed:^(NSArray *pathArr) {
            //头像图片
            NSInteger index = 0;
            if (weakSelf.model.iconImage != nil) {
                index ++;
                weakSelf.model.headImgUrl = pathArr[0][@"path"];
            }
            //分离个人介绍图片与文字
            NSMutableArray *introArray = [NSMutableArray new];
            for (NSInteger page = 0; page < weakSelf.model.introduceArray.count; page ++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:weakSelf.model.introduceArray[page]];
                if ([dict[@"content"] isKindOfClass:[NSString class]]) {
                    [introArray addObject:dict];
                }else{
                    [dict setValue:pathArr[index][@"path"] forKey:@"content"];
                    [introArray addObject:dict];
                    index ++;
                }
            }
            weakSelf.model.resume = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:introArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            //分离证书图片
            NSMutableArray *cerArray = [NSMutableArray new];
            for (NSInteger page = 0; page < weakSelf.model.certificateArray.count; page ++) {
                id data = weakSelf.model.certificateArray[page];
                if ([data isKindOfClass:[NSString class]]) {
                    [cerArray addObject:data];
                }else{
                    [cerArray addObject:pathArr[index][@"path"]];
                    index ++;
                }
            }
            weakSelf.model.certificateImgUrls = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:cerArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            //先发起上传文件请求
            [ECHTTPServer requestApplyDesingerWithUserID:weakSelf.model.userid
                                                WithName:weakSelf.model.name
                                                 WithSex:weakSelf.model.sex
                                               WithBirth:weakSelf.model.birth
                                            WithProvince:weakSelf.model.province
                                                WithCity:weakSelf.model.city
                                         WithNativeplace:weakSelf.model.nativeplace
                                          WithProfession:weakSelf.model.profession
                                              WithSchool:weakSelf.model.school
                                               WithEmail:weakSelf.model.email
                                               WithPhone:weakSelf.model.phone
                                             WithCompany:weakSelf.model.company
                                         WithObtainyears:weakSelf.model.obtainyears
                                              WithCharge:weakSelf.model.charge
                                               WithStyle:weakSelf.model.style
                                              WithResume:weakSelf.model.resume
                                          WithExperience:weakSelf.model.experience
                                          WithHeadImgUrl:weakSelf.model.headImgUrl
                                  WithCertificateImgUrls:weakSelf.model.certificateImgUrls succeed:^(NSURLSessionDataTask *task, id result) {
                                      if (IS_REQUEST_SUCCEED(result)) {
                                          [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                                          POST_NOTIFICATION(NOTIFICATION_USER_DESIGNER_REGISTER, nil);
                                          [WEAKSELF_BASENAVI popToViewController:WEAKSELF_BASENAVI.viewControllers[WEAKSELF_BASENAVI.viewControllers.count - 3] animated:YES];
                                      }else{
                                          RequestError
                                      }
                                  } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                      RequestFailure
                                  }];
        }];
        
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_sumbitBtn];
    
    if (!_getHeightTextView) {
        _getHeightTextView = [UITextView new];
    }
    _getHeightTextView.font = FONT_32;
    _getHeightTextView.hidden = YES;
    [self.view addSubview:_getHeightTextView];
    [_getHeightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.top.bottom.mas_equalTo(0.f);
    }];
    
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (void)requestGetDesignerInfo{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestGetDesignersucceed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            weakSelf.model = [ECDesignerRegisterModel yy_modelWithDictionary:result[@"designerInfo"]];
            [weakSelf addBasicData];
            [weakSelf.tableView reloadData];
            NSLog(@"result : %@",result);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)addBasicData{
    self.model.iconImage = nil;
    self.model.introduceArray = [NSMutableArray new];
    self.model.introduceHeightArray = [NSMutableArray new];
    self.model.introduceFlagArray = [NSMutableArray new];
    self.model.certificateArray = [NSMutableArray new];
    self.model.certificateHeightArray = [NSMutableArray new];
    self.model.certificateFlagArray = [NSMutableArray new];
    
    if (self.model.resume.length == 0) {
        [self.model.introduceArray addObject:@{@"content":@"",@"type":@"0"}];
    }else{
        [self.model.introduceArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:[self.model.resume dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil]];
    }
    for (NSDictionary *dict in self.model.introduceArray) {
        if ([dict[@"type"] integerValue] == 0) {
            [self.model.introduceHeightArray addObject:@(basicTextHeight)];
        }else{
            [self.model.introduceHeightArray addObject:@(basicImageHeight)];
        }
        [self.model.introduceFlagArray addObject:@(NO)];
    }
    if (self.model.certificateImgUrls.length != 0) {
        [self.model.certificateArray addObjectsFromArray:[NSJSONSerialization JSONObjectWithData:[self.model.certificateImgUrls dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil]];
    }
    for (NSInteger index = 0; index < self.model.certificateArray.count; index ++) {
        [self.model.certificateHeightArray addObject:@(basicImageHeight)];
        [self.model.certificateFlagArray addObject:@(NO)];
    }
}

- (void)requestUploadImageListSucceed:(void(^)(NSArray *pathArr))succeed{
    NSMutableArray *dataArray = [NSMutableArray new];
    //加入头像图片
    if (self.model.iconImage != nil) {
        [dataArray addObject:[CMPublicMethod getFitImageWithImage:self.model.iconImage]];
    }
    //加入个人介绍图片
    for (NSDictionary *dict in self.model.introduceArray) {
        if ([dict[@"type"] integerValue] == 1 && [dict[@"content"] isKindOfClass:[UIImage class]]) {
            [dataArray addObject:[CMPublicMethod getFitImageWithImage:dict[@"content"]]];
        }
    }
    //加入证书图片
    for (id data in self.model.certificateArray) {
        if ([data isKindOfClass:[UIImage class]]) {
            [dataArray addObject:[CMPublicMethod getFitImageWithImage:data]];
        }
    }
    //判断图片数组是否为空，如果为空则直接返回
    if (dataArray.count == 0) {
        succeed(dataArray);
        return;
    }
    //发起上传请求
    [ECHTTPServer requestUploadFileWithFilesData:dataArray succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            succeed(result[@"results"]);
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (CGFloat)getHeightWithContent:(NSString *)content{
    _getHeightTextView.text = content;
    CGFloat height = fmaxf([_getHeightTextView sizeThatFits:CGSizeMake((SCREENWIDTH - 24.f), MAXFLOAT)].height, 64.f);
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return _infoArray.count;
        }
            break;
        case 2:{
            return _phoneArray.count;
        }
            break;
        case 3:{
            return 2 + self.model.introduceArray.count;
        }
            break;
        default:
            return 2;
            break;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            ECDesignerRegiserUserImageTableViewCell *cell = [ECDesignerRegiserUserImageTableViewCell cellWithTableView:tableView];
            //优先选择的照片
            if (self.model.iconImage == nil && self.model.headImgUrl.length != 0) {
                cell.iconImageUrl = self.model.headImgUrl;
            }else{
                cell.iconImage = self.model.iconImage;
            }
            return cell;
        }
            break;
        case 1:{
            ECDesignerRegisterTableViewCell *cell = [ECDesignerRegisterTableViewCell cellWithTableView:tableView];
            cell.indexpath = indexPath;
            [cell setName:self.infoArray[indexPath.row][0] WithPlaceholder:self.infoArray[indexPath.row][1]];
            cell.isInput = YES;
            cell.keyboardType = -1;
            switch (indexPath.row) {
                case 0:{
                    cell.dataStr = self.model.name;
                }
                    break;
                case 1:{
                    cell.isInput = NO;
                    cell.dataStr = self.model.nativeplace;
                }
                    break;
                case 2:{
                    cell.dataStr = self.model.profession;
                }
                    break;
                case 3:{
                    cell.dataStr = self.model.school;
                }
                    break;
                case 4:{
                    cell.keyboardType = 3;
                    cell.dataStr = self.model.obtainyears;
                }
                    break;
                case 5:{
                    cell.keyboardType = 3;
                    cell.dataStr = self.model.charge;
                }
                    break;
                case 6:{
                    cell.keyboardType = 4;
                    cell.dataStr = self.model.type;
                }
                    break;
            }
            [cell setChangeDataBlock:^(NSIndexPath *indexpath,NSString *text) {
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.model.name = text;
                    }
                        break;
                    case 1:{
                    }
                        break;
                    case 2:{
                        weakSelf.model.profession = text;
                    }
                        break;
                    case 3:{
                        weakSelf.model.school = text;
                    }
                        break;
                    case 4:{
                        weakSelf.model.obtainyears = text;
                    }
                        break;
                    case 5:{
                        weakSelf.model.charge = text;
                    }
                        break;
                    case 6:{
                        weakSelf.model.type = text;
                    }
                        break;
                }
            }];
            [cell setChangeStyleBlock:^(NSIndexPath *indexpath,NSString *name,NSString *bianma) {
                if (indexpath.section == 1 && indexpath.row == 6) {
                    weakSelf.model.type = name;
                    weakSelf.model.style = bianma;
                }
            }];
            return cell;
        }
            break;
        case 2:{
            ECDesignerRegisterTableViewCell *cell = [ECDesignerRegisterTableViewCell cellWithTableView:tableView];
            cell.indexpath = indexPath;
            [cell setName:self.phoneArray[indexPath.row][0] WithPlaceholder:self.phoneArray[indexPath.row][1]];
            cell.isInput = YES;
            cell.keyboardType = -1;
            switch (indexPath.row) {
                case 0:{
                    cell.dataStr = self.model.phone;
                    cell.keyboardType = 2;
                }
                    break;
                default:{
                    cell.dataStr = self.model.company;
                }
                    break;
            }
            [cell setChangeDataBlock:^(NSIndexPath *indexpath,NSString *text) {
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.model.phone = text;
                    }
                        break;
                    default:{
                        weakSelf.model.company = text;
                    }
                        break;
                }
            }];
            return cell;
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                ECDesignerRegisterTitleTableViewCell *cell = [ECDesignerRegisterTitleTableViewCell cellWithTableView:tableView];
                cell.title = @"个人介绍";
                cell.detailTitle = @"";
                return cell;
            }else if (indexPath.row == (self.model.introduceArray.count + 1)){
                ECDesignerRegisterAddImageTableViewCell *cell = [ECDesignerRegisterAddImageTableViewCell cellWithTableView:tableView];
                [cell setAddImageBlock:^{
                    weakSelf.actionSheet = [[ZLPhotoActionSheet alloc] init];
                    weakSelf.actionSheet.maxSelectCount = 99;
                    [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                        //先判断数组上一个元素是不是空字符串
                        NSDictionary *dict = weakSelf.model.introduceArray.lastObject;
                        if (weakSelf.model.introduceArray.count != 1 &&
                            [dict[@"type"] integerValue] == 0 &&
                            ((NSString *)dict[@"content"]).length == 0) {
                            [weakSelf.model.introduceArray removeLastObject];
                            [weakSelf.model.introduceHeightArray removeLastObject];
                            [weakSelf.model.introduceFlagArray removeLastObject];
                        }
                        
                        for (UIImage *image in selectPhotos) {
                            [weakSelf.model.introduceArray addObject:@{@"content":image,@"type":@"1"}];
                            [weakSelf.model.introduceHeightArray addObject:@(basicImageHeight)];
                            [weakSelf.model.introduceFlagArray addObject:@(NO)];
                        }
                        [weakSelf.model.introduceArray addObject:@{@"content":@"",@"type":@"0"}];
                        [weakSelf.model.introduceHeightArray addObject:@(basicTextHeight)];
                        [weakSelf.model.introduceFlagArray addObject:@(NO)];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.model.introduceArray.count inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }];
                }];
                return cell;
            }else{
                NSDictionary *dict = self.model.introduceArray[indexPath.row - 1];
                if ([dict[@"type"] integerValue] == 0) {
                    ECDesignerRegisterJobCourseTableViewCell *cell = [ECDesignerRegisterJobCourseTableViewCell cellWithTableView:tableView];
                    cell.placepolder = @"请输入个人介绍";
                    cell.content = dict[@"content"];
                    [cell setCourseTextChangeBlock:^(NSString *course) {
                        NSDictionary *replaceDict = @{@"content":course,@"type":@"0"};
                        [weakSelf.model.introduceArray replaceObjectAtIndex:(indexPath.row - 1) withObject:replaceDict];
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.tableView endUpdates];
                    }];
                    return cell;
                }else{
                    ECDesignerRegisterImageTableViewCell *cell = [ECDesignerRegisterImageTableViewCell cellWithTableView:tableView];
                    [cell setGetImageSizeBlock:^(NSInteger row, CGFloat height) {
                        height = height == 0.f ? basicImageHeight : height;
                        [weakSelf.model.introduceHeightArray replaceObjectAtIndex:(row - 1) withObject:@(height)];
                        [weakSelf.model.introduceFlagArray replaceObjectAtIndex:(row - 1) withObject:@(YES)];
                        [weakSelf.tableView reloadData];
                    }];
                    [cell setDeleteImageBlock:^(NSInteger row) {
                        [weakSelf.model.introduceArray removeObjectAtIndex:row - 1];
                        [weakSelf.model.introduceHeightArray removeObjectAtIndex:row - 1];
                        [weakSelf.model.introduceFlagArray removeObjectAtIndex:row - 1];
                        //判断最后当前删除的下一位是否是空白输入栏，并且上一位是否文字输入栏，如果是，则删除
                        NSDictionary *dict1 = [weakSelf.model.introduceArray objectAtIndexWithCheck:row - 1];
                        NSDictionary *dict2 = [weakSelf.model.introduceArray objectAtIndexWithCheck:row - 2];
                        if ([dict1[@"type"] integerValue] == 0 &&
                            [dict2[@"type"] integerValue] == 0 &&
                            ((NSString *)dict1[@"content"]).length == 0) {
                            [weakSelf.model.introduceArray removeObjectAtIndex:row - 1];
                            [weakSelf.model.introduceHeightArray removeObjectAtIndex:row - 1];
                            [weakSelf.model.introduceFlagArray removeObjectAtIndex:row - 1];
                        }
                        [weakSelf.tableView reloadData];
                    }];
                    cell.indexpath = indexPath;
                    cell.isFlag = [self.model.introduceFlagArray[indexPath.row - 1] boolValue];
                    if ([dict[@"content"] isKindOfClass:[NSString class]]) {
                        cell.iconImageUrl = dict[@"content"];
                    }else{
                        cell.iconImage = (UIImage *)dict[@"content"];
                    }
                    
                    return cell;
                }
            }
        }
            break;
        default:{
            if (indexPath.row == 0) {
                ECDesignerRegisterTitleTableViewCell *cell = [ECDesignerRegisterTitleTableViewCell cellWithTableView:tableView];
                cell.title = @"职业历程";
                cell.detailTitle = @"";
                return cell;
            }else{
                ECDesignerRegisterJobCourseTableViewCell *cell = [ECDesignerRegisterJobCourseTableViewCell cellWithTableView:tableView];
                cell.placepolder = @"请描述您的职业历程";
                cell.content = self.model.experience;
                [cell setCourseTextChangeBlock:^(NSString *course) {
                    weakSelf.model.experience = course;
                    [weakSelf.tableView beginUpdates];
                    [weakSelf.tableView endUpdates];
                }];
                return cell;
            }
        }
            break;
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 72.f;
        }
            break;
        case 1:
        case 2:{
            return 52.f;
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                return 44.f;
            }else if (indexPath.row == (self.model.introduceArray.count + 1)){
                return 84.f;
            }else{
                NSDictionary *dict = self.model.introduceArray[indexPath.row - 1];
                if ([dict[@"type"] integerValue] == 0) {
                    return 24.f + [self getHeightWithContent:dict[@"content"]];
                }else{
                    return [self.model.introduceHeightArray[indexPath.row - 1] floatValue] + 24.f;
                }
            }
        }
            break;
        default:{
            if (indexPath.row == 0) {
                return 44.f;
            }else{
                return 24.f + [self getHeightWithContent:self.model.experience];
            }
        }
            break;
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    if (indexPath.section == 1 && indexPath.row == 1) {
        ECSelectCityViewController *selectCityVC = [[ECSelectCityViewController alloc] init];
        [SELF_BASENAVI pushViewController:selectCityVC animated:YES titleLabel:@"选择城市"];
        [selectCityVC setSelectCityBlock:^(ECCityModel *model, ECCityModel *detailModel) {
            if (detailModel == nil) {
                weakSelf.model.nativeplace = model.NAME;
            }else{
                weakSelf.model.nativeplace = [NSString stringWithFormat:@"%@%@",model.NAME,model.NAME];
            }
            [weakSelf.tableView reloadData];
        }];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        self.actionSheet = [[ZLPhotoActionSheet alloc] init];
        self.actionSheet.maxSelectCount = 1;
        [self.actionSheet showWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            weakSelf.model.iconImage = selectPhotos.firstObject;
            [weakSelf.tableView reloadData];
        }];
    }
}

@end
