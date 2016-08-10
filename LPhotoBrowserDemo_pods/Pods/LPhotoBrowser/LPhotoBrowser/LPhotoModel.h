//
//  PhotoModel.h
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/12/18.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LPhotoModel : NSObject

@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)UIImage *thumbImage;//缩略图
@property(nonatomic,weak)UIImageView *sourceImageView;//源imageView
@property(nonatomic,assign)CGRect sourceFrame;//源imageView位置

@property(nonatomic,assign,readonly)BOOL isImageUrl;//网络图片
@property(nonatomic,assign)BOOL firstShow;//是否是第一个开始显示

@end
