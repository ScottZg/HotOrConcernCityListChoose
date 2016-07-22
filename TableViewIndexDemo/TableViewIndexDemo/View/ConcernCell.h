//
//  ConcernCell.h
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ConcernCell : UITableViewCell


@property (nonatomic,strong)UILabel *remindLabel;


/**
 *  设置需要显示的关注城市
 *
 *  @param cityArr 城市数组
 */
- (void)setShowContentWithCityArr:(NSMutableArray *)cityArr;
@end
