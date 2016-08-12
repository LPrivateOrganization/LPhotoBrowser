# LPhotoBrowser
---
LPhotoBrowser主要用来多张图片浏览，支持本地、网络图片。点击小图浏览大图有过度动画，提高操作体验。
#介绍
**一、使用[CocoaPods](http://cocoapods.org)**

1、在Podfile添加pod 'LPhotoBrowser'
 
```ruby
pod 'LPhotoBrowser', '~> 1.0.0'
```
2、在终端运行`pod install`,之后需要使用`.xcworkspace`来启动项目.
3、在需要使用的地方`#import "LPhotoBrowser.h"`

**二、GitHub下载**

1、在[LPhotoBrowser下载地址](https://github.com/LPrivateOrganization/LPhotoBrowser/tree/master/LPhotoBrowser)下载文件

2.把下载的文件都add到工程里面

3、在需要使用的地方`#import "LPhotoBrowser.h"`

#示例

**示例目录**

1、pods使用[demo](https://github.com/LPrivateOrganization/LPhotoBrowser/tree/master/LPhotoBrowserDemo_pods)
在目录`LPhotoBrowserDemo_pods`使用pod方式
2、静态文件[demo](https://github.com/LPrivateOrganization/LPhotoBrowser/tree/master/LPhotoBrowserDemo)
`LPhotoBrowserDemo` 静态文件方式

**使用**

```objc
/**
 *  调用图片浏览器
 *
 *  @param viewController  目标viewController
 *  @param initIndex       初始显示index
 *  @param photoModelBlock LPhotoModel的数组
 */
+ (void)showWithViewController:(UIViewController *)viewController initIndex:(NSUInteger)initIndex photoModelBlock:(NSArray *(^)())photoModelBlock;

@WeakObj(self);
[LPhotoBrowser showWithViewController:`目标viewController` initIndex:`初始页数` photoModelBlock:^NSArray *{
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < `存放图片或者图片url的数组`.count; i ++) {
            UIImageView *imageView = nil;
            LPhotoModel *photo = [[LPhotoModel alloc]init];
            //本地
            if (location == Location_left) {
                photo.image = `index = i对应UIImage`;
                photo.thumbImage = `index = i对应缩略图UIImage`;
            }
            //网络
            else if (location == Location_right){
                photo.imageUrl = `index = i对应图片url`;;
                photo.thumbImage = `index = i对应缩略图UIImage`;
            }
            photo.sourceImageView = `点击小图所在imageView`;
            [temp addObject:photo];
        }
        return temp;
    }];
```

#许可
MIT
