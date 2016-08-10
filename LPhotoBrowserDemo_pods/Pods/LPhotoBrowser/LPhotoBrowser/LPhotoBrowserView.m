//
//  PhotoBrowserView.m
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/4/3.
//  Copyright (c) 2015年 lcw. All rights reserved.
//

#import "LPhotoBrowserView.h"
#import "LPhotoHeader.h"
#import "LPhotoView.h"
#import "UIImageView+WebCache.h"

#define kCurrentTag 1000
#define kNextTag 1001
#define kLastTag 1002

@interface LPhotoBrowserView ()
{
    NSInteger _pageIndex;
    NSInteger _itemIndex;
    NSInteger _sumPage;//总页数
}
@property(nonatomic,assign)NSInteger initPage;

@property(nonatomic,retain)NSMutableDictionary *viewsDictionary;
@property(nonatomic,retain)UIView *backgroudView;//背景view
@property (nonatomic,strong)UILabel *numLabel;//显示页数

@end

@implementation LPhotoBrowserView

-(instancetype)initWithFrame:(CGRect)frame
               withImagesArr:(NSArray *)imageArray
                    initPage:(int)initPage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backgroudView];
        self.backgroundColor = [UIColor clearColor];
        
        self.imageArr = [NSArray arrayWithArray:imageArray];
        
        _sumPage = _imageArr.count;
        
        self.imageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageScroll.contentSize = CGSizeMake(frame.size.width * (imageArray.count), frame.size.height);
        _imageScroll.backgroundColor = [UIColor clearColor];
        _imageScroll.showsHorizontalScrollIndicator = NO;
        _imageScroll.showsVerticalScrollIndicator = NO;
        _imageScroll.delegate = self;
        _imageScroll.pagingEnabled = YES;
        _imageScroll.scrollEnabled = YES;
//        _imageScroll.bounces = NO;
        _imageScroll.contentOffset = CGPointMake(_imageScroll.frame.size.width*initPage, 0);
        [self addSubview:_imageScroll];
        
        //显示数字
        [self addSubview:self.numLabel];
        
        //初始显示
        [self setInitPage:initPage];
    }
    return self;
}


#pragma mark - 显示和隐藏

-(void)setInitPage:(NSInteger)initPage
{
    self.viewsDictionary = [NSMutableDictionary dictionary];
    
    _initPage = initPage;
    
    LPhotoModel *photo = [self photoModelAtIndex:initPage];
    photo.firstShow = YES;//第一个显示
    
    //配置scrollView
    [self configScrowViewWithIndex:initPage withForward:NO withOrigin:YES];
    
    _pageIndex = _itemIndex = initPage;
    
    LPhotoView *zoom = [self configItemWithIndex:initPage];
    UIImageView *item = zoom.imageView;
    CGRect realFrame = item.frame;
    
    
    CGRect sourceFrame = photo.sourceFrame;
    if (CGRectIsEmpty(sourceFrame) || CGRectIsNull(sourceFrame)) {
        
        sourceFrame = CGRectMake(self.frame.size.width/2.f, self.frame.size.height/2.f, 0, 0);
    }
    
    item.frame = sourceFrame;
    
    item.contentMode=UIViewContentModeScaleAspectFill;
    item.clipsToBounds = YES;
    
    __weak typeof(self)weakSelf = self;
     @WeakObj(photo);
    [UIView animateWithDuration:0.3f animations:^{
        item.frame = realFrame;
        weakSelf.backgroudView.alpha = 1.f;
        [zoom resetImageFrameWithImage];
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            Weakphoto.firstShow = NO;//修改第一加载状态
            //开始下载图
            [self loadImageIndex:initPage];
        }
    }];
}

/**
 *  控制图片加载
 *
 *  @param index
 */
- (void)loadImageIndex:(NSInteger)index
{
    LPhotoView *zoom = [self configItemWithIndex:index];
    LPhotoModel *photo = [self photoModelAtIndex:index];
    
    if (photo.isImageUrl) {
        
        //第一个显示的先不加载完了数据
        if (!photo.firstShow) {
            
            //默认显示  photo.thumbImage,下载失败显示imageFail
            @WeakObj(zoom);
            UIImage *placeHolder = photo.thumbImage;
            
            [zoom.imageView sd_setImageWithURL:[NSURL URLWithString:photo.imageUrl] placeholderImage:placeHolder options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
                CGFloat radio = (CGFloat)receivedSize/expectedSize;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (radio > 0) {
                        [Weakzoom setProgress:radio];
                    }
                });
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image && !error) {
                    //下载完成
                    [Weakzoom resetImageFrameWithImage];//失败时按照失败照片调整
                    [Weakzoom resetImageFrameAfterImageLoaded];
                }else
                {
                    Weakzoom.imageView.image = [UIImage imageNamed:@"imageFail"];
                    [Weakzoom resetImageFrameWithImage];//失败时按照失败照片调整
                }
            }];
            
        }else
        {
            zoom.imageView.image = photo.thumbImage;
            [zoom resetImageFrameAfterImageLoaded];

        }
        
    }else
    {
        zoom.imageView.image = photo.image;

    }
}

- (void)stopDownload
{
    
}


/**
 *  关闭相册
 *
 *  @param completion 完成之后调用
 */
- (void)dismiss:(void (^)())completion
{
    LPhotoView *item = [self configItemWithIndex:_pageIndex];
    
    [item resetImageFrameWithImage];//important
    
    LPhotoModel *photo = [self photoModelAtIndex:_pageIndex];
    CGRect sourceFrame = photo.sourceFrame;
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{

        weakSelf.backgroudView.alpha = 0.f;
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        item.imageView.contentMode = photo.sourceImageView.contentMode;
        item.imageView.frame = sourceFrame;
        
    }completion:^(BOOL finished) {
        
        if (finished) {
            
            if (completion) {
                completion();
            }
        }
    }];
}

#pragma mark - getter

-(UIView *)backgroudView
{
    if (_backgroudView) {
        return _backgroudView;
    }
    _backgroudView = [[UIView alloc]initWithFrame:self.bounds];
    _backgroudView.backgroundColor = [UIColor blackColor];
    _backgroudView.alpha = 0.f;
    return _backgroudView;
}

/**
 *  获取当前页
 *
 *  @return
 */
-(NSInteger)currentPage
{
    return _pageIndex;
}

/**
 *  获取当前image
 *
 *  @return
 */
-(UIImage *)currentImage
{
    LPhotoView *zoom = [self configItemWithIndex:_pageIndex];
    UIImage *image = zoom.imageView.image;
    if (image && [image isKindOfClass:[UIImage class]]) {
        return image;
    }
    return nil;
}

/**
 *  显示页数
 *
 *  @return
 */
-(UILabel *)numLabel
{
    if (_numLabel) {
        return _numLabel;
    }
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 30, CGRectGetWidth(self.frame),30)];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    return _numLabel;
}

#pragma mark - 事件处理

/**
 *  单击回调
 *
 *  @param singleTapBlock
 */

-(void)setSingleTapBlock:(void (^)(NSInteger))singleTapBlock
{
    _singleTapBlock = singleTapBlock;
}

/**
 *  点击回调
 */
- (void)singleTap
{
    if (_singleTapBlock) {
        _singleTapBlock(self.currentPage);
    }
}

/**
 *  控制数字是否显示
 *
 *  @param show
 */
- (void)numLabelShow:(BOOL)show
{
    /**
     *  隐藏数字
     */
    if (show) {
        
        _numLabel.alpha = 1.f;
        
    }else{
        if (_imageScroll.tracking) {
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @WeakObj(_numLabel);
            [UIView animateWithDuration:3.f animations:^{
                Weak_numLabel.alpha = 0.f;
            }];
        });
    }
}

#pragma mark - configScrollView

- (LPhotoModel *)photoModelAtIndex:(NSInteger)index
{
    return (LPhotoModel *)[self.imageArr objectAtIndex:index];
}

//根据页数,创建imageView
- (LPhotoView *)configItemWithIndex:(NSInteger)pageIndex
{
    if (pageIndex < 0 || pageIndex > [_imageArr count]-1) {
        return nil;
    }
    
    NSString *key = [NSString stringWithFormat:@"scroll%d",(int)pageIndex];
    LPhotoView *view = self.viewsDictionary[key];
    if (view && [view isKindOfClass:[LPhotoView class]]) {
        
        return view;
    }
    
    LPhotoView *firstView = [[LPhotoView alloc]initWithFrame:CGRectMake(_imageScroll.frame.size.width*pageIndex, 0, _imageScroll.frame.size.width, _imageScroll.frame.size.height) ];

    [self.viewsDictionary setObject:firstView forKey:key];//记录
    
     @WeakObj(self);
    //点击回调
    [firstView setTapBlock:^(TapStyle style) {
        
        if (Weakself) {
            [Weakself singleTap];
        }
    }];
    
    //图片加载
    [self loadImageIndex:pageIndex];
    
    return firstView;
}

- (void)imageFinishDownLoad
{
    NSLog(@"下载完成");
}
//配置index 第几页 forward是否向前滑动 origin,是否第一次
- (void)configScrowViewWithIndex:(NSInteger)index
                     withForward:(BOOL)isForward
                      withOrigin:(BOOL)isOrigin
{
    if ([_imageArr count] < 1) {
        return;
    }
    //当偏移量是0的话加载当前的索引的视图和前后的视图（如果存在的话）
    if (isOrigin) {
        LPhotoView *currentView = [self configItemWithIndex:index];
        if (currentView) {
            currentView.tag = kCurrentTag;
            [_imageScroll addSubview:currentView];
            
        }
        
        LPhotoView *nextView = [self configItemWithIndex:index+1];
        if (nextView) {
            nextView.tag = kNextTag;
            [_imageScroll addSubview:nextView];
            
        }
        LPhotoView *lastView = [self configItemWithIndex:index-1];
        if(lastView)
        {
            lastView.tag = kLastTag;
            [_imageScroll addSubview:lastView];
        }
        
    }
    else {
        //如果向前滑动的话，加载下一张试图的后一张试图，同时移除上一张试图的前一张试图
        if (isForward) {
            if ([_imageScroll viewWithTag:kLastTag])
            {
                [[_imageScroll viewWithTag:kLastTag]removeFromSuperview];//移出前一个视图
            }
            if ([_imageScroll viewWithTag:kNextTag])
            {
                //如果下个视图存在
                UIView *currentView = [_imageScroll viewWithTag:kCurrentTag];
                currentView.tag = kLastTag;
                UIView *view =  [_imageScroll viewWithTag:kNextTag];
                view.tag = kCurrentTag;
                
                LPhotoView *nextView = [self configItemWithIndex:index+1];
                if (nextView) {
                    nextView.tag = kNextTag;
                    [_imageScroll addSubview:nextView];
                }
                
            }
        }
        //如果向后滑动的话，加载上一张试图的前一张试图，同时移除下一张试图的后一张试图
        else {
            if ([_imageScroll viewWithTag:kNextTag]) {
                [[_imageScroll viewWithTag:kNextTag]removeFromSuperview];//移出后一个视图
            }
            if ([_imageScroll viewWithTag:kLastTag]) { //如果上个视图存在
                UIView *currentView = [_imageScroll viewWithTag:kCurrentTag];
                currentView.tag = kNextTag;
                UIView *view =  [_imageScroll viewWithTag:kLastTag];
                view.tag     = kCurrentTag;
                LPhotoView *lastView = [self configItemWithIndex:index-1];
                if (lastView) {
                    lastView.tag = kLastTag;
                    [_imageScroll addSubview:lastView];
                }
            }
            
        }
        
    }
    
}
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int beforeIndex = (int)_pageIndex;
    _pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;//只要大于半页就算下一页
    if (_pageIndex>beforeIndex) {
        _itemIndex ++;
        [self configScrowViewWithIndex:_itemIndex withForward:YES withOrigin:NO];
    }
    else if(_pageIndex<beforeIndex) {
        _itemIndex --;
        [self configScrowViewWithIndex:_itemIndex withForward:NO withOrigin:NO];
    }
    //页数变化
    if (_changePageBlock) {
        _changePageBlock(_sumPage,_pageIndex);
    }
    
    _numLabel.text = [NSString stringWithFormat:@"%d / %d",(int)_pageIndex + 1,(int)_sumPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    /**
     *  切换页面的时候,大小还原
     */
    LPhotoView *zoom_last = [self configItemWithIndex:_pageIndex - 1];
    LPhotoView *zoom_next = [self configItemWithIndex:_pageIndex + 1];
    
    if (zoom_last) {
        [zoom_last resetImageFrameWithImage];
    }
    if (zoom_next) {
        [zoom_next resetImageFrameWithImage];
    }
    
    [self numLabelShow:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self numLabelShow:YES];
}

@end
