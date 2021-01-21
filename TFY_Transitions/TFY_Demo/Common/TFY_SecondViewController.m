//
//  TFY_SecondViewController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/20.
//

#import "TFY_SecondViewController.h"
#import "TFY_CodeViewConroller.h"

@interface TFY_SecondViewController ()
@property(nonatomic, strong)  UIImageView *imgView;
@property (strong, nonatomic)  UIButton *presentBtn;
@property (strong, nonatomic)  UILabel *textLabel;
@property (strong, nonatomic)  UIButton *dismissBtn;
@property (strong, nonatomic)  UIButton *sttBtn;
@end

@implementation TFY_SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Controller B";
    
    self.view.backgroundColor = UIColor.blueColor;
    
    self.imgView.hidden = !_isShowImage;
    self.presentBtn.hidden = !_isShowBtn;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, transit_ScreenW, 200)];
    self.textLabel.text = @"B";
    self.textLabel.font = [UIFont boldSystemFontOfSize:50];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.textLabel];
    
    self.presentBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textLabel.frame), transit_ScreenW-40, 50)];
    self.presentBtn.backgroundColor = UIColor.purpleColor;
    [self.presentBtn setTitle:@"界面弹出" forState:UIControlStateNormal];
    self.presentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.presentBtn addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.presentBtn];
    
    self.dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.presentBtn.frame)+20, transit_ScreenW-40, 50)];
    self.dismissBtn.backgroundColor = UIColor.orangeColor;
    [self.dismissBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    self.dismissBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissBtn];
    
    self.sttBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.dismissBtn.frame)+20, transit_ScreenW-40, 50)];
    self.sttBtn.backgroundColor = UIColor.brownColor;
    [self.sttBtn setTitle:@"查看代码" forState:UIControlStateNormal];
    self.sttBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sttBtn addTarget:self action:@selector(showCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sttBtn];
    
    if (_isShowBtn) {
        
        UIViewController *vc = [[UIViewController alloc] init];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = vc.view.bounds;
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[UIColor redColor].CGColor,
                           (id)[UIColor greenColor].CGColor,
                           (id)[UIColor blueColor].CGColor, nil];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 1);
        gradient.locations = @[@0.0, @0.5, @1.0];
        [vc.view.layer addSublayer:gradient];
        
        
        AnimatorType type = AnimatorTypeSlidingDrawer;
        TFY_Animator *animator = [TFY_Animator animatorWithType:type];
        animator.transitionDuration = 0.35f;
       
        // 必须初始化的属性
        animator.isPushOrPop = NO;
        animator.interactiveDirectionOfPush = DirectionToRight;
        
        [self registerInteractiveTransitionToViewController:vc animator:animator];
    }
}

- (void)dismiss:(id)sender {
    if (self.navigationController.childViewControllers.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)present:(UIButton *)sender {
    
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.textLabel.text = @"C";
    vc.view.backgroundColor = [UIColor yellowColor];
    AnimatorType type = AnimatorTypeSlidingDrawer;
    TFY_Animator *animator = [TFY_Animator animatorWithType:type];
    animator.transitionDuration = 0.35f;
    
    [self presentViewController:vc animator:animator completion:^{
        vc.textLabel.text = @"C";
    }];
}

- (void)showCode:(UIButton *)sender {
    TFY_CodeViewConroller *codeVc = [TFY_CodeViewConroller new];
    codeVc.imgName = _imgName;
    TFY_SystemAnimator *anm = [TFY_SystemAnimator animatorWithStyle:0 fullScreen:NO];
    [self presentViewController:codeVc animator:anm completion:nil];
}




@end
