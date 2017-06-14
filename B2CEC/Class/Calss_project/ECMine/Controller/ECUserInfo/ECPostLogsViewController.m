//
//  ECPostLogsViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/8.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECPostLogsViewController.h"
#import "ECDesignerRegisterJobCourseTableViewCell.h"
#import "ECPostLogsImageListTableViewCell.h"

#import "SHPhotoBorwserViewController.h"

@interface ECPostLogsViewController ()

@property (strong,nonatomic) UIButton *submitBtn;

@property (strong,nonatomic) UITextView *getHeightTextView;

@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) NSString *imageList;

@property (strong,nonatomic) NSArray *imageArray;

@property (strong,nonatomic) NSArray <ZLSelectPhotoModel *> *selectPhotoModeArray;

@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@end

@implementation ECPostLogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}

- (void)createData{
    _imageArray = [NSArray new];
    self.view.backgroundColor = BaseColor;
}

- (void)createUI{
    WEAK_SELF
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 44.f, 44.f)];
    }
    [_submitBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:MainColor forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = FONT_32;
    [_submitBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [weakSelf.tableView endEditing:YES];
        if (weakSelf.content.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"正文不能为空"];
            return ;
        }
        SHOWSVP
        [weakSelf requestUploadImageListSucceed:^(NSArray *pathArr) {
            NSMutableArray *cerArray = [NSMutableArray new];
            for (NSInteger page = 0; page < pathArr.count; page ++) {
                [cerArray addObject:pathArr[page][@"path"]];
            }
            weakSelf.imageList = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:cerArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            [weakSelf requestSubmitLog];
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
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(12.f);
    }];
}

- (void)requestUploadImageListSucceed:(void(^)(NSArray *pathArr))succeed{
    NSMutableArray *dataArray = [NSMutableArray new];
    //加入证书图片
    for (id data in self.imageArray) {
        [dataArray addObject:[CMPublicMethod getFitImageWithImage:data]];
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

- (void)requestSubmitLog{
    WEAK_SELF
    [ECHTTPServer requestSubmitLogsWithTitle:self.content WithImage:self.imageList succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            POST_NOTIFICATION(NOTIFICATION_POSTWORKS_LOGS_ARTICLE, @{@"type":@"2"});
            [WEAKSELF_BASENAVI popToViewController:WEAKSELF_BASENAVI.viewControllers[WEAKSELF_BASENAVI.viewControllers.count - 2] animated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    switch (indexPath.row) {
        case 0:{
            ECDesignerRegisterJobCourseTableViewCell *cell = [ECDesignerRegisterJobCourseTableViewCell cellWithTableView:tableView];
            cell.placepolder = @"编辑正文";
            cell.content = self.content;
            [cell setCourseTextChangeBlock:^(NSString *course) {
                weakSelf.content = course;
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView endUpdates];
            }];
            return cell;
        }
            break;
        default:{
            ECPostLogsImageListTableViewCell *cell = [ECPostLogsImageListTableViewCell cellWithTableView:tableView];
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
                    weakSelf.imageArray = [weakSelf.imageArray removeObjectAtIndexArray:removeArray];
                    weakSelf.selectPhotoModeArray = [weakSelf.selectPhotoModeArray removeObjectAtIndexArray:removeArray];
                    [weakSelf.tableView reloadData];
                    
                    blockVC.imageArray = weakSelf.imageArray;
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
                [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:weakSelf.selectPhotoModeArray completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                    weakSelf.imageArray = selectPhotos;
                    weakSelf.selectPhotoModeArray = selectPhotoModels;
                    [weakSelf.tableView reloadData];
                }];
            }];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return 24.f + [self getHeightWithContent:self.content];
        }
            break;
        default:{
            return 24.f + [SHImageListView imageListWithMaxWidth:(SCREENWIDTH - 24.f) WithCount:self.imageArray.count WithMaxCount:0 WithItemSize:CGSizeMake(60.f,60.f) WithAdd:YES];
        }
            break;
    }
}

@end
