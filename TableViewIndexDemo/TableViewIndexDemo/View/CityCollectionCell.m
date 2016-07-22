//
//  CityCollectionCell.m
//  TableViewIndexDemo
//
//  Created by zhanggui on 16/7/20.
//  Copyright © 2016年 zhanggui. All rights reserved.
//

#import "CityCollectionCell.h"
#import "Masonry.h"

@interface CityCollectionCell ()

@property (nonatomic,strong)UIImageView *deleteImageView;


@property (nonatomic,strong)UILabel *cityNameLabel;
@end
@implementation CityCollectionCell

- (void)drawRect:(CGRect)rect {
    [self darwCityName];
    if (self.isConcerned) {
        [self drawDeleteButton:rect];
    }
}
- (void)drawDeleteButton:(CGRect)rect {
    
    self.deleteImageView.layer.cornerRadius = 7.5;
}
- (void)darwCityName {
    self.cityNameLabel.text = self.cityModel.cityName;

    self.cityNameLabel.textColor = [self textColor];
    CGRect frame = self.frame;
    self.layer.borderColor = [self textColor].CGColor;

    self.layer.cornerRadius = CGRectGetHeight(frame)/2;
    self.layer.borderWidth = 1;

}
- (void)updateStyle {
    [self darwCityName];
}
#pragma mark - 
- (UIColor *)textColor {
   
    if (self.cityModel.isSelected && !self.isConcerned) {
        return [UIColor lightGrayColor];
    }
    
    if (!self.cityModel.isSelected || self.isConcerned) {
        return [UIColor blackColor];
    }
    return [UIColor blackColor];
}
#pragma mark - setter && getter
- (UIImageView *)deleteImageView {
    if (!_deleteImageView) {
        _deleteImageView = [[UIImageView alloc] init];
        _deleteImageView.backgroundColor = [UIColor redColor];
        [self addSubview:_deleteImageView];
        [_deleteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(-3);
            make.right.equalTo(self.mas_right);
            make.width.height.equalTo(@15);
        }];
    }
    return _deleteImageView;
}
- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] init];
        _cityNameLabel.font = [UIFont systemFontOfSize:13];
        _cityNameLabel.textColor = [UIColor blackColor];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_cityNameLabel];
        [_cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _cityNameLabel;
}
@end
