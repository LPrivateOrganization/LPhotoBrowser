//
//  ViewController.m
//  LPhotoBrowser
//
//  Created by lichaowei on 15/12/23.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import "ViewController.h"
#import "LPhotoBrowser.h"
#import "LPhotoModel.h"
#import "TableViewCell.h"
#import "UIImageView+Extensions.h"
#import "LLoadingView.h"
#import "SVProgressHUD.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    CGFloat _progress;
    LLoadingView *loading;
}

@property(nonatomic,retain)NSArray *imagesArray;
@property(nonatomic,retain)NSArray *imagesUrlArray;
@property(nonatomic,retain)NSArray *imagesThumbArray;//网络图的缩略图


@end

@implementation ViewController

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    CGFloat width = (DEVICE_WIDTH - 30) / 3.f ;
//    CGFloat height = width;
//    CGFloat left = (DEVICE_WIDTH - width * 3)/3.f;
//    
//    int count = (int)self.imagesArray.count;
//    for (int i = 0; i < count; i ++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(left + (width + left/2.f) * (i % 3), 110 + 10 + (height + left/2.f) * (i / 3), width, height)];
//        [self.view addSubview:imageView];
//        
//        imageView.image = self.imagesArray[i];
//        
//        imageView.userInteractionEnabled = YES;
//        
//        //important
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.clipsToBounds = YES;
//        //end
//        
//        imageView.tag = 100 + i;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToDo:)];
//        [imageView addGestureRecognizer:tap];
//    }
    
    self.navigationItem.title = @"左本地 <- | -> 右网络";
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
//
//    self.view.backgroundColor = [UIColor blackColor];
//
//    loading = [[LLoadingView alloc]initWithFrame:CGRectMake(0, 64, 100,100)];
//    loading.backgroundColor = [UIColor redColor];
//    [self.view addSubview:loading];
//    
//    loading.trackColor = [UIColor grayColor];
//    loading.progressColor = [UIColor whiteColor];
//    loading.progressWidth = 5.f;
    
    //test SVProgressView
//    _progress = 0.f;
//

    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    btn.frame = CGRectMake(100, 300, 100, 100);
//    [btn setTitle:@"start" forState:UIControlStateNormal];
//    [btn setTitle:@"end" forState:UIControlStateSelected];
//    [btn addTarget:self action:@selector(clickSender:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
}

- (void)clickSender:(UIButton *)sender
{
    _progress += 0.1;
    
    if (_progress >= 1) {
        _progress = 0.1;
    }
//    [SVProgressHUD showProgress:_progress];
    loading.progress = _progress;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

-(NSArray *)imagesArray
{
    if (_imagesArray) {
        return _imagesArray;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i = 0; i < 6; i ++) {
        
        NSString *name = [NSString stringWithFormat:@"%d.jpg",i + 1];
        UIImage *aImage = [UIImage imageNamed:name];
        [temp addObject:aImage];
    }
    _imagesArray = [NSArray arrayWithArray:temp];
    return _imagesArray;
}

-(NSArray *)imagesThumbArray
{
    if (_imagesThumbArray) {
        return _imagesThumbArray;
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i = 0; i < 7; i ++) {
        
        NSString *name = [NSString stringWithFormat:@"thumnb_%d.jpg",i];
        UIImage *aImage = [UIImage imageNamed:name];
        [temp addObject:aImage];
    }
    _imagesThumbArray = [NSArray arrayWithArray:temp];
    return _imagesThumbArray;
}

-(NSArray *)imagesUrlArray
{
//    return @[@"http://img2.3lian.com/2014/f5/158/d/88.jpg",
//             @"http://ww1.sinaimg.cn/mw600/bce7ca57gw1e4rg0coeqqj20dw099myu.jpg",
//             @"http://img2.100bt.com/upload/ttq/20120831/1346406424571.jpg",
//             @"http://ww2.sinaimg.cn/mw600/a31e12fegw1e7lhgea32dj208d0cjaap.jpg",
//             @"http://ww2.sinaimg.cn/large/8989048bjw1dutawvaz66j.jpg",
//             @"http://pic32.nipic.com/20130813/9422601_092143960000_2.jpg"];
    
    return
    @[@"http://d.hiphotos.baidu.com/zhidao/pic/item/ac345982b2b7d0a237800395c8ef76094b369a68.jpg",
      @"http://d.3987.com/cglm_130903/003.jpg",
      @"http://imgsrc.baidu.com/forum/pic/item/d50735fae6cd7b89d0c699180f2442a7d8330e86.jpg",
      @"http://bbs.loorin.com/data/attachment/forum/201404/07/152729wg061nlrh02z043a.jpg",
      @"http://bbs.loorin.com/data/attachment/forum/201404/07/152826c3bgwejtt33t3xtt.jpg",
      @"http://imgsrc.baidu.com/forum/pic/item/bf096b63f6246b60be8711efebf81a4c500fa2a4.jpg",
      @"http://bbs.loorin.com/data/attachment/forum/201404/07/152713g77n823nq779rsn7.jpg"];
}


- (UIImageView *)imageViewWithTag:(NSUInteger)tag
{
    return [self.view viewWithTag:tag];
}

#pragma mark - 事件处理

- (void)tapToDo:(UITapGestureRecognizer *)tap
{
    NSInteger initPage = tap.view.tag - 100;
    
    [LPhotoBrowser showWithViewController:self initIndex:initPage photoModelBlock:^NSArray *{
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:7];
        
        for (int i = 0; i < 7; i ++) {
            
            NSString *name = [NSString stringWithFormat:@"%d.jpg",i + 1];
            LPhotoModel *photo = [[LPhotoModel alloc]init];
            photo.image = [UIImage imageNamed:name];
            photo.sourceImageView = [self imageViewWithTag:100 + i];
            photo.thumbImage = self.imagesArray[i];
            [temp addObject:photo];
        }
        
        return temp;
    }];
}

- (void)selectAtIndex:(NSInteger)index location:(Location)location
{
    NSInteger initPage = index;
    
     @WeakObj(self);
    [LPhotoBrowser showWithViewController:self initIndex:initPage photoModelBlock:^NSArray *{
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:7];
        
        for (int i = 0; i < Weakself.imagesArray.count; i ++) {
            
            UITableViewCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            UIImageView *imageView = nil;
            
            LPhotoModel *photo = [[LPhotoModel alloc]init];

            //本地
            if (location == Location_left) {
                NSString *name = [NSString stringWithFormat:@"%d.jpg",i + 1];
                photo.image = [UIImage imageNamed:name];
                imageView = [cell.contentView viewWithTag:100];
                photo.thumbImage = self.imagesArray[i];

            }
            //网络
            else if (location == Location_right){
                photo.imageUrl = Weakself.imagesUrlArray[i];
                imageView = [cell.contentView viewWithTag:101];
                photo.thumbImage = imageView.image;
            }
            photo.sourceImageView = imageView;
            [temp addObject:photo];
        }
        
        return temp;
    }];
}

#pragma mark - 视图创建

#pragma mark - 网络请求

#pragma mark - 数据解析处理

#pragma mark - 事件处理

#pragma mark - 代理

#pragma - mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma - mark UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.imagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *leftImageView = cell.leftImageView;
    leftImageView.image = self.imagesArray[indexPath.row];
    
    UIImageView *rightImageView = cell.rightImageView;
    rightImageView.image = self.imagesThumbArray[indexPath.row];
    
    cell.indexRow = indexPath.row;
     @WeakObj(self);
    [cell setTapBlock:^(Location location, NSInteger indexRow) {
       
        [Weakself selectAtIndex:indexRow location:location];
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
