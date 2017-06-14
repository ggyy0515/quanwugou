//
//  ECDesignerOrderDetailContentTableViewCell.m
//  B2CEC
//
//  Created by 曙华国际 on 2016/12/23.
//  Copyright © 2016年 Tristan. All rights reserved.
//

#import "ECDesignerOrderDetailContentTableViewCell.h"
#import "ECLogsImageCollectionViewCell.h"

@interface ECDesignerOrderDetailContentTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (strong,nonatomic) UILabel *titleLab;

@property (strong,nonatomic) UILabel *contentLab;

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation ECDesignerOrderDetailContentTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    ECDesignerOrderDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailContentTableViewCell)];
    if (cell == nil) {
        cell = [[ECDesignerOrderDetailContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFY_WITH_OBJECT(ECDesignerOrderDetailContentTableViewCell)];
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
    if (!_titleLab) {
        _titleLab = [UILabel new];
    }
    _titleLab.text = @"具体要求";
    _titleLab.textColor = DarkMoreColor;
    _titleLab.font = FONT_B_32;
    
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
    
    [self.contentView addSubview:_titleLab];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_collectionView];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.f);
        make.top.mas_equalTo(16.f);
        make.right.mas_equalTo(-12.f);
    }];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.top.mas_equalTo(weakSelf.titleLab.mas_bottom).offset(12.f);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.titleLab);
        make.top.mas_equalTo(weakSelf.contentLab.mas_bottom).offset(12.f);
        make.bottom.mas_equalTo(-16.f);
    }];
}

- (void)setContent:(NSString *)content{
    _content = content;
    _contentLab.text = content;
}

- (void)setImgUrls:(NSArray *)imgUrls{
    _imgUrls = imgUrls;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imgUrls.count == 0) {
        return 0;
    }
    return self.imgUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECLogsImageCollectionViewCell *cell = [ECLogsImageCollectionViewCell CellWithCollectionView:collectionView WithIndexPath:indexPath];
    cell.iconImage = self.imgUrls[indexPath.row];
    return cell;
}

@end
