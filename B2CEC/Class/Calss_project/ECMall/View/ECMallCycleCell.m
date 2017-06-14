//
//  ECMallCycleCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/10.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECMallCycleCell.h"
#import "SDCycleScrollView.h"
#import "ECMallCycleViewModel.h"
#import "ECPointDistributionViewController.h"

@interface ECMallCycleCell ()
<
    SDCycleScrollViewDelegate
>


@end

@implementation ECMallCycleCell

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cycleViewDataSource = [NSMutableArray array];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    WEAK_SELF
    self.contentView.backgroundColor = [UIColor whiteColor];
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
    }
    [self.contentView addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.mas_equalTo(weakSelf.contentView).insets(padding);
    }];
    _cycleView.infiniteLoop = YES;
    _cycleView.delegate = self;
    _cycleView.autoScrollTimeInterval = 5.f;
    _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [_cycleView setPageDotColor:[UIColor whiteColor]]; // 自定义分页控件小圆标颜色
    _cycleView.placeholderImage = [UIImage imageNamed:@"Banner"];
}

- (void)setCycleViewDataSource:(NSMutableArray<ECMallCycleViewModel *> *)cycleViewDataSource {
    _cycleViewDataSource = cycleViewDataSource;
    NSMutableArray *imageArr = [NSMutableArray array];
    [cycleViewDataSource enumerateObjectsUsingBlock:^(ECMallCycleViewModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = IMAGEURL(model.image);
        [imageArr addObject:path];
    }];
    [_cycleView setImageURLStringsGroup:imageArr];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    ECMallCycleViewModel *model = [_cycleViewDataSource objectAtIndexWithCheck:index];
    ECPointDistributionViewController *vc = [[ECPointDistributionViewController alloc] initWithUrlString:model.webUrl];
    [SELF_VC_BASEVAV pushViewController:vc animated:YES titleLabel:model.title];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
