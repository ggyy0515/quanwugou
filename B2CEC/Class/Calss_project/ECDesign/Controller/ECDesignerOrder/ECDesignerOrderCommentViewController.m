//
//  ECDesignerOrderCommentViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/22.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderCommentViewController.h"
#import "ECDesignerOrderCommentTableViewCell.h"

#import "SHPhotoBorwserViewController.h"

@interface ECDesignerOrderCommentViewController ()

@property (strong,nonatomic) NSArray *imageArray;
@property (strong,nonatomic) NSArray *selectPhotoModels;
@property (strong,nonatomic) ZLPhotoActionSheet *actionSheet;

@property (strong,nonatomic) NSString *comment;
@property (strong,nonatomic) NSString *star;
@property (strong,nonatomic) NSString *imgUrls;

@end

@implementation ECDesignerOrderCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.star = @"5";
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = BaseColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitClick:)];
    self.navigationItem.rightBarButtonItem.tintColor = MainColor;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = BaseColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.top.mas_equalTo(12.f);
    }];
}

- (void)submitClick:(id)sender{
    [self.tableView endEditing:YES];
    if (self.comment.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"正文不能为空"];
        return ;
    }
    SHOWSVP
    WEAK_SELF
    [self requestUploadImageListSucceed:^(NSArray *pathArr) {
        NSMutableArray *cerArray = [NSMutableArray new];
        for (NSInteger page = 0; page < pathArr.count; page ++) {
            [cerArray addObject:pathArr[page][@"path"]];
        }
        if (cerArray.count == 0) {
            weakSelf.imgUrls = @"";
        }else{
            weakSelf.imgUrls = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:cerArray options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        }
        [weakSelf requestSubmitComment];
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

- (void)requestSubmitComment{
    WEAK_SELF
    [ECHTTPServer requestDesignerOrderComment:self.orderID WithComment:self.comment WithStar:self.star WithImgUrls:self.imgUrls succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            [SVProgressHUD showSuccessWithStatus:@"评价成功"];
            if (weakSelf.commentSuccessBlock) {
                weakSelf.commentSuccessBlock();
            }
            [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECDesignerOrderCommentTableViewCell *cell = [ECDesignerOrderCommentTableViewCell cellWithTableView:tableView];
    cell.iconImage = self.designerIconImage;
    cell.name = self.designerName;
    cell.imageArray = self.imageArray;
    [cell setStarLevelChanged:^(NSString *star) {
        weakSelf.star = star;
    }];
    [cell setCommentChanged:^(NSString *comment) {
        weakSelf.comment = comment;
    }];
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
            weakSelf.selectPhotoModels = [weakSelf.selectPhotoModels removeObjectAtIndexArray:removeArray];
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
        [weakSelf.actionSheet showWithSender:weakSelf animate:YES lastSelectPhotoModels:weakSelf.selectPhotoModels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            weakSelf.imageArray = selectPhotos;
            weakSelf.selectPhotoModels = selectPhotoModels;
            [weakSelf.tableView reloadData];
        }];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 295.f + [SHImageListView imageListWithMaxWidth:(SCREENWIDTH - 24.f) WithCount:self.imageArray.count WithMaxCount:0 WithItemSize:CGSizeMake(60.f,60.f) WithAdd:YES];
}

@end
