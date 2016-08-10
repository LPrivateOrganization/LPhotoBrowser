//
//  PhotoBrowserController.m
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/12/18.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import "LPhotoBrowser.h"
#import "LPhotoBrowserView.h"
#import "LPhotoModel.h"

@interface LPhotoBrowser ()<UIActionSheetDelegate>
{
    UIViewController *_vc;
}

/** 外部操作控制器 */
@property (nonatomic,weak) UIViewController *handleVC;
/** 相册数组 */
@property (nonatomic,strong) NSArray *photoModels;
/** 初始显示的index */
@property (nonatomic,assign) NSUInteger initIndex;
/** page */
@property (nonatomic,assign) NSUInteger page;

@property (nonatomic,strong)LPhotoBrowserView *browserView;

@property (nonatomic,strong)UIButton *closeButton;

@property (nonatomic,strong)UIView *backgroudView;//背景view

@end

@implementation LPhotoBrowser

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //去除自动处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.backgroudView];

    //每页数据准备
    self.browserView = [[LPhotoBrowserView alloc]initWithFrame:self.view.bounds withImagesArr:self.photoModels initPage:(int)self.initIndex];
    [self.view addSubview:_browserView];
    
    
    //长按手势
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_browserView addGestureRecognizer:press];
    
    //点击回调
     @WeakObj(self);
    [_browserView setSingleTapBlock:^(NSInteger tapIndex) {
       
        NSLog(@"单击 %d",(int)tapIndex);
        [Weakself dismiss];
        
    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    NSLog(@"longPress %d",(int)gesture.state);
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_8_0

        /**
         *  这部分有问题
         */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        
         @WeakObj(self);
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存到手机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [Weakself saveImage];
        }];
        [alert addAction:saveAction];
        
        alert.view.window.windowLevel = UIWindowLevelAlert + 2;
        [_handleVC.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
#else
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        [sheet showInView:self.view];
        
#endif
        
        
    }
}

#pragma mark - 保存图片到本地

- (void)saveImage
{
    UIImage *image = self.browserView.currentImage;
    
    if (image)
    {
        UIImageWriteToSavedPhotosAlbum(image,self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        
//        [LTools showMBProgressWithText:@"保存图片成功" addToView:self.view];
    }
    
}

#pragma mark - UIActionSheetDelegate <NSObject>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        NSLog(@"保存");
        [self saveImage];
    }
}
#endif

+ (void)showWithViewController:(UIViewController *)viewController initIndex:(NSUInteger)initIndex photoModelBlock:(NSArray *(^)())photoModelBlock{
    
    //取出相册数组
    NSArray *photoModels = photoModelBlock();
    
    if(photoModels == nil || photoModels.count == 0) return;
    
    LPhotoBrowser *pbVC = [[self alloc] init];
    
    if(initIndex >= photoModels.count){
        NSLog(@"erro:index越界！");
        return;
    }
    pbVC.handleVC = viewController;
    pbVC.photoModels = photoModels;
    pbVC.initIndex = initIndex;
    //展示
    [pbVC show:YES];
}

#pragma mark - getter

/**
 *  背景
 *
 *  @return
 */
-(UIView *)backgroudView
{
    if (!_backgroudView) {
        _backgroudView = [[UIView alloc]initWithFrame:self.view.bounds];
        _backgroudView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_backgroudView];
        _backgroudView.alpha = 0.f;
    }
    return _backgroudView;
}

-(UIButton *)closeButton
{
    if (_closeButton) {
        return _closeButton;
    }
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    close.frame = CGRectMake(20, 20, 50, 50);
    close.backgroundColor = [UIColor orangeColor];
    [close setTitle:@"关闭" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = close;
    return _closeButton;
}

/**
 *  获取相册当前第几页
 *
 *  @return
 */
-(NSUInteger)page
{
    return  self.browserView.currentPage;
}

#pragma mark - setter

/**
 *  设置数据源
 *
 *  @param photoModels
 */
-(void)setPhotoModels:(NSArray *)photoModels{
    
    _photoModels = photoModels;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //初始化页码信息
        self.page = _initIndex;
    });
}

-(void)setInitIndex:(NSUInteger)initIndex
{
    _initIndex = initIndex;
}


#pragma mark - 事件处理

/**
 *  相册隐藏
 */
-(void)dismiss{

    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.browserView.userInteractionEnabled = NO;//开始消失的过程,关闭交互
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.backgroudView.backgroundColor = [UIColor clearColor];
    
    LPhotoModel *photoModel = self.photoModels[self.page];
    
    CGRect sourceF = photoModel.sourceFrame;
    
    //检查sourceF是否在屏幕里面
    CGRect screenF =[UIScreen mainScreen].bounds;
    
    BOOL isInScreen = CGRectIntersectsRect(sourceF, screenF);
    
    if(photoModel.sourceImageView == nil) isInScreen = NO;
    
     @WeakObj(self);
    if(isInScreen){
        
        [self.browserView dismiss:^{
            
            [Weakself show:NO];
        }];
        
    }else{
        
        [UIView animateWithDuration:.5f animations:^{
            
            self.view.transform= CGAffineTransformMakeScale(1.2, 1.2);
            self.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [Weakself show:NO];
        }];
    }
}


#pragma - mark 控制显示和消失处理

/** 真正展示 */
-(void)show:(BOOL)show
{
    if (show) {
        
        //拿到window
        UIWindow *window = _handleVC.view.window;
        if(window == nil){
            NSLog(@"erro：窗口为空！");
            return;
        }
        self.view.frame = [UIScreen mainScreen].bounds;
        //添加视图
        [window addSubview:self.view];
        //添加子控制器
        [_handleVC addChildViewController:self];
        
        //显示状态栏
         @WeakObj(self);
        [UIView animateWithDuration:0.5 animations:^{
            Weakself.backgroudView.alpha = 1.f;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        } completion:^(BOOL finished) {
            
        }];
        
    }else
    {
        _handleVC = nil;
        self.photoModels = nil;
        //移除视图
        [self.view removeFromSuperview];
        self.view = nil;
        //移除
        [self removeFromParentViewController];
    }
}

@end
