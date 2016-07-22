//
//  CityModel.h
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *shortName;
@property (nonatomic,strong)NSString *citySpelling;
@property (nonatomic,strong)NSString *shorSpelling;

@property (nonatomic,strong)NSString *firstSepllStr;


//用于选择 YES表示选择，NO表示未选择
@property (nonatomic,assign,getter=isSelected)BOOL selected;
//用于删除，YES表示能删除，NO表示不能删除
@property (nonatomic,assign)BOOL canDeleted;

- (instancetype)initWithDic:(NSDictionary *)dic;


@property (nonatomic,assign)NSInteger hotTag;  //表示热度index
@end
