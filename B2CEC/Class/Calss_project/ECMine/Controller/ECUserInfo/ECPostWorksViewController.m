//
//  ECPostWorksViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostWorksViewController.h"
#import "ECPostWorksCoverTableViewCell.h"
#import "ECPostWorksInputTableViewCell.h"
#import "ECPostWorksPickerTableViewCell.h"
#import "ECPostWorksModel.h"

#import "VPImageCropperViewController.h"
#import "ECPostWorksContentViewController.h"

#define basicImageHeight   100.f
#define basicTextHeight    64.f

@interface ECPostWorksViewController ()<
VPImageCropperDelegate
>

@property (strong,nonatomic) UIButton *nextBtn;

@property (strong,nonatomic) NSArray *nameArray;

@property (strong,nonatomic) ECPostWorksModel *model;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@end

@implementation ECPostWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    self.view.backgroundColor = [UIColor whiteColor];
    _model = [[ECPostWorksModel alloc] init];
    _model.userid = [Keychain objectForKey:EC_USER_ID];
    _model.contentArray = [NSMutableArray new];
    _model.contentHeightArray = [NSMutableArray new];
    _model.contentFlagArray = [NSMutableArray new];
    [_model.contentArray addObject:@{@"content":@"",@"type":@"0"}];
    [_model.contentHeightArray addObject:@(basicTextHeight)];
    [_model.contentFlagArray addObject:@(NO)];

    if (self.isDesigner) {
        _nameArray = @[@[@"标题",@"请输入标题"],
                       @[@"风格",@"请选择风格"],
                       @[@"类型",@"请选择类型"],
                       @[@"房型",@"请选择房型"]
                       ];
    }else{
        _nameArray = @[@[@"标题",@"请输入标题"]];
    }
}

- (void)createUI{
    WEAK_SELF
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 60.f, 44.f)];
    }
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = FONT_32;
    [_nextBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        if (weakSelf.model.coverImage == nil) {
            [SVProgressHUD showErrorWithStatus:@"请选择封面"];
            return ;
        }
        if (weakSelf.model.title.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入标题"];
            return ;
        }
        if (weakSelf.isDesigner) {
            if (weakSelf.model.style.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择风格"];
                return ;
            }
            if (weakSelf.model.type.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择类型"];
                return ;
            }
            if (weakSelf.model.housetype.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择房型"];
                return ;
            }
        }
        ECPostWorksContentViewController *postWorkVC = [[ECPostWorksContentViewController alloc] init];
        postWorkVC.model = weakSelf.model;
        [WEAKSELF_BASENAVI pushViewController:postWorkVC animated:YES titleLabel:weakSelf.isDesigner ? @"编辑案例正文" : @"编辑文章正文"];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextBtn];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewStyle = UITableViewStyleGrouped;
    self.tableView.scrollEnabled = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0.f);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.isDesigner ? 5 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            ECPostWorksCoverTableViewCell *cell = [ECPostWorksCoverTableViewCell cellWithTableView:tableView];
            cell.coverImage = self.model.coverImage;
            [cell setSelectCoverBlock:^{
                weakSelf.actionSheet = [[ZLPhotoActionSheet alloc] init];
                weakSelf.actionSheet.maxSelectCount = 1;
                [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                    VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:[CMPublicMethod imageByScalingToMaxSize:selectPhotos[0]] cropFrame:CGRectMake(0, (weakSelf.view.frame.size.height - (SCREENWIDTH) * (350.f / 750.f)) / 2.f, weakSelf.view.frame.size.width, (SCREENWIDTH) * (350.f / 750.f)) limitScaleRatio:3.0];
                    imgEditorVC.delegate = weakSelf;
                    STRONG_SELF
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf presentViewController:imgEditorVC animated:YES completion:^{
                        }];
                    });
                }];
            }];
            return cell;
        }
            break;
        case 1:{
            ECPostWorksInputTableViewCell *cell = [ECPostWorksInputTableViewCell cellWithTableView:tableView];
            [cell setName:self.nameArray[indexPath.row - 1][0] WithPlaceholder:self.nameArray[indexPath.row - 1][1]];
            [cell setSelectTypeBlock:^(NSString *title) {
                weakSelf.model.title = title;
            }];
            return cell;
        }
            break;
        default:{
            ECPostWorksPickerTableViewCell *cell = [ECPostWorksPickerTableViewCell cellWithTableView:tableView];
            [cell setName:self.nameArray[indexPath.row - 1][0] WithPlaceholder:self.nameArray[indexPath.row - 1][1]];
            switch (indexPath.row) {
                case 2:{
                    cell.typeArray = [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasestyle;
                }
                    break;
                case 3:{
                    cell.typeArray = [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allcasetype;
                }
                    break;
                case 4:{
                    cell.typeArray = [CMWorksTypeDataManager sharedCMWorksTypeDataManager].model.allhousetype;
                }
                    break;
            }
            [cell setSelectTypeBlock:^(NSString *bianma) {
                switch (indexPath.row) {
                    case 2:{
                        weakSelf.model.style = bianma;
                    }
                        break;
                    case 3:{
                        weakSelf.model.type = bianma;
                    }
                        break;
                    case 4:{
                        weakSelf.model.housetype = bianma;
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
    switch (indexPath.row) {
        case 0:{
            return (SCREENWIDTH) * (350.f / 750.f);
        }
            break;
        default:{
            return 52.f;
        }
            break;
    }
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        self.model.coverImage = editedImage;
        [self.tableView reloadData];
    }];
}

@end
