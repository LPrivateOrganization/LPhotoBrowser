//
//  PhotoModel.m
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/12/18.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import "LPhotoModel.h"

@implementation LPhotoModel

-(CGRect)sourceFrame
{
    return [_sourceImageView convertRect:_sourceImageView.bounds toView:_sourceImageView.window];
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    if ([imageUrl isKindOfClass:[NSString class]] || [imageUrl hasPrefix:@"http"]) {
        _isImageUrl = YES;//是网络图片
    }
}

@end
