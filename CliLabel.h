//
//  CliLabel.h
//  CliCountdownView
//
//  Created by yhq on 16/6/8.
//  Copyright © 2016年 YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CliLabel : UIView


@property(nonatomic,strong)UILabel *textLabel;
@property(nonatomic,strong)CAShapeLayer *bgLayer;

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backColor:(UIColor *)backColor;

-(void)setTitle:(NSString *)text;

@end
