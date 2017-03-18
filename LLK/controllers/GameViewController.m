//
//  GameViewController.m
//  LLK
//
//  Created by PeiJun on 2016/10/22.
//  Copyright © 2016年 PeiJun. All rights reserved.
//

#import "GameViewController.h"
#import "DiamondView.h"

#define TotalCount 10

@interface GameViewController ()<DiamondViewDelegate>

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, assign) DiamondView *lastView;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *progressView;//进度
@property (nonatomic, assign) NSInteger totalDiamondNum;//总块数
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGFloat gameTime;

@end

@implementation GameViewController

- (void)dealloc {
    NSLog(@"GameViewController消失");
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    return _contentArray;
}

- (NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc] init];
    }
    return _colorArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_num == 2) {
        _gameTime = 10;
    } else if (_num == 4) {
        _gameTime = 20;
    } else {
        _gameTime = 30;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"backGround"];
    [self.view addSubview:imageView];
    
    [self backButton];
    [self setProgressView];
    //横竖相乘总数必须为偶数
    [self diamondViewLayoutWithHorizontalNum:_num VerticalNum:(ScreenHeight - 20) / (ScreenWidth / (_num + 2)) - 1];
    [self startGame];
}

- (void)startGame {
    self.view.userInteractionEnabled = NO;
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont boldSystemFontOfSize:200];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"3";
    [self.view addSubview:label];
    
    __block int timeout = 3; //倒计时时间
    //全局并发队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时循环执行事件
    //dispatch_source_set_timer 方法值得一提的是最后一个参数（leeway），他告诉系统我们需要计时器触发的精准程度。所有的计时器都不会保证100%精准，这个参数用来告诉系统你希望系统保证精准的努力程度。如果你希望一个计时器每5秒触发一次，并且越准越好，那么你传递0为参数。另外，如果是一个周期性任务，比如检查email，那么你会希望每10分钟检查一次，但是不用那么精准。所以你可以传入60，告诉系统60秒的误差是可接受的。他的意义在于降低资源消耗。
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,globalQueue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0){ //倒计时结束
            dispatch_source_cancel(timer);//取消定时循环计时器；使得句柄被调用，即事件被执行
            dispatch_async(dispatch_get_main_queue(), ^{
                [label removeFromSuperview];
                self.view.userInteractionEnabled = YES;
                _totalTime = _gameTime;
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = [NSString stringWithFormat:@"%d",timeout];
                timeout--;
            });
        }  
    });  
    dispatch_resume(timer);//恢复定时循环计时器；Dispatch Source 创建完后默认状态是挂起的，需要主动恢复，否则事件不会被传递，也不会被执行
}

//返回按钮
- (void)backButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 20, 50, 30);
    [button setTitle:@"退出" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}
//进度条
- (void)setProgressView {
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 30, 30)];
    _timeLabel.text = [NSString stringWithFormat:@"%.0f",_gameTime];
    _timeLabel.font = [UIFont boldSystemFontOfSize:23];
    _timeLabel.textColor = [UIColor orangeColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_timeLabel];
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(20, 90, 10, 0)];
    _progressView.backgroundColor = [UIColor lightGrayColor];
    _progressView.layer.cornerRadius = 5;
    _progressView.layer.masksToBounds = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 90, 10, ScreenHeight - 100)];
    view.backgroundColor = [UIColor greenColor];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    [self.view addSubview:_progressView];
}
- (void)updateProgressView {
    _timeLabel.text = [NSString stringWithFormat:@"%.0f",_totalTime];
    //改变frame
    CGRect frame =  _progressView.frame;
    frame.size.height += (ScreenHeight - 100) / _gameTime * 0.1;
    _progressView.frame = frame;
    
    _totalTime -= 0.1;
    if (_totalTime <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"很遗憾，你失败了！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [_timer invalidate];
        _timer = nil;
    }
}

//布局 必须为偶数个
- (void)diamondViewLayoutWithHorizontalNum:(NSInteger)horizontalNum VerticalNum:(NSInteger)verticalNum {
    NSInteger x = horizontalNum;//水平
    NSInteger y = verticalNum;//垂直
    _totalDiamondNum = x * y;
    //随机（颜色对应数字）
    for (int i = 0; i < x * y / 2; i ++) {
        NSString *string = [NSString stringWithFormat:@"%d",arc4random() % TotalCount];
        UIColor *color = RandomColor;
        if ([self.contentArray containsObject:string]) {
            NSInteger currentIndex = [self.contentArray indexOfObject:string];
            [self.colorArray addObject:self.colorArray[currentIndex]];
            [self.colorArray addObject:self.colorArray[currentIndex]];
        } else {
            [self.colorArray addObject:color];
            [self.colorArray addObject:color];
        }
        [self.contentArray addObject:string];
        [self.contentArray addObject:string];
        
    }
    //布局
    CGFloat diamondWidth = ScreenWidth / (horizontalNum + 2);
    for (int i = 0; i < verticalNum; i ++) {
        for (int j = 0; j < horizontalNum; j ++) {
            DiamondView *diamondView = [[DiamondView alloc] initWithFrame:CGRectMake(diamondWidth * (j + 1) + diamondWidth / 4.0, diamondWidth * (i + 1), diamondWidth, diamondWidth)];
            diamondView.X = j;
            diamondView.Y = i;
            //随机抽取
            NSInteger lastIndex = arc4random() % self.contentArray.count;
            diamondView.label.text = [self.contentArray objectAtIndex:lastIndex];
            diamondView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[self.contentArray objectAtIndex:lastIndex]]];
            [self.contentArray removeObjectAtIndex:lastIndex];
            
//            diamondView.backgroundColor = self.colorArray[lastIndex];
//            [self.colorArray removeObjectAtIndex:lastIndex];
            
            diamondView.delegate = self;
            [self.view addSubview:diamondView];
        }
    }
}
#pragma mark -- DiamondViewDelegate --
- (void)clickedDiamondViewAction:(DiamondView *)diamondView {
    NSLog(@"点击了x=%ld,y=%ld",diamondView.X,diamondView.Y);
    //相同内容不同坐标
    if ([_lastView.label.text isEqualToString:diamondView.label.text] && (diamondView.X != _lastView.X || diamondView.Y != _lastView.Y)) {
        [self removeDiamondView:diamondView];
        [self removeDiamondView:_lastView];
        _lastView = nil;
    } else {
        _lastView = diamondView;
    }
}
- (void)removeDiamondView:(DiamondView *)view {
    CGPoint center = view.center;
    CGFloat time = AnimateTime;
    CGRect frame = view.frame;
    frame.size.width = 0;
    frame.size.height = 0;
    [UIView animateWithDuration:time animations:^{
        view.frame = frame;
        view.center = center;
    }];
    [self performSelector:@selector(removeViewFromSuperview:) withObject:view afterDelay:time];
}
- (void)removeViewFromSuperview:(DiamondView *)view {
    [view removeFromSuperview];
    _totalDiamondNum -= 1;
    if (_totalDiamondNum == 0) {
        [_timer invalidate];
        _timer = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"胜利" message:@"恭喜你获得了胜利" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}
#pragma mark --alertViewDelegate--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
