//
//  LLoadingView.h
//  LPhotoBrowser
//
//  Created by lichaowei on 15/12/25.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AnnimationType) {
    AnnimationType_always = 0, //一直转圈
    AnnimationType_percent //根据加载数据转
};

@interface LLoadingView : UIView
{
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}

@property(nonatomic,retain)UIColor *trackColor;
@property(nonatomic,retain)UIColor *progressColor;
@property(nonatomic,assign)CGFloat progress;//0-1
@property(nonatomic,assign)CGFloat progressWidth;
@property(nonatomic,assign)AnnimationType annimationType;


- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
