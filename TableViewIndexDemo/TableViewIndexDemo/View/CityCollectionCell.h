//
//  CityCollectionCell.h
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"


@interface CityCollectionCell : UICollectionViewCell

@property (nonatomic,strong)CityModel *cityModel;

@property (nonatomic,assign)BOOL isConcerned;


/**
 *  更新单元格类型
 *
 *  @param style 类型
 */
- (void)updateStyle;
@end
