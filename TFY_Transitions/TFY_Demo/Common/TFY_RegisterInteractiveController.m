//
//  TFY_RegisterInteractiveController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_RegisterInteractiveController.h"
#import "TFY_CodeViewConroller.h"

@interface TFY_RegisterInteractiveController ()

@end

@implementation TFY_RegisterInteractiveController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"注册手势";
    UILabel *label = [[UILabel alloc] init];
    if (_isModal) {
        label.text = @"右边向左侧滑可以Presentation操作";
    }else {
        label.text = @"右边向左侧滑可以Push操作";
    }
    [label sizeToFit];
    label.center = self.view.layer.position;
    [self.view addSubview:label];
    
    // 要注册转场的View Controller
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
    
    UILabel *label2 = [[UILabel alloc] init];
    if (_isModal) {
        label2.text = @"左边向右侧滑可以Dismiss操作";
    }else {
        label2.text = @"左边向右滑可以Pop操作";
    }
    [label2 sizeToFit];
    label2.center = vc.view.layer.position;
    [vc.view addSubview:label2];
    
    
    // 注册手势
    TFY_SwipeAnimator *animator = [TFY_SwipeAnimator animatorWithSwipeType:SwipeTypeInAndOut pushDirection:DirectionToLeft popDirection:DirectionToRight];
    animator.transitionDuration = 0.35f;
    // 必须初始化的属性
    animator.isPushOrPop = !_isModal;
    animator.interactiveDirectionOfPush = DirectionToLeft;
    
    [self registerInteractiveTransitionToViewController:vc animator:animator];
    
}

- (IBAction)showCode:(UIButton *)sender {
    TFY_CodeViewConroller *codeVc = [TFY_CodeViewConroller new];
    codeVc.imgName = @"registerInteractive";
    TFY_CATransitonAnimator *anm = [TFY_CATransitonAnimator animatorWithTransitionType:TransitionFade
                                                                         direction:DirectionToLeft
                                                           transitionTypeOfDismiss:TransitionFade
                                                                directionOfDismiss:DirectionToRight];
    [self presentViewController:codeVc animator:anm completion:nil];
}

@end
