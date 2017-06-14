//
//  ECLogsTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/9.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECLogsTableViewCell.h"
#import "ECLogsImageCollectionViewCell.h"

@interface ECLogsTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UILabel *dateLab;

@property (strong,nonatomic) UILabel *contentLab;

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong,nonatomic) UIView *lineView;

@property (strong,nonatomic) UIButton *deleteImgBtn;

@end

@implementation ECLogsTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECLogsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogsTableViewCell)];
    if (cell == nil) {
        cell = [[ECLogsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogsTableViewCell)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBasicUI];
    }
    return self;
}

- (void)createBasicUI{
    WEAK_SELF
    
    if (!_dateLab) {
        _dateLab = [UILabel new];
    }
    _dateLab.textColor = LightColor;
    _dateLab.font = FONT_24;
    
    if (!_contentLab) {
        _contentLab = [UILabel new];
    }
    _contentLab.numberOfLines = 0;
    _contentLab.textColor = DarkMoreColor;
    _contentLab.font = FONT_32;
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.itemSize = CGSizeMake((SCREENWIDTH - 44.f) / 3.f, (SCREENWIDTH - 44.f) / 3.f * (144.f / 220.f));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[ECLogsImageCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECLogsImageCollectionViewCell)];
    
    if (!_lineView) {
        _lineView = [UIView new];
    }
    _lineView.backgroundColor = LineDefaultsColor;
    
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_collectionView];
    [self.contentView addSubview:_lineView];
    
    [_dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(16.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.dateLab);
        make.top.mas_equalTo(weakSelf.dateLab.mas_bottom).offset(12.f);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.dateLab);
        make.top.mas_equalTo(weakSelf.contentLab.mas_bottom).offset(12.f);
        make.bottom.mas_equalTo(-16.f);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0.f);
        make.height.mas_equalTo(0.5f);
    }];
    
    if (!_deleteImgBtn) {
        _deleteImgBtn = [UIButton new];
    }
    [_deleteImgBtn setImage:[UIImage imageNamed:@"delete-1"] forState:UIControlStateNormal];
    _deleteImgBtn.hidden = YES;
    [_deleteImgBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
        if (weakSelf.deleteUserBlock) {
            weakSelf.deleteUserBlock(weakSelf.model.logsID,weakSelf.indexPath.row);
        }
    }];
    [self.contentView addSubview:_deleteImgBtn];
}

- (void)setModel:(ECLogsModel *)model{
    _model = model;
    _dateLab.text = model.createdate;
    _contentLab.text = model.title;
    [self.collectionView reloadData];
}

- (void)setIsUserDelete:(BOOL)isUserDelete{
    _isUserDelete = isUserDelete;
    _deleteImgBtn.hidden = !isUserDelete;
    WEAK_SELF
    
    if (isUserDelete) {
        [_deleteImgBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24.f, 24.f));
            make.right.mas_equalTo(-12.f);
            make.top.mas_equalTo(weakSelf.dateLab.mas_top);
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.model == nil || self.model.imgurl.count == 0) {
        return 0;
    }
    return self.model.imgurl.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECLogsImageCollectionViewCell *cell = [ECLogsImageCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.iconImage = self.model.imgurl[indexPath.row];
    return cell;
}

@end
