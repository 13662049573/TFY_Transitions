//
//  TFY_TestViewController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_TestViewController.h"
#import "TFY_TestView.h"

@interface TFY_TestViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TFY_TestViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1. 在父类统一集成，子类通过_swipeDismissEnable属性开启
        self.swipeDismissEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TFY_TestView *view = [[TFY_TestView alloc] initWithFrame:CGRectMake(100, 100, 300, 400)];
    view.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:view];
    
    TFY_TestView *subView = [[TFY_TestView alloc] initWithFrame:CGRectInset(view.bounds, 20, 20)];
    subView.backgroundColor = [UIColor systemPinkColor];
    [view addSubview:subView];
    
    // 2. 创建侧滑手势
    if (self.swipeDismissEnable) {
        TFY_ScreenEdgePanGestureRecognizer *edgePan;
        edgePan = [[TFY_ScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        // 可以拓展为其它侧边滑动手势（如：右侧边滑动进行present...）
        edgePan.edges = UIRectEdgeLeft;
        [view addGestureRecognizer:edgePan];
    }
    self.view.backgroundColor = [UIColor systemYellowColor];
}

// MARK: - 侧滑Dismiss
-(void)dismiss:(UIScreenEdgePanGestureRecognizer *)sender
{
    
    NSLog(@"%s",__func__);
}

@end
