//
//  LPhotoHeader.h
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/12/23.
//  Copyright © 2015年 lcw. All rights reserved.
//

#ifndef LPhotoHeader_h
#define LPhotoHeader_h


///屏幕宽度
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
///屏幕高度
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

//===================== weak 和 strong
#pragma mark - weak 和 strong
#define WeakObj(o) autoreleasepool{} __weak typeof(o) Weak##o = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#import "UIImageView+Extensions.h"
#import "LPhotoModel.h"

//==============================打印类、方法
#pragma mark - Debug log macro

#endif /* LPhotoHeader_h */
