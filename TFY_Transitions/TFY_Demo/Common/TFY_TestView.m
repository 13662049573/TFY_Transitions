//
//  TFY_TestView.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_TestView.h"

@implementation TFY_TestView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *hitTestView = [super hitTest:point withEvent:event];
    return hitTestView;
}

@end
