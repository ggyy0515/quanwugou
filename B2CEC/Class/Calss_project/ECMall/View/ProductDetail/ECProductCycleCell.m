//
//  ECProductCycleCell.m
//  B2CEC
//
//  Created by Tristan on 2016/11/17.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECProductCycleCell.h"
#import "SDCycleScrollView.h"
#import "CMImageBrowser.h"

@interface ECProductCycleCell ()
<
    SDCycleScrollViewDelegate
>


@end

@implementation ECProductCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
    if (!_roundLabel) {
        _roundLabel = [UILabel new];
    }
    
    _roundLabel.text = @"";
    _roundLabel.textColor = UIColorFromHexString(@"#FFFFFF");
    _roundLabel.textAlignment = NSTextAlignmentCenter;
    _roundLabel.layer.masksToBounds = YES;
    _roundLabel.cornerRadius = 8.f;
    _roundLabel.backgroundColor = UIColorFromHexString(@"#CCCCCC");
    _roundLabel.font = FONT_22;
    [_cycleView addSubview:_roundLabel];
    
    
    [self.contentView addSubview:_cycleView];
    [_cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
        make.edges.mas_equalTo(weakSelf.contentView).insets(padding);
    }];
    
    [_roundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(weakSelf).offset(-8);
        make.height.mas_equalTo(16.f);
        make.width.mas_equalTo(30.f);
        
    }];
    
    //    _cycleView.infiniteLoop = YES;
    _cycleView.delegate = self;
    _cycleView.showPageControl = NO;
    _cycleView.autoScroll = NO;
    //    _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    //    [_cycleView setPageDotColor:MainColor]; // 自定义分页控件小圆标颜色
    _cycleView.placeholderImage = [UIImage imageNamed:@"zhanwei"];
    
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
    }
    [self.contentView addSubview:_moreBtn];
    [_moreBtn setImage:[UIImage imageNamed:@"goods_more"] forState:UIControlStateNormal];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.roundLabel.mas_bottom);
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(56.f, 56.f));
    }];
    [_moreBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.moreBtnClick) {
            weakSelf.moreBtnClick();
        }
    }];
}

- (void)setImageUrlArr:(NSArray *)imageUrlArr{
    _imageUrlArr = imageUrlArr;
    WEAK_SELF
    if (imageUrlArr.count == 0) {
        _roundLabel.hidden = YES;
    } else {
        _roundLabel.hidden = NO;
    }
    _roundLabel.text = [NSString stringWithFormat:@"1/%ld",(long)imageUrlArr.count];
    _cycleView.imageURLStringsGroup = imageUrlArr;
    [_cycleView setItemDidScrollOperationBlock:^(NSInteger index) {
        weakSelf.roundLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)index+1,(long)imageUrlArr.count];
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [CMImageBrowser showBrowserInView:SELF_VC_BASEVAV.view
                      backgroundColor:[UIColor blackColor]
                            imageUrls:_imageUrlArr
                            fromIndex:index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
