//
//  PhotoBrowserController.h
//  TestPhotoBrowser
//
//  Created by lichaowei on 15/12/18.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPhotoHeader.h"

@interface LPhotoBrowser : UIViewController

+ (void)showWithViewController:(UIViewController *)viewController initIndex:(NSUInteger)initIndex photoModelBlock:(NSArray *(^)())photoModelBlock;

@end
