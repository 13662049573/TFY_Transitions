//
//  TFY_ScreenEdgePanGestureRecognizer.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_ScreenEdgePanGestureRecognizer.h"
#define kRectEdge 30.f
@implementation TFY_ScreenEdgePanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithTarget:target action:action]) {
        self.edges = UIRectEdgeLeft;
        self.delegate = self;
    }
   
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIView *touchView = gestureRecognizer.view;
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (self.edges == UIRectEdgeLeft) {
        return point.x < kRectEdge;
    }else if (self.edges == UIRectEdgeRight){
        return point.x > touchView.bounds.size.width - kRectEdge;
    }else if (self.edges == UIRectEdgeTop){
        return point.y < kRectEdge;
    }else if (self.edges == UIRectEdgeBottom){
        return point.y > touchView.bounds.size.height - kRectEdge;
    }else if (self.edges == UIRectEdgeAll){
        CGRect rect = CGRectInset(touchView.bounds, kRectEdge, kRectEdge);
        return !CGRectContainsPoint(rect, point);
    }
    
    return NO;
}

@end
