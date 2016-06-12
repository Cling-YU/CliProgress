//
//  CliCountdownProgress.m
//  CliCountdownView
//
//  Created by yhq on 16/6/7.
//  Copyright © 2016年 YU. All rights reserved.
//

#import "CliCountdownProgress.h"
#import "CliLabel.h"
#import "CliPopView.h"
#define SliderWidth 20
#pragma mark -CliProgress

#define POPVIEW_HEIGHT 80
#define POPVIEW_WIDTH 100
@interface CliCountdownProgress ()
{
    NSThread *_timerTherd;
    CGFloat _sectionWidth;
}
@property(nonatomic,strong)CAShapeLayer *bgLayer;
@property(nonatomic,strong)CAShapeLayer *lineLayer;
@property(nonatomic,strong)CliLabel *cliLabel;
@property(nonatomic,assign)CGFloat lastMoveX;
@property(nonatomic,assign)CGFloat progressHeight;
@property(nonatomic,strong)CliPopView *popView;
@property(nonatomic,weak)NSTimer *timer;
@property(nonatomic,copy)FinishBlock finishBlock;
@property(nonatomic,copy)NSString *sliderText;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,assign)CGFloat sliderHeight;

@end

@implementation CliCountdownProgress

+(void)showProgressWithFrame:(CGRect)frame sliderHeight:(CGFloat)height sections:(NSInteger)section inView:(UIView *)view finish:(FinishBlock)block{
    CliCountdownProgress *progress = [[CliCountdownProgress alloc] initWithFrame:frame sliderHeight:height sections:section finish:block];
    [view addSubview:progress];
}

-(instancetype)initWithFrame:(CGRect)frame sliderHeight:(CGFloat)height sections:(NSInteger)section finish:(FinishBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        self.sliderColor = [UIColor grayColor];
        self.textColor = [UIColor whiteColor];
        self.progressColor = [UIColor blackColor];
        self.bgColor = [UIColor grayColor];
        self.section = section;
        self.sliderHeight = height;
        self.lastMoveX = 0;
        self.progressHeight = frame.size.height;
        _sectionWidth = frame.size.width / section;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height / 2 - height / 2, frame.size.width + height, height);
        if (!_bgLayer) {
            _bgLayer = [CAShapeLayer layer];
            _bgLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(height / 2, (height - self.progressHeight) / 2, self.frame.size.width - height, self.progressHeight)].CGPath;
            _bgLayer.fillColor = self.bgColor.CGColor;
            [self.layer addSublayer:_bgLayer];
        }
        
        if (!_lineLayer) {
            _lineLayer = [CAShapeLayer layer];
            _lineLayer.fillColor = self.progressColor.CGColor;
            [self.layer addSublayer:_lineLayer];
        }
        
        if (!_cliLabel) {
            _cliLabel = [[CliLabel alloc] initWithFrame:CGRectMake(0, 0, height,height) text:@"0" font:[UIFont systemFontOfSize:16.0] textColor:self.textColor backColor:self.bgColor];
            _cliLabel.userInteractionEnabled = YES;
            [_cliLabel addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAc:)]];
            [self addSubview:_cliLabel];
        }
        if (!_popView) {
            _popView = [[CliPopView alloc]initWithFrame:CGRectMake(0, 0, POPVIEW_WIDTH, POPVIEW_HEIGHT)];
            [_popView setTextFont:[UIFont systemFontOfSize:15]];
            [_popView setTextColor:[UIColor whiteColor]];
            [_popView setText:@"蜂鸣器倒计时\n0秒"];
            _popView.hidden = YES;
            [self addSubview:_popView];
            
        }
        
        self.finishBlock = block;

    }
    return self;
}

-(void)panAc:(UIPanGestureRecognizer *)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            [self.timer invalidate];
            self.timer = nil;
            self.lastMoveX = 0;
            _popView.center = CGPointMake(_cliLabel.center.x, -(POPVIEW_HEIGHT / 2 + 10));
            _popView.hidden = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            CGFloat x = [pan translationInView:self].x;
            [self movementWithDistance:x];
//            [self transformWithDistance:x];
            
        }
            break;
        case UIGestureRecognizerStateEnded:{
            //改变进度条的显示
            CGPoint location = _cliLabel.center;
            
            NSInteger index = location.x  / _sectionWidth;
            
            [_cliLabel setTitle:[NSString stringWithFormat:@"%li",index]];
            
            [self moveToNearIndex:index];
            
            _timerTherd = [[NSThread alloc] initWithTarget:self selector:@selector(timerStart) object:nil];
            [_timerTherd start];

            if (!index) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _popView.hidden = YES;
                });
            }
        }
            break;
        
        default:
            break;
    }
}

-(void)timerStart{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

-(void)updateTimer:(NSTimer *)timer{
    CGPoint location = _cliLabel.center;
    if (location.x == self.sliderHeight / 2) {
        
        self.finishBlock();

        [self.timer invalidate];
        self.timer = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _popView.hidden = YES;
        });
        [NSThread exit];
        return;
    }
    
    location.x -= _sectionWidth;
    [self updateUIWithCenter:location];
}

-(void)moveToNearIndex:(NSInteger)index{
    
    CGPoint location = _cliLabel.center;
    
    _cliLabel.bgLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.sliderHeight / 2 , self.sliderHeight / 2) radius:self.sliderHeight/2 startAngle:0 endAngle:2 * M_PI clockwise:YES].CGPath;
    _cliLabel.center = CGPointMake(_sectionWidth * index + self.sliderHeight / 2, location.y);
    
    //改变进度条
    _lineLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(self.sliderHeight/2, (self.sliderHeight - self.progressHeight)/2, _cliLabel.center.x - self.sliderHeight/2, self.progressHeight)].CGPath;
    
    //改变上面视图的位移
    CGPoint popCenter = _popView.center;
    popCenter.x = _cliLabel.center.x;
    _popView.center = popCenter;
    
    
}

-(void)updateUIWithCenter:(CGPoint)location{
    //改变中间圆
    _cliLabel.center = location;
    
    //改变进度条
    _lineLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(self.sliderHeight/2, (self.sliderHeight - self.progressHeight)/2, location.x - self.sliderHeight/2, self.progressHeight)].CGPath;
    
    //改变上面视图的位移
    CGPoint popCenter = _popView.center;
    popCenter.x = location.x;
    _popView.center = popCenter;
    
    //改变上面视图的字
    NSInteger index = location.x  / _sectionWidth;
    _cliLabel.textLabel.text = [NSString stringWithFormat:@"%li",index];
    [_popView setText:[NSString stringWithFormat:@"蜂鸣器倒计时\n%li秒",index]];
}

#pragma mark -TODO
//形变
-(void)transformWithDistance:(CGFloat)dis{
    CGPoint location = _cliLabel.center;
    if ((dis < 0 && location.x == self.sliderHeight / 2) || (dis > 0 && location.x == self.frame.size.width - self.sliderHeight / 2)) {
        return;
    }
    CGFloat kWidth = self.frame.size.width / self.section;
    //右移
    if (dis > 0 && dis < kWidth / 3) {

    }
    //左移
    if (dis < 0 && dis < -kWidth / 3) {
        
    }
}

//位移的动画
-(void)movementWithDistance:(CGFloat)dis{
    CGFloat x = dis - self.lastMoveX;
    self.lastMoveX = dis;
    
    CGPoint location = _cliLabel.center;
    location.x += x;
    
    if (location.x <= self.sliderHeight / 2) {
        location.x = self.sliderHeight / 2;
    }else if (location.x >= self.frame.size.width - self.sliderHeight / 2){
        location.x = self.frame.size.width - self.sliderHeight / 2;
    }
    [self updateUIWithCenter:location];
}


@end
