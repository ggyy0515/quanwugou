//
//  ECPlaceOrderViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/20.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPlaceOrderViewController.h"

#import "ECPlaceOrderDesignerInfoTableViewCell.h"
#import "ECDesignerRegisterTableViewCell.h"
#import "ECMineTitleTableViewCell.h"
#import "ECPlaceOrderSelectTableViewCell.h"
#import "ECDesignerRegisterTitleTableViewCell.h"
#import "ECDesignerRegisterJobCourseTableViewCell.h"
#import "ECPostLogsImageListTableViewCell.h"

#import "SHPhotoBorwserViewController.h"
#import "ECSelectMapPointViewController.h"

@interface ECPlaceOrderViewController ()

@property (strong,nonatomic) UIButton *submitBtn;

@property (strong,nonatomic) UITextView *getHeightTextView;

@property (strong,nonatomic) NSArray *houseNameArray;
@property (strong,nonatomic) NSArray *houseBianmaArray;
@property (assign,nonatomic) NSInteger houseCurrentIndex;

@property (strong,nonatomic) NSArray *typeNameArray;
@property (strong,nonatomic) NSArray *typeBianmaArray;
@property (assign,nonatomic) NSInteger typeCurrentIndex;

@property (strong,nonatomic) NSArray *styleNameArray;
@property (strong,nonatomic) NSArray *styleBianmaArray;
@property (assign,nonatomic) NSInteger styleCurrentIndex;

@property (strong,nonatomic) NSMutableArray *imageArray;
@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@end

@implementation ECPlaceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    self.houseCurrentIndex = 0;
    self.typeCurrentIndex = 0;
    self.styleCurrentIndex = 0;
    
    self.imageArray = [NSMutableArray new];
    [self.imageArray addObjectsFromArray:self.orderModel.imgurls];
    
    WEAK_SELF
    
    self.orderModel.user_id = [Keychain objectForKey:EC_USER_ID];
    NSMutableArray *nameArray = [NSMutableArray new];
    NSMutableArray *bianmaArray = [NSMutableArray new];
    
    for (NSInteger index = 0; index < [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasetype.count; index ++) {
        CMWorksTypeModel *model = [[CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasetype objectAtIndexWithCheck:index];
        [nameArray addObject:model.NAME];
        [bianmaArray addObject:model.BIANMA];
        
        if (weakSelf.orderModel.housetype == nil) {
            if (index == 0) {
                weakSelf.orderModel.housename = model.NAME;
                weakSelf.orderModel.housetype = model.BIANMA;
            }
        }else{
            if ([model.NAME isEqualToString:weakSelf.orderModel.housetype]) {
                weakSelf.orderModel.housename = model.NAME;
                weakSelf.orderModel.housetype = model.BIANMA;
                weakSelf.houseCurrentIndex = index;
            }
        }
    }
    self.houseNameArray = nameArray.mutableCopy;
    self.houseBianmaArray = bianmaArray.mutableCopy;
    
    [nameArray removeAllObjects];
    [bianmaArray removeAllObjects];
    for (NSInteger index = 0; index < [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allhousetype.count; index ++) {
        CMWorksTypeModel *model = [[CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allhousetype objectAtIndexWithCheck:index];
        [nameArray addObject:model.NAME];
        [bianmaArray addObject:model.BIANMA];
        
        if (weakSelf.orderModel.decoratetype == nil) {
            if (index == 0) {
                weakSelf.orderModel.decoratename = model.NAME;
                weakSelf.orderModel.decoratetype = model.BIANMA;
            }
        }else{
            if ([model.NAME isEqualToString:weakSelf.orderModel.decoratetype]) {
                weakSelf.orderModel.decoratename = model.NAME;
                weakSelf.orderModel.decoratetype = model.BIANMA;
                weakSelf.typeCurrentIndex = index;
            }
        }
    }
    self.typeNameArray = nameArray.mutableCopy;
    self.typeBianmaArray = bianmaArray.mutableCopy;
    
    [nameArray removeAllObjects];
    [bianmaArray removeAllObjects];
    for (NSInteger index = 0; index < [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle.count; index ++) {
        CMWorksTypeModel *model = [[CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle objectAtIndexWithCheck:index];
        [nameArray addObject:model.NAME];
        [bianmaArray addObject:model.BIANMA];
        
        if (weakSelf.orderModel.style == nil) {
            if (index == 0) {
                weakSelf.orderModel.stylename = model.NAME;
                weakSelf.orderModel.style = model.BIANMA;
            }
        }else{
            if ([model.NAME isEqualToString:weakSelf.orderModel.style]) {
                weakSelf.orderModel.stylename = model.NAME;
                weakSelf.orderModel.style = model.BIANMA;
                weakSelf.styleCurrentIndex = index;
            }
        }
    }
    self.styleNameArray = nameArray.mutableCopy;
    self.styleBianmaArray = bianmaArray.mutableCopy;
}

- (void)createUI{
    WEAK_SELF
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = FONT_32;
    [_submitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        //
        if (weakSelf.orderModel.describe.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入简洁描述"];
            return ;
        }
        if (weakSelf.orderModel.housearea.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入房屋面积"];
            return ;
        }
        if (weakSelf.orderModel.location.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择地址"];
            return ;
        }
        if (weakSelf.orderModel.claim.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入具体要求"];
            return ;
        }
        if (weakSelf.orderModel.cycle.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入预计天数"];
            return ;
        }
        SHOWSVP
        [weakSelf requestUploadImageListSucceed:^(NSArray *pathArr) {
            NSMutableArray *cerArray = [NSMutableArray new];
            NSInteger index = 0;
            for (NSInteger page = 0; page < weakSelf.imageArray.count; page ++) {
                id data = [weakSelf.imageArray objectAtIndexWithCheck:page];
                if ([data isKindOfClass:[UIImage class]]) {
                    [cerArray addObject:pathArr[index][@"path"]];
                    index ++;
                }else{
                    [cerArray addObject:data];
                }
            }
            weakSelf.orderModel.imgurls = cerArray;
            if (weakSelf.isUpdate) {
                [weakSelf requestUpdateDesignerOrder];
            }else{
                [weakSelf requestPostDesignerOrder];
            }
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_submitBtn];
    
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

- (CGFloat)getHeightWithContent:(NSString *)content{
    _getHeightTextView.text = content;
    CGFloat height = fmaxf([_getHeightTextView sizeThatFits:CGSizeMake((SCREENWIDTH - 24.f), MAXFLOAT)].height, 64.f);
    return height;
}

- (void)requestGetAddress{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestGetAddressByLatWithLat:self.orderModel.lat WithLng:self.orderModel.lng succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            weakSelf.orderModel.location = result[@"location"];
        }else{
            weakSelf.orderModel.lat = 0.f;
            weakSelf.orderModel.lng = 0.f;
            weakSelf.orderModel.location = @"";
            [SVProgressHUD showErrorWithStatus:@"获取位置失败，请重新选择地址"];
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        weakSelf.orderModel.lat = 0.f;
        weakSelf.orderModel.lng = 0.f;
        weakSelf.orderModel.location = @"";
        [weakSelf.tableView reloadData];
        [SVProgressHUD showErrorWithStatus:@"获取位置失败，请重新选择地址"];
    }];
}

- (void)requestUploadImageListSucceed:(void(^)(NSArray *pathArr))succeed{
    NSMutableArray *dataArray = [NSMutableArray new];
    //加入证书图片
    for (id data in self.imageArray) {
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

- (void)requestPostDesignerOrder{
    WEAK_SELF
    [ECHTTPServer requestPostDesignerOrderWithdesigner_id:self.orderModel.designer_id
                                                  user_id:self.orderModel.user_id
                                                 describe:self.orderModel.describe
                                                housearea:self.orderModel.housearea
                                                 location:self.orderModel.location
                                                      lng:self.orderModel.lng
                                                      lat:self.orderModel.lat
                                                housetype:self.orderModel.housetype
                                             decoratetype:self.orderModel.decoratetype
                                                    style:self.orderModel.style
                                                    claim:self.orderModel.claim
                                                  imgurls:self.orderModel.imgurls.count == 0 ? @"" : [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.orderModel.imgurls options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
                                                    cycle:self.orderModel.cycle succeed:^(NSURLSessionDataTask *task, id result) {
                                                        if (IS_REQUEST_SUCCEED(result)) {
                                                            [SVProgressHUD showSuccessWithStatus:@"下订单成功"];
                                                            [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
                                                        }else{
                                                            RequestSuccess(result)
                                                        }
                                                    } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                        RequestFailure
                                                    }];
}

- (void)requestUpdateDesignerOrder{
    WEAK_SELF
    [ECHTTPServer requestUpdateDesignerOrderWithOrder_id:self.orderModel.orderID
                                                describe:self.orderModel.describe
                                               housearea:self.orderModel.housearea
                                                location:self.orderModel.location
                                                     lng:self.orderModel.lng
                                                     lat:self.orderModel.lat
                                               housetype:self.orderModel.housetype
                                            decoratetype:self.orderModel.decoratetype
                                                   style:self.orderModel.style
                                                   claim:self.orderModel.claim
                                                 imgurls:self.orderModel.imgurls.count == 0 ? @"" : [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.orderModel.imgurls options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
                                                   cycle:self.orderModel.cycle succeed:^(NSURLSessionDataTask *task, id result) {
                                                       if (IS_REQUEST_SUCCEED(result)) {
                                                           if (weakSelf.submitSuccessBlock) {
                                                               weakSelf.submitSuccessBlock();
                                                           }
                                                           [SVProgressHUD showSuccessWithStatus:@"修改订单成功"];
                                                           [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
                                                       }else{
                                                           RequestError
                                                       }
                                                   } failed:^(NSURLSessionDataTask *task, NSError *error) {
                                                       RequestFailure
                                                   }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 2:
        case 3:
        case 4:
        case 5:{
            return 1;
        }
            break;
        case 1:{
            return 3;
        }
            break;
        case 6:{
            return 3;
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.section) {
        case 0:{
            ECPlaceOrderDesignerInfoTableViewCell *cell = [ECPlaceOrderDesignerInfoTableViewCell cellWithTableView:tableView];
            cell.designerName = self.designerName;
            cell.designerTitleImage = self.designerTitleImage;
            return cell;
        }
            break;
        case 1:{
            ECDesignerRegisterTableViewCell *cell = [ECDesignerRegisterTableViewCell cellWithTableView:tableView];
            cell.indexpath = indexPath;
            cell.isInput = YES;
            cell.keyboardType = -1;
            switch (indexPath.row) {
                case 0:{
                    [cell setName:@"简洁描述" WithPlaceholder:@"例如：三室两厅全套不急"];
                    cell.dataStr = self.orderModel.describe;
                }
                    break;
                case 1:{
                    [cell setName:@"房屋面积" WithPlaceholder:@"请输入房屋面积 M²"];
                    cell.keyboardType = 3;
                    cell.dataStr = self.orderModel.housearea;
                }
                    break;
                case 2:{
                    [cell setName:@"预计天数" WithPlaceholder:@"请输入预计天数"];
                    cell.keyboardType = 3;
                    cell.dataStr = self.orderModel.cycle;
                }
                    break;
            }
            [cell setChangeDataBlock:^(NSIndexPath *indexpath,NSString *text) {
                switch (indexpath.row) {
                    case 0:{
                        weakSelf.orderModel.describe = text;
                    }
                        break;
                    case 1:{
                        weakSelf.orderModel.housearea = text;
                    }
                        break;
                    case 2:{
                        weakSelf.orderModel.cycle = text;
                    }
                        break;
                }
            }];
            return cell;
        }
            break;
        case 2:{
            ECMineTitleTableViewCell *cell = [ECMineTitleTableViewCell cellWithTableView:tableView];
            [cell setIconImage:nil WithTitle:@"选择地址"];
            cell.detailTitle = self.orderModel.location.length == 0 ? @"请选择地址" : self.orderModel.location;
            return cell;
        }
            break;
        case 3:{
            ECPlaceOrderSelectTableViewCell *cell = [ECPlaceOrderSelectTableViewCell cellWithTableView:tableView];
            cell.type = @"房屋类型";
            cell.currentIndex = self.houseCurrentIndex;
            cell.dataArray = self.houseBianmaArray;
            cell.nameArray = self.houseNameArray;
            [cell setCurrentModelBlock:^(NSString *name,NSString *bianma) {
                weakSelf.orderModel.housename = name;
                weakSelf.orderModel.housetype = bianma;
            }];
            return cell;
        }
            break;
        case 4:{
            ECPlaceOrderSelectTableViewCell *cell = [ECPlaceOrderSelectTableViewCell cellWithTableView:tableView];
            cell.type = @"装修户型";
            cell.currentIndex = self.typeCurrentIndex;
            cell.dataArray = self.typeBianmaArray;
            cell.nameArray = self.typeNameArray;
            [cell setCurrentModelBlock:^(NSString *name,NSString *bianma) {
                weakSelf.orderModel.decoratename = name;
                weakSelf.orderModel.decoratetype = bianma;
            }];
            return cell;
        }
            break;
        case 5:{
            ECPlaceOrderSelectTableViewCell *cell = [ECPlaceOrderSelectTableViewCell cellWithTableView:tableView];
            cell.type = @"期望风格";
            cell.currentIndex = self.styleCurrentIndex;
            cell.dataArray = self.styleBianmaArray;
            cell.nameArray = self.styleNameArray;
            [cell setCurrentModelBlock:^(NSString *name,NSString *bianma) {
                weakSelf.orderModel.stylename = name;
                weakSelf.orderModel.style = bianma;
            }];
            return cell;
        }
            break;
        case 6:{
            switch (indexPath.row) {
                case 0:{
                    ECDesignerRegisterTitleTableViewCell *cell = [ECDesignerRegisterTitleTableViewCell cellWithTableView:tableView];
                    cell.title = @"具体要求";
                    cell.detailTitle = @"";
                    return cell;
                }
                    break;
                case 1:{
                    ECDesignerRegisterJobCourseTableViewCell *cell = [ECDesignerRegisterJobCourseTableViewCell cellWithTableView:tableView];
                    cell.placepolder = @"您的具体要求...";
                    cell.content = self.orderModel.claim;
                    [cell setCourseTextChangeBlock:^(NSString *course) {
                        weakSelf.orderModel.claim = course;
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.tableView endUpdates];
                    }];
                    return cell;
                }
                    break;
                case 2:{
                    ECPostLogsImageListTableViewCell *cell = [ECPostLogsImageListTableViewCell cellWithTableView:tableView];
                    cell.itemSize = CGSizeMake(58.f, 58.f);
                    cell.addImage = @"添加图片";
                    cell.imageArray = self.imageArray;
                    [cell setImageClickBlock:^(NSInteger index) {
                        SHPhotoBorwserViewController *borwserVC = [[SHPhotoBorwserViewController alloc] init];
                        borwserVC.imageArray = weakSelf.imageArray;
                        borwserVC.currentIndex = index;
                        borwserVC.isEdit = YES;
                        CMBaseNavigationController *browserNai = [[CMBaseNavigationController alloc] initWithRootViewController:borwserVC];
                        [APP_DELEGATE.window.rootViewController presentViewController:browserNai animated:YES completion:^{}];
                        __weak typeof(borwserVC) blockVC = borwserVC;
                        [borwserVC setBtnDoneBlock:^(NSArray *removeArray, NSInteger index) {
                            NSArray *tempArray = [weakSelf.imageArray removeObjectAtIndexArray:removeArray];
                            [weakSelf.imageArray removeAllObjects];
                            [weakSelf.imageArray addObjectsFromArray:tempArray];
                            [weakSelf.tableView reloadData];

                            blockVC.currentIndex = index;
                            [blockVC updateBorwser];
                        }];
                    }];
                    [cell setAddImageClickBlock:^{
                        if (weakSelf.imageArray.count == 9) {
                            [SVProgressHUD showInfoWithStatus:@"最多只能上传9张"];
                            return ;
                        }
                        weakSelf.actionSheet = [[ZLPhotoActionSheet alloc] init];
                        weakSelf.actionSheet.maxSelectCount = 9;
                        [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                            [weakSelf.imageArray addObjectsFromArray:selectPhotos];
                            [weakSelf.tableView reloadData];
                        }];
                    }];
                    return cell;
                }
                    break;
                default:{
                    return nil;
                }
                    break;
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
            return 60.f;
        }
            break;
        case 1:
        case 2:{
            return 44.f;
        }
            break;
        case 3:{
            NSInteger count = ceil(self.houseNameArray.count / floorf((SCREENWIDTH - 24.f) / 76.f));
            return 80.f + 25 * count + 12.f * (count - 1);
        }
            break;
        case 4:{
            NSInteger count = ceil(self.typeNameArray.count / floorf((SCREENWIDTH - 24.f) / 76.f));
            return 80.f + 25 * count + 12.f * (count - 1);
        }
            break;
        case 5:{
            NSInteger count = ceil(self.styleNameArray.count / floorf((SCREENWIDTH - 24.f) / 76.f));
            return 80.f + 25 * count + 12.f * (count - 1);
        }
            break;
        case 6:{
            switch (indexPath.row) {
                case 0:{
                    return 42.f;
                }
                    break;
                case 1:{
                    return 24.f + [self getHeightWithContent:self.orderModel.claim];
                }
                    break;
                case 2:{
                    return 24.f + [SHImageListView imageListWithMaxWidth:(SCREENWIDTH - 24.f) WithCount:self.imageArray.count WithMaxCount:0 WithItemSize:CGSizeMake(60.f,60.f) WithAdd:YES];
                }
                    break;
                default:{
                    return 0.f;
                }
                    break;
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
        case 2:{
            ECSelectMapPointViewController *selectMapPointVC = [[ECSelectMapPointViewController alloc] init];
            [SELF_BASENAVI pushViewController:selectMapPointVC animated:YES titleLabel:@"请选择地址"];
            [selectMapPointVC setDidSelectMapPoint:^(double latitude, double longitude) {
                weakSelf.orderModel.lat = latitude;
                weakSelf.orderModel.lng = longitude;
                //发起请求获取选中位置的地理位置信息
                [weakSelf requestGetAddress];
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
