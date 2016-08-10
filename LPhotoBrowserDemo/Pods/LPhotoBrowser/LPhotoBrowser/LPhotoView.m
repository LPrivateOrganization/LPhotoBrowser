//
//  ZoomImageView.m
//  TestImageAlbum
//
//  Created by lichaowei on 14-6-23.
//  Copyright (c) 2014年 lcw. All rights reserved.
//

#import "LPhotoView.h"

@interface LPhotoView()

@property(nonatomic,retain)LLoadingView *loadingView;

@end

@implementation LPhotoView
{
    BOOL _isZoomed;//当前是否处于放大状态
    
    NSTimer * _tapTimer;//计时点击时间
    
    UIButton * placeHolderButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.delegate = self;
        self.contentMode = UIViewContentModeCenter;
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        self.decelerationRate = .85;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        // create the image view
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)theFrame
{
	// store position of the image view if we're scaled or panned so we can stay at that point
	CGPoint imagePoint = _imageView.frame.origin;
	
	[super setFrame:theFrame];
	
    //原先是使用的theFrame,现在修改为imageFrame
    
    CGRect imageFrame = self.imageView.frame;
    
	// update content size
	self.contentSize = CGSizeMake(imageFrame.size.width * self.zoomScale, imageFrame.size.height * self.zoomScale );
	
    NSLog(@"contentSize %f %f",self.contentSize.width,self.contentSize.height);
	// resize image view and keep it proportional to the current zoom scale
    
	_imageView.frame = CGRectMake(imagePoint.x, imagePoint.y, imageFrame.size.width * self.zoomScale, imageFrame.size.height * self.zoomScale);
}

-(LLoadingView *)loadingView
{
    if (_loadingView) {
        
        return _loadingView;
    }
    _loadingView = [[LLoadingView alloc]initWithFrame:CGRectMake(0, 0, 50,50)];
    _loadingView.backgroundColor = [UIColor clearColor];
    _loadingView.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.f);
    [self addSubview:_loadingView];
    
    _loadingView.trackColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _loadingView.progressColor = [UIColor whiteColor];
    _loadingView.progressWidth = 5.f;
    _loadingView.progress = 0.1f;
    return _loadingView;
}

/**
 *  设置图片下载进度
 *
 *  @param progress
 */
- (void)setProgress:(CGFloat)progress
{
    if (progress < 0) {
        return;
    }
    self.loadingView.progress = progress;
}

#pragma mark - 调整imageView和图片的大小

/**
 *  完成图片加载时调用
 */
- (void)resetImageFrameAfterImageLoaded
{
    //放大倍数归位
    _isZoomed = NO;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    [self setFrame:self.frame];
//    _imageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
}


/**
 *  1、开始显示图片时调用
 *  2、图片要消失时调用
 *  ==按照图片的比例调整imageView
 */
- (void)resetImageFrameWithImage
{
    //放大倍数归位
    _isZoomed = NO;
    [self setZoomScale:self.minimumZoomScale animated:YES];
    
    UIImage *image = self.imageView.image;
    
    if (!image) { //如果image为空
        return;
    }
    
    //跳转imageView和image同等大小
    CGSize imageSize = image.size;
    
    //最大宽度
    CGFloat maxWidth = self.frame.size.width;
    
    //判断宽高
    CGFloat w_h_radio = imageSize.width / imageSize.height;
    
    CGFloat needWidth = 0.f;
    CGFloat needHeight = 0.f;
    //宽大
    if (w_h_radio >= 1) {
        
        needWidth = self.frame.size.width;
        needHeight = needWidth / w_h_radio;
    }
    //高比较大
    else
    {
//        needHeight = self.frame.size.height;
//        needWidth = needHeight * w_h_radio;
//        //如果大于最大宽度
//        if (needWidth > maxWidth) {
//            needWidth = maxWidth;
//            needHeight = needWidth / w_h_radio;
//        }
        
        needWidth = self.frame.size.width;
        needHeight = needWidth / w_h_radio;
        //如果大于最大宽度
        if (needWidth > maxWidth) {
            needWidth = maxWidth;
            needHeight = needWidth / w_h_radio;
        }
    }
    
    CGRect frame = self.imageView.frame;
    frame.size = CGSizeMake(needWidth, needHeight);
    self.imageView.frame = frame;
    self.imageView.clipsToBounds = YES;
    
    //图片高度不够或者宽度不够则居中
    if (needHeight < self.frame.size.height ||
        needWidth < self.frame.size.width) {
        self.imageView.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
    }
}


#pragma - mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
	return _imageView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
	if (touch.tapCount == 2) {
		[self stopTapTimer];
		
		if( _isZoomed )
		{
			_isZoomed = NO;
			[self setZoomScale:self.minimumZoomScale animated:YES];
		}
		else {
			
			_isZoomed = YES;
            
			// define a rect to zoom to.
			CGPoint touchCenter = [touch locationInView:self];
            
            //1/3 区域要放大
            
			CGSize zoomRectSize = CGSizeMake(self.frame.size.width / self.maximumZoomScale, self.frame.size.height / self.maximumZoomScale );
       
            //1/3 区域中心点
            
			CGRect zoomRect = CGRectMake( touchCenter.x - zoomRectSize.width * .5, touchCenter.y - zoomRectSize.height * .5, zoomRectSize.width, zoomRectSize.height );
            
            //下面四个判断 暂未发现什么用处
			
			// correct too far left
			if( zoomRect.origin.x < 0 )
				zoomRect = CGRectMake(0, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far up
			if( zoomRect.origin.y < 0 )
				zoomRect = CGRectMake(zoomRect.origin.x, 0, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far right
			if( zoomRect.origin.x + zoomRect.size.width > self.frame.size.width )
				zoomRect = CGRectMake(self.frame.size.width - zoomRect.size.width, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height );
			
			// correct too far down
			if( zoomRect.origin.y + zoomRect.size.height > self.frame.size.height )
				zoomRect = CGRectMake( zoomRect.origin.x, self.frame.size.height - zoomRect.size.height, zoomRect.size.width, zoomRect.size.height );
			
			// zoom to it.
			[self zoomToRect:zoomRect animated:YES];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([[event allTouches] count] == 1 ) {
		UITouch *touch = [[event allTouches] anyObject];
		if( touch.tapCount == 1 ) {
			if(_tapTimer ) [self stopTapTimer];
			[self startTapTimer];
		}
	}
}

#pragma - mark tap事件、区分单击和双击事件

- (void)startTapTimer
{
	_tapTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:.3] interval:.3 target:self selector:@selector(handleTap) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:_tapTimer forMode:NSDefaultRunLoopMode];
	
}
- (void)stopTapTimer
{
	if([_tapTimer isValid])
		[_tapTimer invalidate];
	
	_tapTimer = nil;
}

- (void)handleTap
{
    NSLog(@"handleTap");
    
    if (_tapBlock) {
        _tapBlock(TapStyleSingle);//单击
    }
}

/**
 *  点击回调
 *
 *  @param tapBlock
 */
-(void)setTapBlock:(void (^)(TapStyle style))tapBlock
{
    _tapBlock = tapBlock;
}

@end
