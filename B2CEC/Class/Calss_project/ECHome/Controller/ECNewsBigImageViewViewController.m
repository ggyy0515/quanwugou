//
//  ECNewsBigImageViewViewController.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNewsBigImageViewViewController.h"
#import "ECNewsBigImageViewCollectionViewCell.h"
#import "ECNewsInputCommentView.h"
#import "ECHomeNewsListModel.h"
#import "ECNewsCommentViewController.h"
#import "ECNewsCommentModel.h"

@interface ECNewsBigImageViewViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UIButton *clostBtn;

@property (strong,nonatomic) UICollectionView *contentCollectionView;

@property (strong,nonatomic) ECNewsInputCommentView *inputView;

@property (strong,nonatomic) ECNewsInfomationModel *infoModel;

@property (strong,nonatomic) UIView *titleView;

@property (strong,nonatomic) UILabel *titilLab;

@property (nonatomic, assign) NSInteger currIndex;

@property (nonatomic, strong) ECHomeNewsImageListModel *currModel;

@property (nonatomic, assign) BOOL elementHideState;

@end

@implementation ECNewsBigImageViewViewController

- (void)addNotificationObserver{
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestNewsInfo), NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    ADD_OBSERVER_NOTIFICATION(self, @selector(requestNewsInfo), NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)dealloc{
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_SUCCESS, nil);
    REMOVE_NOTIFICATION(self, NOTIFICATION_USER_LOGIN_EXIST, nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currIndex = 0;
    _elementHideState = NO;
    self.view.backgroundColor = [UIColor blackColor];
    [self createBasicUI];
    [self requestNewsInfo];
    [self addNotificationObserver];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)createBasicUI{
    WEAK_SELF
    
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.itemSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _contentCollectionView.backgroundColor = [UIColor blackColor];
    _contentCollectionView.pagingEnabled = YES;
    _contentCollectionView.delegate = self;
    _contentCollectionView.dataSource = self;
    _contentCollectionView.showsHorizontalScrollIndicator = NO;
    
    [_contentCollectionView registerClass:[ECNewsBigImageViewCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECNewsBigImageViewCollectionViewCell)];
    
    if (!_clostBtn) {
        _clostBtn = [UIButton new];
    }
    [_clostBtn setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
    [_clostBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        [WEAKSELF_BASENAVI popViewControllerAnimated:YES];
    }];
    
    if (!_inputView) {
        _inputView = [ECNewsInputCommentView new];
    }
    _inputView.isInput = NO;
    _inputView.isStyleBlack = YES;
    _inputView.hidden = YES;
    [_inputView setInputClickBlock:^{
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf gotoCommentVC:YES];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setCommentClickBlock:^{
        [weakSelf gotoCommentVC:NO];
    }];
    [_inputView setCollecClickBlock:^{
        if (EC_USER_WHETHERLOGIN) {
            [weakSelf requestNewsCollect];
        }else{
            [APP_DELEGATE callLoginWithViewConcontroller:weakSelf jumpToMian:NO clearCurrentLoginInfo:YES succeed:^{
            }];
        }
    }];
    [_inputView setShareClickBlock:^{
        [CMPublicMethod shareToPlatformWithTitle:weakSelf.infoModel.title WithLink:[NSString stringWithFormat:@"%@BIANMA=%@&informationId=%@",[CMPublicDataManager sharedCMPublicDataManager].publicDataModel.informationShareUrl,weakSelf.BIANMA,weakSelf.informationId] WithQCode:NO];
    }];
    
    [self.view addSubview:_contentCollectionView];
    [self.view addSubview:_clostBtn];
    [self.view addSubview:_inputView];
    
    [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.bottom.mas_equalTo(0.f);
        make.width.mas_equalTo(weakSelf.view.mas_width);
    }];
    
    [_clostBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f);
        make.left.mas_equalTo(0.f);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(49.f);
    }];
    
    if (!_titleView) {
        _titleView = [UIView new];
    }
    _titleView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.8];
    
    if (!_titilLab) {
        _titilLab = [UILabel new];
    }
    _titilLab.font = [UIFont systemFontOfSize:18.f];
    _titilLab.textColor = LightColor;
    _titilLab.numberOfLines = 0.f;
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_titilLab];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0.f);
        make.bottom.mas_equalTo(weakSelf.titilLab.mas_bottom).offset(14.f);
        make.top.mas_equalTo(weakSelf.titilLab.mas_top).offset(-20.f);
    }];
    
    [_titilLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.bottom.mas_equalTo(-63.f);
    }];
    
}

- (void)changeElementHideState:(BOOL)isHide {
    _elementHideState = isHide;
    _titilLab.hidden = _titleView.hidden = _clostBtn.hidden = _inputView.hidden = isHide;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / SCREENWIDTH;
    if (index != _currIndex) {
        _currIndex = index;
        _currModel = [_infoModel.imageList objectAtIndexWithCheck:index];
        _titilLab.text = _currModel.title;
    }
}


- (void)gotoCommentVC:(BOOL)isEdit{
    WEAK_SELF
    ECNewsCommentViewController *newsCommentVC = [[ECNewsCommentViewController alloc] init];
    newsCommentVC.informationId = self.informationId;
    newsCommentVC.isEdit = isEdit;
    [SELF_BASENAVI pushViewController:newsCommentVC animated:YES titleLabel:@"用户评论"];
    [newsCommentVC setSendCommentTextBlock:^{
        weakSelf.infoModel.commentNum = [NSString stringWithFormat:@"%ld",weakSelf.infoModel.commentNum.integerValue + 1];
        weakSelf.inputView.commentCount = weakSelf.infoModel.commentNum;
        if (weakSelf.sendCommentTextBlock) {
            weakSelf.sendCommentTextBlock();
        }
    }];
}

- (void)requestNewsInfo{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsInfoWithBianma:self.BIANMA WithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            DISMISSSVP
            weakSelf.infoModel = [ECNewsInfomationModel yy_modelWithDictionary:result[@"information"]];
            _currModel = [_infoModel.imageList objectAtIndexWithCheck:0];
            _titilLab.text = _currModel.title;
            weakSelf.inputView.commentCount = weakSelf.infoModel.commentNum;
            weakSelf.inputView.isCollect = weakSelf.infoModel.iscollect;
            
            weakSelf.inputView.hidden = NO;
            
            [weakSelf.contentCollectionView reloadData];
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (void)requestNewsCollect{
    SHOWSVP
    WEAK_SELF
    [ECHTTPServer requestNewsCollectWithNewsID:self.informationId succeed:^(NSURLSessionDataTask *task, id result) {
        if (IS_REQUEST_SUCCEED(result)) {
            if ([weakSelf.infoModel.iscollect isEqualToString:@"0"]) {
                weakSelf.infoModel.iscollect = @"1";
                weakSelf.inputView.isCollect = weakSelf.infoModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }else{
                weakSelf.infoModel.iscollect = @"0";
                weakSelf.inputView.isCollect = weakSelf.infoModel.iscollect;
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            }
        }else{
            RequestError
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        RequestFailure
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.infoModel.imageList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAK_SELF
    ECNewsBigImageViewCollectionViewCell *cell = [ECNewsBigImageViewCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.model = self.infoModel.imageList[indexPath.row];
    [cell setHideAction:^{
        [UIView animateWithDuration:0.5
                         animations:^{
                             if (!weakSelf.elementHideState) {
                                 [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                                 weakSelf.titilLab.alpha = weakSelf.titleView.alpha = weakSelf.clostBtn.alpha = weakSelf.inputView.alpha = 0;
                             } else {
                                 [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                 weakSelf.titilLab.alpha = weakSelf.clostBtn.alpha = weakSelf.inputView.alpha = 1;
                                 weakSelf.titleView.alpha = 0.8;
                             }
                             
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [weakSelf changeElementHideState:!weakSelf.elementHideState];
                             }
                         }];
    }];
    return cell;
}


@end
