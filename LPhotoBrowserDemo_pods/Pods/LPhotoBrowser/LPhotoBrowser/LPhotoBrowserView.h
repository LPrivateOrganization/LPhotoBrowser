//
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/4/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPhotoModel.h"


@interface LPhotoBrowserView : UIView<UIScrollViewDelegate>

@property(nonatomic,retain)UIScrollView *imageScroll;
@property(nonatomic,retain)NSArray *imageArr;
@property(nonatomic,readonly)NSInteger currentPage;
@property(nonatomic,readonly)UIImage *currentImage;//当前image

@property (nonatomic,copy)void(^ singleTapBlock)(NSInteger tapIndex);//点击回调
@property (nonatomic,copy)void(^ changePageBlock)(NSInteger sumPage,NSInteger currentPage);//页面切换

-(instancetype)initWithFrame:(CGRect)frame
               withImagesArr:(NSArray *)imageArray
                    initPage:(int)initPage;//初始化

/**
 *  关闭相册
 *
 *  @param completion 完成之后调用
 */
- (void)dismiss:(void (^)())completion;

/**
 *  单击回调
 *
 *  @param singleTapBlock
 */

-(void)setSingleTapBlock:(void (^)(NSInteger tapIndex))singleTapBlock;



@end
