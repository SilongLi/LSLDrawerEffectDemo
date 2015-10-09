//
//  SlideViewController.m
//  左右两边的拖拽抽屉
//
//  Created by lisilong
//  github地址：https://github.com/SilongLi
//

#import "SlideViewController.h"

// 获取屏幕的高宽
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@interface SlideViewController ()
@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加子窗口
    [self setupChlidView];
    
    // 2.给中间的窗口添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.mainView addGestureRecognizer:pan];
    
    // 3.KVO监听某个类的属性
    // addObserver：监听者
    // forKeyPath：mainView对象的frame属性的改变
    // options：NSKeyValueObservingOptionNew监听新值的改变
    [self.mainView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    // 4.给控制器添加手势，使在点击屏幕时返回最初的效果
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.leftView addGestureRecognizer:leftTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.rightView addGestureRecognizer:rightTap];
}

// 4.给控制器添加手势，使在点击屏幕时返回最初的效果
- (void)tap
{
    if (self.mainView.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.frame = [UIScreen mainScreen].bounds;
        }];
    }
}

// 3.只要监听的对象的属性一改变，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat transX = self.mainView.frame.origin.x;
    if (transX > 0) {   // 当往右拖拽的时候，隐藏右边的view
        self.leftView.hidden = NO;
        self.rightView.hidden = YES;
    }else if (transX < 0){  // 当往左拖拽的时候，隐藏左边的view
        self.rightView.hidden = NO;
        self.leftView.hidden = YES;
    }
}

#pragma mark - 在对象销毁之前移除监听
- (void)dealloc
{
    // 移除观察者
    [self.mainView removeObserver:self forKeyPath:@"frame"];
}

// 手势松开时的左右停靠值
#define targetR 300     // 右边
#define targetL -200    // 左边

#pragma mark - mainView拖拽手势的pan方法
- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手势的偏移量
    CGPoint transP = [pan translationInView:self.mainView];
    
    // 获取相对与上一次的x的偏移量
    CGFloat transX = transP.x;
    
    // 修改窗口的frame
    self.mainView.frame = [self setViewFrameWithTransX:(CGFloat)transX];
    
    // 复位
    [pan setTranslation:CGPointZero inView:self.mainView];
    
    //判断拖拽手势的状态.当拖拽松手时调用
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 判断当前x的值是否>屏幕的一半，如果是则停止在右边的某个位置
        CGFloat target = 0;
        if (self.mainView.frame.origin.x > screenW * 0.5) {
            target = targetR;
        }else if (CGRectGetMaxX(self.mainView.frame) < screenW * 0.5){
            // 判断当前x的值是否<屏幕的一半，如果是则停止在左边的某个位置
            target = targetL;
        }
        
        CGFloat offetX = target - self.mainView.frame.origin.x;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.mainView.frame = [self setViewFrameWithTransX:offetX];
        }];
    }
}

// 最大的Y值偏移量
#define LSLMaxY 100

// 根据x值，修改frame并返回
- (CGRect)setViewFrameWithTransX:(CGFloat)transX
{
    // 1.当前中间窗口的frame
    CGRect frame = self.mainView.frame;
    
    // 2.计算frame的值
    CGFloat x = frame.origin.x + transX;
    
    // 计算偏移量的比例,然后计算y的值
    CGFloat y = x / screenW * LSLMaxY;
    
    // 当往左边拖拽且当y小于0的时候,y值取反
    if (y < 0) {
        y = -y;
    }
    
    
    CGFloat height = screenH - 2 * y;
    
    CGFloat width = height / screenH * screenW;

    return CGRectMake(x, y,width, height);
}

#pragma mark - 添加子窗口
- (void)setupChlidView
{
    // 添加左边的窗口
    UIView *leftView = [[UIView alloc] initWithFrame:self.view.frame];
    leftView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:leftView];
    _leftView = leftView;
    
    [self showLabelInView:leftView title:@"点我啊..."];
    
    // 添加右边的窗口
    UIView *rightView = [[UIView alloc] initWithFrame:self.view.frame];
    rightView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightView];
    _rightView = rightView;
    
    [self showLabelInView:rightView title:@"点我吧..."];
    
    // 添加中间的窗口
    UIView *mainView = [[UIView alloc] initWithFrame:self.view.frame];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    _mainView = mainView;
    
    [self showLabelInView:mainView title:@"拖拽我..."];
}

- (void)showLabelInView:(UIView *)view title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.center = view.center;
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    [view addSubview:label];
}
@end
