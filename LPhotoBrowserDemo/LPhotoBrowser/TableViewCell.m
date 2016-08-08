//
//  TableViewCell.m
//  LPhotoBrowser
//
//  Created by lichaowei on 15/12/23.
//  Copyright © 2015年 lcw. All rights reserved.
//

#import "TableViewCell.h"
#import "LPhotoHeader.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, (DEVICE_WIDTH - 20 - 10)/2.f, 130)];
        [self.contentView addSubview:_leftImageView];
        //important
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        //end
        _leftImageView.tag = 100;
        _leftImageView.userInteractionEnabled = YES;
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame) + 10, 10, (DEVICE_WIDTH - 20 - 10)/2.f, 130)];
        [self.contentView addSubview:_rightImageView];
        //important
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        //end
        _rightImageView.tag = 101;
        _rightImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [_leftImageView addGestureRecognizer:leftTap];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [_rightImageView addGestureRecognizer:rightTap];
    }
    return self;
}

-(void)setTapBlock:(void (^)(Location, NSInteger))tapBlock
{
    _tapBlock = tapBlock;
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    Location location = Location_left;
    //左侧
    if (gesture.view.tag == 100)
    {
        location = Location_left;
    }
    //右侧
    else if(gesture.view.tag == 101)
    {
        location = Location_right;
    }
    if (_tapBlock) {
        _tapBlock(location,self.indexRow);
    }
}

@end
