//
//  CliPopView.m
//  CliCountdownView
//
//  Created by yhq on 16/6/12.
//  Copyright © 2016年 YU. All rights reserved.
//

#import "CliPopView.h"

#define CORNER_RADIUS 10.0f
#define TriangleHeight 15.0f
static UIColor *gTintColor;

@interface CliPopView (){
    UILabel *_textLabel;
}

@end
@implementation CliPopView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (!_textLabel) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - TriangleHeight)];
            _textLabel.backgroundColor = [UIColor clearColor];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.numberOfLines = 0;
            _textLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_textLabel];
        }
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CORNER_RADIUS, 0)];
    [path addLineToPoint:CGPointMake(frame.size.width - CORNER_RADIUS, 0)];
    [path addArcWithCenter:CGPointMake(frame.size.width - CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:M_PI / 2 endAngle:0 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height - TriangleHeight - CORNER_RADIUS)];
    [path addArcWithCenter:CGPointMake(frame.size.width - CORNER_RADIUS, frame.size.height - CORNER_RADIUS - TriangleHeight) radius:CORNER_RADIUS startAngle:0 endAngle:M_PI / 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(frame.size.width / 2 + TriangleHeight / 2, frame.size.height - TriangleHeight)];
    [path addLineToPoint:CGPointMake(frame.size.width / 2, frame.size.height)];
    [path addLineToPoint:CGPointMake(frame.size.width / 2 - TriangleHeight / 2, frame.size.height - TriangleHeight)];
    [path addLineToPoint:CGPointMake(CORNER_RADIUS, frame.size.height - TriangleHeight)];
    [path addArcWithCenter:CGPointMake(CORNER_RADIUS, frame.size.height - CORNER_RADIUS - TriangleHeight) radius:CORNER_RADIUS startAngle:- M_PI/2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(0, CORNER_RADIUS)];
    [path addArcWithCenter:CGPointMake(CORNER_RADIUS, CORNER_RADIUS) radius:CORNER_RADIUS startAngle:-M_PI endAngle:M_PI / 2 clockwise:YES];
    [gTintColor set];
    [path fill];
    [path stroke];
    
    CGContextRestoreGState(context);
}


-(void) setTintColor: (UIColor *) tintColor
{
    if (tintColor != gTintColor) {
        gTintColor = tintColor;
    }
}

-(void)setTextFont:(UIFont *)font{
    _textLabel.font = font;
}

-(void)setTextColor:(UIColor *)color{
    _textLabel.textColor = color;
}

-(void)setText:(NSString *)text{
    _textLabel.text = text;
}
@end
