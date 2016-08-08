//
//  LLoadingView.m
//  LPhotoBrowser
//
//  Created by lichaowei on 15/12/25.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import "LLoadingView.h"

@interface LLoadingView ()
{
    BOOL _isAddPath;//是否加载过转圈path
}

@property(nonatomic,retain)UILabel *percentLabel;//百分比
@property(nonatomic,assign)CGFloat percent;//
@property(nonatomic,retain)NSTimer *timer;

@end

@implementation LLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _trackLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        _progressLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        
        self.progressWidth = 5.f;
        _annimationType = AnnimationType_always;//一直转圈
        _isAddPath = NO;//默认没加
        
    }
    return self;
}


#pragma mark - 事件处理
//设置轨迹
-(void)setTrack
{
    CGPoint point = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    CGFloat radius = (self.bounds.size.width - _progressWidth) / 2.f;
    _trackPath = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _trackLayer.path = _trackPath.CGPath;
}

//完成部分
- (void)setProgressWithProgress:(CGFloat)progress{
    
    CGPoint point = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    CGFloat radius = (self.bounds.size.width - _progressWidth) / 2.f;
    _progressPath = [UIBezierPath bezierPathWithArcCenter:point radius:radius startAngle:- M_PI_2 endAngle:(M_PI * 2 * progress - M_PI_2) clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
}

-(void)setProgress:(float)progress animated:(BOOL)animated
{
    
}

#pragma mark - getter

-(UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _percentLabel.font = [UIFont systemFontOfSize:10.f];
        _percentLabel.backgroundColor = [UIColor clearColor];
        _percentLabel.textColor = [UIColor whiteColor];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_percentLabel];
    }
    return _percentLabel;
}

#pragma mark - setter

-(void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = progressWidth;
    _progressLayer.lineWidth = progressWidth;
    
    [self setTrack];
    [self setProgressWithProgress:_progress];
}

-(void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

-(void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

/**
 *  设置动画类型
 *
 *  @param annimationType
 */
-(void)setAnnimationType:(AnnimationType )annimationType
{
    _annimationType = annimationType;
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress < 0 ? 0 : progress;

    if (_annimationType == AnnimationType_always) {
        
        
        if (_isAddPath == NO) {
            [self setProgressWithProgress:0.7];//设置固定的
            [self startProgressAnimation];//一直转圈
            _isAddPath = YES;
        }
        
        if (progress >= 1.f) {
            
            [self setProgressWithProgress:1.f];
            [self stopProgressAnimation];//停止
        }
        
    }else if (_annimationType == AnnimationType_percent){
        
        [self setProgressWithProgress:_progress];//百分比
    }
    
    if (progress >= 1.0) {
        self.percentLabel.text = @"完成";
        [self removeFromSuperview];
        
    }else if(progress >= 0)
    {
        self.percentLabel.text = [NSString stringWithFormat:@"%.f%%",progress * 100];
    }
}

/**
 *  开始转圈
 */
- (void)startProgressAnimation
{
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    theAnimation.duration = 1.f;
    theAnimation.repeatCount = MAXFLOAT;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fromValue = [NSNumber numberWithFloat:0];
    theAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    [_progressLayer addAnimation:theAnimation forKey:@"animateTransform"];
}

/**
 *  结束转圈
 */
- (void)stopProgressAnimation
{
    CFTimeInterval pausedTime = [_progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    _progressLayer.speed = 0.0;
    _progressLayer.timeOffset = pausedTime;
    [_progressLayer removeAllAnimations];
}

@end
