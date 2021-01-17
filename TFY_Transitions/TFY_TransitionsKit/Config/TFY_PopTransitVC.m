//
//  TFY_PopTransitVC.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_PopTransitVC.h"

@interface TFY_PopTransitVC ()

@end

@implementation TFY_PopTransitVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
}

// 当视图控制器的特征集合被其父控件更改时，将调用此方法。
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    // 指定视图大小
    self.preferredContentSize = self.popView.bounds.size;
}


- (void)setPopView:(UIView *)popView {
    _popView = popView;
    [self.view addSubview:popView];
    self.view.backgroundColor = popView.backgroundColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = _popView.frame;
    frame.origin = CGPointZero;
    _popView.frame = frame;
}

- (void)updateContentSize {
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
}


@end
