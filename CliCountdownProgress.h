//
//  CliCountdownProgress.h
//  CliCountdownView
//
//  Created by yhq on 16/6/7.
//  Copyright © 2016年 YU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FinishBlock)();

@interface CliCountdownProgress : UIView


@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *sliderColor;
@property(nonatomic,strong)UIColor *progressColor;
@property(nonatomic,strong)UIColor *bgColor;




+(void)showProgressWithFrame:(CGRect)frame sliderHeight:(CGFloat)height sections:(NSInteger)section inView:(UIView *)view finish:(FinishBlock)block;

@end
