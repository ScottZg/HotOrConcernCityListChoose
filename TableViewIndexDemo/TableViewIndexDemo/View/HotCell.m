//
//  HotCell.m
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import "HotCell.h"
#import "Masonry.h"
#import "CityCollectionCell.h"
@interface HotCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *hotCollectionView;

@property (nonatomic,strong)NSMutableArray *hotCityArr;

@end

@implementation HotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.hotCollectionView registerClass:[CityCollectionCell class] forCellWithReuseIdentifier:@"HotCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unChooseHotCity:) name:@"CanChooseHotCity" object:nil];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (void)setShowContentWithCityArr:(NSMutableArray *)cityArr {
    if ([self.hotCityArr count]!=0) {
        [self.hotCityArr removeAllObjects];
    }
    
    self.hotCityArr = cityArr;
    [self.hotCollectionView reloadData];
    NSLog(@"%f",self.hotCollectionView.contentSize.height);
//    if (self.changeHeightBlock) {
//        self.changeHeightBlock(self.hotCollectionView.contentSize.height);
//    }
}
#pragma mark - 
- (void)unChooseHotCity:(NSNotification *)noti {
    CityModel *model = (CityModel *)noti.object;
    CityCollectionCell *cell = (CityCollectionCell *)[self.hotCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:model.hotTag inSection:0]];
    [cell updateStyle];
}
#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.hotCityArr count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiy = @"HotCell";
    CityCollectionCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:identifiy forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.cityModel = self.hotCityArr[indexPath.row];
    cell.cityModel.hotTag = indexPath.row;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CityModel *model = self.hotCityArr[indexPath.row];
    if ([self.concernCityCellArray count]>=5|| model.isSelected) {
        
        return;
    }
    //修改显示内容状态
    CityCollectionCell *cell = (CityCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
     cell.cityModel.selected = YES;
    [cell updateStyle];
    
    //通知添加到关注城市
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddConcernCity" object:cell.cityModel];
    
}
#pragma mark - 


#pragma mark - setter && getter
- (UICollectionView *)hotCollectionView {
    if (!_hotCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _hotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _hotCollectionView.scrollEnabled = NO;
        flowLayout.itemSize = CGSizeMake(KScreenWith/3-30, 40);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _hotCollectionView.delegate  = self;
        _hotCollectionView.dataSource = self;
        
        _hotCollectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_hotCollectionView];
        [_hotCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _hotCollectionView;
}
- (NSMutableArray *)hotCityArr {
    if (!_hotCityArr) {
        _hotCityArr = [NSMutableArray new];
    }
    return _hotCityArr;
}
#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
