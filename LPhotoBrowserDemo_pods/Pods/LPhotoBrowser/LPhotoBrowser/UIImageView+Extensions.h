//
//  UIImageView+Extensions.h
//  YiYiProject
//
//  Created by lichaowei on 15/5/6.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface UIImageView (Extensions)

/**
 *  imageView 封装一个button,支持点击
 *
 *  @param target   target
 *  @param selector slector
 *  @param tag      包含button tag值
 */
- (void)addTaget:(id)target action:(SEL)selector tag:(int)tag;

/**
 *  给imageView加圆角
 *
 *  @param radius 角度
 */
- (void)addCornerRadius:(CGFloat)radius;

/**
 *  加圆角==>圆形
 */
- (void)addRoundCorner;


/**
 *  imageView赋值image 适用于imageView不定大小情况 placeHolder比较小
 *
 *  @param url         图片地址
 *  @param placeholder 默认图标
 */
- (void)l_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)l_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

@end
