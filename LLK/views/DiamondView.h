//
//  DiamondView.h
//  LLK
//
//  Created by PeiJun on 2016/10/22.
//  Copyright © 2016年 PeiJun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiamondView;
//代理
@protocol DiamondViewDelegate <NSObject>
//必须实现点击方法
@required
-(void)clickedDiamondViewAction:(DiamondView *)diamondView;

@end
//方块
@interface DiamondView : UIView

@property (nonatomic, assign) NSInteger X;
@property (nonatomic, assign) NSInteger Y;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<DiamondViewDelegate> delegate;

@end


