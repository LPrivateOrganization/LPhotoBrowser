//
//  TableViewCell.h
//  LPhotoBrowser
//
//  Created by lichaowei on 15/12/23.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,Location) {
    Location_left = 0,//左
    Location_right //右
};
@interface TableViewCell : UITableViewCell
@property(nonatomic,assign)NSInteger indexRow;//行
@property(nonatomic,retain)UIImageView *leftImageView;
@property(nonatomic,retain)UIImageView *rightImageView;

@property(nonatomic,copy)void(^tapBlock)(Location location,NSInteger indexRow);

-(void)setTapBlock:(void (^)(Location location, NSInteger indexRow))tapBlock;

@end
