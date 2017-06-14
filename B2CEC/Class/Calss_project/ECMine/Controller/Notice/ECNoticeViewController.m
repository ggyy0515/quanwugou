//
//  ECNoticeViewController.m
//  B2CEC
//
//  Created by Tristan on 2016/12/28.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECNoticeViewController.h"
#import "ECNoticeNavTitleView.h"
#import "ECNoticePushView.h"
#import "ECNoticeChatView.h"

@interface ECNoticeViewController ()

@property (nonatomic, strong) ECNoticeNavTitleView *navView;
@property (nonatomic, strong) ECNoticeChatView *chatView;

@property (strong,nonatomic) ECNoticePushView *pushView;

//----滑动手势----//
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGFloat beganX;
@property (nonatomic, assign) CGFloat beganY;
@property (nonatomic, assign) NSInteger currIndex;
//----滑动手势----//

@end

@implementation ECNoticeViewController

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
    
    if (!_navView) {
        _navView = [[ECNoticeNavTitleView alloc] initWithFrame:CGRectMake(0, 0, 160.f, 44.f) left:NO right:_showRightRed];
    }
    self.navigationItem.titleView = _navView;
    [_navView setClickChatBtn:^{
        weakSelf.currIndex = 0;
        [weakSelf changePageType];
    }];
    [_navView setClickNoticeBtn:^{
        weakSelf.currIndex = 1;
        weakSelf.showRightRed = NO;
        weakSelf.navView.noticeRed.hidden = YES;
        [weakSelf changePageType];
    }];
    
    
    if (!_chatView) {
        _chatView = [[ECNoticeChatView alloc] init];
    }
    [self.view addSubview:_chatView];
    [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (!_pushView) {
        _pushView = [ECNoticePushView new];
    }
    [self.view addSubview:_pushView];
    [_pushView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0.f);
    }];
    _pushView.hidden = YES;
    
    _currIndex = 0;
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_pan];
}

#pragma mark - Pan Animation

- (void)panGesture:(id)sender {
    UIPanGestureRecognizer *panGestureRecognizer;
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        panGestureRecognizer = (UIPanGestureRecognizer *)sender;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        _beganX = translation.x;
        _beganY = translation.y;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        if (fabs(translation.y - _beganY) < fabs(translation.x - _beganX)) {
            if (translation.x > _beganX && (translation.x - _beganX) > OFFSET_TRIGGER_DIRECTION) {
                //goBack
                if (_currIndex > 0) {
                    [self changeNum:-1];
                }
            }else if (translation.x < _beganX && (_beganX - translation.x) > OFFSET_TRIGGER_DIRECTION){
                //goForward
                if (_currIndex < 1) {
                    [self changeNum:1];
                }
            }
        }
        _beganX = 0;
        _beganY = 0;
    }
}

- (void)changeNum:(NSInteger)num {
    _currIndex = _currIndex + num;
    [self changePageType];
}

- (void)changePageType {
    if (_currIndex == 0) {
        _pushView.hidden = YES;
        _chatView.hidden = NO;
    } else {
        _chatView.hidden = YES;
        _pushView.hidden = NO;
    }
    [_navView selectIndex:_currIndex];
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
