//
//  ECDesignRegisterInfoViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/29.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignRegisterInfoViewController.h"
#import "ECDesignerRegiserUserImageTableViewCell.h"
#import "ECDesignerRegisterTitleTableViewCell.h"
#import "ECDesignerRegisterJobCourseTableViewCell.h"
#import "ECDesignerRegisterAddImageTableViewCell.h"
#import "ECDesignerRegisterImageTableViewCell.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECDesignRegisterInfoViewController ()

@property (strong,nonatomic) UIButton *sumbitBtn;

@property (strong,nonatomic) UITextView *getHeightTextView;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@end

@implementation ECDesignRegisterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI{
    WEAK_SELF
    if (!_sumbitBtn) {
        _sumbitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 80.f, 44.f)];
    }
    [_sumbitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_sumbitBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _sumbitBtn.titleLabel.font = FONT_32;
    [_sumbitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        //判断是否填写所有信息
        if (weakSelf.model.iconImage == nil && weakSelf.model.headImgUrl.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请选择展示照片"];
            return ;
        }
        if (weakSelf.model.introduceArray.count == 1 && ((NSString *)(weakSelf.model.introduceArray.firstObject[@"content"])).length == 0) {
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
            [weakSelf requestRegisterDesigner];
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

- (void)requestRegisterDesigner{
    WEAK_SELF
    [ECHTTPServer requestApplyDesingerWithUserID:self.model.userid
                                        WithName:self.model.name
                                         WithSex:self.model.sex
                                       WithBirth:self.model.birth
                                    WithProvince:self.model.province
                                        WithCity:self.model.city
                                 WithNativeplace:self.model.nativeplace
                                  WithProfession:self.model.profession
                                      WithSchool:self.model.school
                                       WithEmail:self.model.email
                                       WithPhone:self.model.phone
                                     WithCompany:self.model.company
                                 WithObtainyears:self.model.obtainyears
                                      WithCharge:self.model.charge
                                       WithStyle:self.model.style
                                      WithResume:self.model.resume
                                  WithExperience:self.model.experience
                                  WithHeadImgUrl:self.model.headImgUrl
                          WithCertificateImgUrls:self.model.certificateImgUrls succeed:^(NSURLSessionDataTask *task, id result) {
                              if (IS_REQUEST_SUCCEED(result)) {
                                  POST_NOTIFICATION(NOTIFICATION_USER_DESIGNER_REGISTER, nil);
                                  [SVProgressHUD showSuccessWithStatus:@"申请成功，请耐心等待审核！"];
                                  [WEAKSELF_BASENAVI popToViewController:WEAKSELF_BASENAVI.viewControllers[WEAKSELF_BASENAVI.viewControllers.count - 3] animated:YES];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 1;
        }
            break;
        case 1:{
            return 2 + self.model.introduceArray.count;
        }
            break;
        case 2:{
            return 2;
        }
            break;
        case 3:{
            return 2 + self.model.certificateArray.count;
        }
            break;
        default:
            return 0;
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
        case 2:{
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
        case 3:{
            if (indexPath.row == 0) {
                ECDesignerRegisterTitleTableViewCell *cell = [ECDesignerRegisterTitleTableViewCell cellWithTableView:tableView];
                cell.title = @"证件与证书";
                cell.detailTitle = @"(选填，用于审核，不会展示)";
                return cell;
            }else if (indexPath.row == (self.model.certificateArray.count + 1)){
                ECDesignerRegisterAddImageTableViewCell *cell = [ECDesignerRegisterAddImageTableViewCell cellWithTableView:tableView];
                [cell setAddImageBlock:^{
                    weakSelf.actionSheet = [[ZLPhotoActionSheet alloc] init];
                    weakSelf.actionSheet.maxSelectCount = 99;
                    [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                        [weakSelf.model.certificateArray addObjectsFromArray:selectPhotos];
                        for (NSInteger index = 0; index < selectPhotos.count; index ++) {
                            [weakSelf.model.certificateHeightArray addObject:@(basicImageHeight)];
                            [weakSelf.model.certificateFlagArray addObject:@(NO)];
                        }
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.model.certificateArray.count inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }];
                }];
                return cell;
            }else{
                ECDesignerRegisterImageTableViewCell *cell = [ECDesignerRegisterImageTableViewCell cellWithTableView:tableView];
                [cell setGetImageSizeBlock:^(NSInteger row, CGFloat height) {
                    height = height == 0.f ? basicImageHeight : height;
                    [weakSelf.model.certificateHeightArray replaceObjectAtIndex:(row - 1) withObject:@(height)];
                    [weakSelf.model.certificateFlagArray replaceObjectAtIndex:(row - 1) withObject:@(YES)];
                    [weakSelf.tableView reloadData];
                }];
                [cell setDeleteImageBlock:^(NSInteger row) {
                    [weakSelf.model.certificateArray removeObjectAtIndex:row - 1];
                    [weakSelf.model.certificateHeightArray removeObjectAtIndex:row - 1];
                    [weakSelf.model.certificateFlagArray removeObjectAtIndex:row - 1];
                    [weakSelf.tableView reloadData];
                }];
                cell.indexpath = indexPath;
                cell.isFlag = [self.model.certificateFlagArray[indexPath.row - 1] boolValue];
                if ([self.model.certificateArray[indexPath.row - 1] isKindOfClass:[UIImage class]]) {
                    cell.iconImage = self.model.certificateArray[indexPath.row - 1];
                }else{
                    cell.iconImageUrl = self.model.certificateArray[indexPath.row - 1];
                }
                return cell;
            }
        }
            break;
        default:{
            return nil;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 72.f;
        }
            break;
        case 1:{
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
        case 2:{
            if (indexPath.row == 0) {
                return 44.f;
            }else{
                return 24.f + [self getHeightWithContent:self.model.experience];
            }
        }
            break;
        case 3:{
            if (indexPath.row == 0) {
                return 44.f;
            }else if (indexPath.row == (self.model.certificateArray.count + 1)){
                return 84.f;
            }else{
                return [self.model.certificateHeightArray[indexPath.row - 1] floatValue] + 24.f;
            }
        }
            break;
        default:{
            return 0.f;
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
                weakSelf.model.iconImage = selectPhotos.firstObject;
                [weakSelf.tableView reloadData];
            }];
        }
            break;
    }
}

@end
