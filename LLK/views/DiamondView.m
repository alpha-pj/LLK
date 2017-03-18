//
//  DiamondView.m
//  LLK
//
//  Created by PeiJun on 2016/10/22.
//  Copyright © 2016年 PeiJun. All rights reserved.
//

#import "DiamondView.h"

@implementation DiamondView

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [super initWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiamondView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:18];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (void)tapDiamondView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(clickedDiamondViewAction:   )]) {
        [self.delegate clickedDiamondViewAction:(DiamondView *)sender.view];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:AnimateTime animations:^{
        _label.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }];
}

@end
