//
//  CliLabel.m
//  CliCountdownView
//
//  Created by yhq on 16/6/8.
//  Copyright © 2016年 YU. All rights reserved.
//

#import "CliLabel.h"

@implementation CliLabel

-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor backColor:(UIColor *)backColor{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_bgLayer) {
            _bgLayer = [CAShapeLayer layer];
            _bgLayer.fillColor = backColor.CGColor;
            _bgLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2) radius:frame.size.width / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
            [self.layer addSublayer:_bgLayer];
        }
        if (!_textLabel) {
            _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
            _textLabel.font = font;
            _textLabel.textColor = textColor;
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.text = text;
            [self addSubview:_textLabel];
        }
    }
    return self;
}

-(void)setTitle:(NSString *)text{
    _textLabel.text = text;
}
@end
