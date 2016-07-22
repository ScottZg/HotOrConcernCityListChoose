//
//  CityModel.m
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.cityId = dic[@"city_id"];
        self.cityName = dic[@"city_name"];
        self.citySpelling = dic[@"city_pinyin"];
        self.shortName = dic[@"short_name"];
        self.shorSpelling = dic[@"shor_pinyin"];
        self.firstSepllStr = [[dic[@"city_pinyin"] substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    }
    return self;
}
@end
