//
//  ConcernCell.m
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import "ConcernCell.h"
#import "Masonry.h"
#import "CityCollectionCell.h"
@interface ConcernCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *concernCityCollectionView;
@property (nonatomic,strong)NSMutableArray *concernCityArray;
@end

@implementation ConcernCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_initLayout];
         [self.concernCityCollectionView registerClass:[CityCollectionCell class] forCellWithReuseIdentifier:@"ConcernCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addConcernCityAction:) name:@"AddConcernCity" object:nil];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - addConcernCity
- (void)addConcernCityAction:(NSNotification *)noti {
    if ([self.concernCityArray count]==5) {
        NSLog(@"最多可添加5个关注城市");
        return;
    }
    [self.concernCityArray addObject:noti.object];
    [self.concernCityCollectionView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateConcerCellHeight" object:nil];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.concernCityArray count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiy = @"ConcernCell";
    CityCollectionCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:identifiy forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.isConcerned = YES;
    cell.cityModel = self.concernCityArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //更新热门城市
    CityCollectionCell *cell = (CityCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cityModel.selected = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CanChooseHotCity" object:cell.cityModel];
    //删除单元格
    [self.concernCityArray removeObjectAtIndex:indexPath.row];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
   
    //更新高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateConcerCellHeight" object:nil];
   
    
    
}

#pragma mark - initLayout
- (void)p_initLayout {
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
}
#pragma mark - event response
- (void)setShowContentWithCityArr:(NSMutableArray *)cityArr {
    self.concernCityArray = cityArr;
    NSLog(@"concernCell:%p",self.concernCityArray);
    [self.concernCityCollectionView reloadData];
}
#pragma mark - setter getter
- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.text = @"最多可添加5个";
        _remindLabel.font = [UIFont systemFontOfSize:12];
        _remindLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_remindLabel];
    }
    return _remindLabel;
}

- (UICollectionView *)concernCityCollectionView {
    if (!_concernCityCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _concernCityCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _concernCityCollectionView.scrollEnabled = NO;
        flowLayout.itemSize = CGSizeMake(KScreenWith/3-30, 40);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _concernCityCollectionView.delegate  = self;
        _concernCityCollectionView.dataSource = self;
        
        _concernCityCollectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_concernCityCollectionView];
        @XDWeakObj(self);
        [_concernCityCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            @XDStrongObj(self);
            make.top.equalTo(self.remindLabel.mas_bottom).offset(5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return _concernCityCollectionView;
}
- (NSMutableArray *)concernCityArray {
    if (!_concernCityArray) {
        _concernCityArray = [NSMutableArray new];
    }
    return _concernCityArray;
}
#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
