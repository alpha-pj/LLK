//
//  MainViewController.m
//  LLK
//
//  Created by PeiJun on 2016/10/22.
//  Copyright © 2016年 PeiJun. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self addSubviews];
    
}

- (void)addSubviews {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"backGround"];
    [self.view addSubview:imageView];
    NSArray *array = @[@"消消笑",@"简单",@"中等",@"困难"];
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, ScreenHeight / 6.0 * (i + 1), ScreenWidth - 20, 50);
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        if (i == 0) {
            button.titleLabel.font = [UIFont systemFontOfSize:50];
            [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:30];
            button.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        }
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
}

- (void)startGame:(UIButton *)sender {
    GameViewController *vc = [[GameViewController alloc] init];
    if ([sender.titleLabel.text isEqualToString:@"简单"]) {
        vc.num = 2;
    } else if ([sender.titleLabel.text isEqualToString:@"中等"]) {
        vc.num = 4;
    } else {
        vc.num = 6;
    }
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
