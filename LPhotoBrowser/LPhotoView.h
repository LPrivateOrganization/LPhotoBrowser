//
//  ZoomImageView.h
//  TestImageAlbum
//
//  Created by lichaowei on 14-6-23.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLoadingView.h"

typedef NS_ENUM(NSInteger,TapStyle) {
    TapStyleSingle = 0,//单击
    TapStyleDouble //双击
};
@interface LPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,copy)void(^ tapBlock)(TapStyle style);

-(void)setTapBlock:(void (^)(TapStyle style))tapBlock;

/**
 *  完成图片加载时调用
 */
- (void)resetImageFrameAfterImageLoaded;

/**
 *  1、开始显示图片时调用
 *  2、图片要消失时调用
 *  ==按照图片的比例调整imageView
 */
- (void)resetImageFrameWithImage;

/**
 *  设置图片下载进度
 *
 *  @param progress
 */
- (void)setProgress:(CGFloat)progress;


@end
