//
//  TFY_ModalFirstController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_ModalFirstController.h"
#import "TFY_SecondViewController.h"
#import "TFY_WheelTableViewCell.h"
#import "TFY_Section.h"
#import "TFY_AppStoreListController.h"

@interface TFY_ModalFirstController ()<CAAnimationDelegate>{
    
    id<UIViewControllerContextTransitioning> _transitionContext;
    CATransition *_anim1;
}
@property(nonatomic, strong) NSArray <TFY_Section *>*data;
@end

@implementation TFY_ModalFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"A";
    
    NSString *title;
    NSArray *rows;
    NSArray *rowsOfSubtitle;
    switch (_type) {
        case ContentTypeSystemAnimator:
            title = @"System Animator";
            rows = @[
                @"·Cover Vertical",
                @"·Flip Horizontal",
                @"·Cross Dissolve",
                @"Partial Curl (不支持iOS 13+)"
            ];
            break;
        case ContentTypeSwipeAnimator:
            title = @"Swipe Animator";
            rows = @[@"·InAndOut: A->B,B从A的上面滑入; B->A,B从A的上面抽出", // “·”开始的表示需要设置方向
                     @"·In: B从A的上面滑入; B->A,A从B的上面滑入",
                     @"·Out: A->B,A从B的上面抽出; B->A,B从A的上面抽）"];
            break;
        case ContentTypeCATransitionAnimator:
            title = @"CATransition Animator";
            rows = @[@"Fade", @"·Move in", @"·Push",
                     @"·Reveal", @"·Cube (私有API)",
                     @"Suck Effect (私有API 不支持iOS 13+)", @"·Ogl Flip (私有API)",
                     @"Ripple Effect (私有API 不支持iOS 13+)", @"·Page Curl (私有API)",
                     @"Camera Iris Hollow (私有API 不支持iOS 13+)",];
            break;
        case ContentTypeCuStomAnimator:
            title = @"CuStom Animator";;
            rows = @[@"Checkerboard", @"Heartbeat"];
            break;
        default:{
            title = @"个人动画收集";
            rows = @[@"开门",@"绽放", @"斜角切入",@"向右边倾斜旋转",@"向左边倾斜旋转",
                     @"指定frame：initialFrame --> finalFrame", @"对指定rect范围，进行缩放和平移",
                     @"对指定rect范围...2[纯净版]",@"圆形（x坐标随机）",@"抽屉效果",@"发牌效果", @"轻缩放[类似小程序转场效果]",
                     @"NatGeo",
                     
                     @"App Store Card(demo自定义案例，不在框架内)" // 放到最后
                     ];
            rowsOfSubtitle = @[@(AnimatorTypeOpen), @(AnimatorTypeOpen2),@(AnimatorTypeBevel),
                               @(AnimatorTypeTiltRight), @(AnimatorTypeTiltLeft), @(AnimatorTypeFrame),
                               @(AnimatorTypeRectScale), @(AnimatorTypeRectScale), @(AnimatorTypeCircular),
                               @(AnimatorTypeSlidingDrawer),@(AnimatorTypeCards),@(AnimatorTypeScale),
                               @(AnimatorTypeNatGeo),
                               
                               @100];
        }
            break;
    }
    
    TFY_Section *section = [TFY_Section new];
    section.title = [NSString stringWithFormat:@"Modal : %@",title];
    section.show = YES;
    section.rows = rows;
    section.rowsOfSubTitle = rowsOfSubtitle;
    _data = @[section];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:TFY_WheelTableViewCell.class forCellReuseIdentifier:@"TFY_WheelTableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data[section].show ? self.data[section].rows.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = self.data[indexPath.section].rows[indexPath.row];
    if ([text hasPrefix:@"·"]) {
        TFY_WheelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFY_WheelTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text = [text substringWithRange:NSMakeRange(1, text.length - 1)];
        
        if([self.data[indexPath.section].title containsString:@"System Animator"]) {
            cell.sgmtB.hidden = YES;
            if (cell.sgmtA.numberOfSegments == 4) {
                [cell.sgmtA removeAllSegments];
                [cell.sgmtA insertSegmentWithTitle:@"YES" atIndex:0 animated:NO];
                [cell.sgmtA insertSegmentWithTitle:@"NO (iOS 13+ 有效)" atIndex:1 animated:NO];
                cell.sgmtA.selectedSegmentIndex = 0;
            }
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    if ([text containsString:@"指定rect范围"]) {
        cell.imageView.image = [UIImage imageNamed:@"img"];
    }else {
        cell.imageView.image = nil;
    }
    
    cell.textLabel.text = self.data[indexPath.section].rows[indexPath.row];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.data[indexPath.section].rows[indexPath.row];
    if ([text hasPrefix:@"·"]) {
        return 145;
    }
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderReuseIdentifier"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"HeaderReuseIdentifier"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heaerViewTap:)];
        [headerView addGestureRecognizer:tap];
        
        headerView.layer.borderWidth = 0.6f;
        headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    headerView.textLabel.text = self.data[section].title;
    headerView.tag = section;
    return headerView;
}

- (void)heaerViewTap:(UITapGestureRecognizer *)tap {
    NSInteger section = tap.view.tag;
    self.data[section].show = !self.data[section].show;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == ContentTypeSystemAnimator) {
        [self presentBySystem:indexPath];
    }else if (_type == ContentTypeSwipeAnimator){
        [self presentBySwipe:indexPath];
    }else if (_type == ContentTypeCATransitionAnimator){
        [self presentByCATransition:indexPath];
    }else if (_type == ContentTypeCuStomAnimator){
        [self presentByCustom:indexPath];
    }else {
        
        NSString *text = self.data[indexPath.section].rows[indexPath.row];
        if ([text containsString:@"App Store"]) {
            TFY_AppStoreListController *vc = [TFY_AppStoreListController new];
            [self presentViewController:vc swipeType:SwipeTypeIn presentDirection:DirectionToLeft dismissDirection:DirectionToLeft completion:nil];
        }else {
            [self presentByAnimator:indexPath];
        }
    }
}

#pragma mark -
#pragma mark - Presenting Of View Controller
#pragma mark 原生动画效果 TFY_SystemAnimator
- (void)presentBySystem:(NSIndexPath *)indexPath {
    if (@available(iOS 13.0, *)) {
        if (indexPath.row == 3) {
            return;
        }
    }
    
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.imgName = @"modal_system_animator";
    BOOL isFullScreen = YES;
    if(indexPath.row < 3) {
        TFY_WheelTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        isFullScreen = cell.sgmtA.selectedSegmentIndex != 1;
    }
    TFY_SystemAnimator *anm = [TFY_SystemAnimator animatorWithStyle:indexPath.row fullScreen:isFullScreen];
    [self presentViewController:vc animator:anm completion:nil];
}

#pragma mark 平滑效果 TFY_SwipeAnimator
- (void)presentBySwipe:(NSIndexPath *)indexPath  {
    
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.imgName = @"modal_swipe";

    TFY_WheelTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    SwipeType type;
    if (indexPath.row == 0) {
        type = SwipeTypeInAndOut;
    }else if (indexPath.row == 1) {
        type = SwipeTypeIn;
    }else {
        type = SwipeTypeOut;
    }
    
    TFY_SwipeAnimator *anm = [TFY_SwipeAnimator animatorWithSwipeType:type
                                                    pushDirection:1<<cell.sgmtA.selectedSegmentIndex
                                                     popDirection:1<<cell.sgmtB.selectedSegmentIndex];
    [self presentViewController:vc animator:anm completion:nil];
    
}


#pragma mark TFY_CATransitonAnimator
- (TFY_CATransitonAnimator *)CATransitionAnimatorWithIndexPath:(NSIndexPath *)indexPath toViewController:(UIViewController *)vc {
    
    TFY_WheelTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *text = self.data[indexPath.section].rows[indexPath.row];
    
    Direction direction = DirectionToBottom;
    Direction dismissDirection = DirectionToBottom;
    if ([text hasPrefix:@"·"]) {
        direction = 1 << cell.sgmtA.selectedSegmentIndex;
        dismissDirection = 1 << cell.sgmtB.selectedSegmentIndex;
    }
    
    TransitionType transitionType = TransitionFade;
    TransitionType transitionTypeOfDismiss = TransitionFade;
    switch (indexPath.row) {
        case 0:
        {
            transitionType = TransitionFade;
            transitionTypeOfDismiss = TransitionFade;
        }
            break;
        case 1:
        {
            transitionType = TransitionMoveIn;
            transitionTypeOfDismiss = TransitionMoveIn;
        }
            break;
        case 2:
        {
            transitionType = TransitionPush;
            transitionTypeOfDismiss = TransitionPush;
        }
            break;
        case 3:
        {
            transitionType = TransitionReveal;
            transitionTypeOfDismiss = TransitionReveal;
        }
            break;
        case 4:
        {
            transitionType = TransitionCube;
            transitionTypeOfDismiss =TransitionCube;
        }
            break;
        case 5:
        {
            transitionType = TransitionSuckEffect;
            transitionTypeOfDismiss = TransitionSuckEffect;
        }
            break;
        case 6:
        {
            transitionType =TransitionOglFlip;
            transitionTypeOfDismiss = TransitionOglFlip;
        }
            break;
        case 7:
        {
            transitionType = TransitionRippleEffect;
            transitionTypeOfDismiss = TransitionRippleEffect;
        }
            break;
        case 8:
        {
            transitionType = TransitionPageCurl;
            transitionTypeOfDismiss = TransitionPageUnCurl;
        }
            break;
        case 9:
        {
            transitionType = TransitionCameraIrisHollowOpen;
            transitionTypeOfDismiss = TransitionCameraIrisHollowClose;
        }
            break;
        default:
            break;
    }
    
    if (@available(iOS 13.0, *)) {
        BOOL flag = transitionType == TransitionSuckEffect ||
                    transitionType == TransitionRippleEffect ||
                    transitionType == TransitionCameraIrisHollowOpen ||
                    transitionType == TransitionCameraIrisHollowClose ||
                    transitionTypeOfDismiss == TransitionSuckEffect ||
                    transitionTypeOfDismiss == TransitionRippleEffect ||
                    transitionTypeOfDismiss == TransitionCameraIrisHollowOpen ||
                    transitionTypeOfDismiss == TransitionCameraIrisHollowClose;
        
        if (flag) {
            transitionType = TransitionFade;
            transitionTypeOfDismiss = TransitionFade;
        }
    }
    
    TFY_CATransitonAnimator *animator;
    animator = [TFY_CATransitonAnimator animatorWithTransitionType:transitionType
                                                       direction:direction
                                         transitionTypeOfDismiss:transitionTypeOfDismiss
                                              directionOfDismiss:dismissDirection];
    
    return animator;
}

- (void)presentByCATransition:(NSIndexPath *)indexPath {
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.imgName = @"modal_catransition";
    
    TFY_CATransitonAnimator *animator = [self CATransitionAnimatorWithIndexPath:indexPath toViewController:vc];
    [self presentViewController:vc animator:animator completion:^{
        NSLog(@"CATransition : completion---%zi",indexPath.row);
    }];
}

#pragma mark 自定义动画 TFY_CustomAnimator
- (void)presentByCustom:(NSIndexPath *)indexPath {
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.imgName = @"modal_custom";
    
    [self presentViewController:vc customAnimation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, BOOL isPresenting) {
        
        if (indexPath.row == 0) {
            [self checkerboardAnimateTransition:transitionContext isPresenting:isPresenting isPush:NO];
        }else if (indexPath.row == 1) {
            [self heartbeatAnimateTransition:transitionContext isPresenting:isPresenting isPush:NO];
        }else if (indexPath.row == 2) {
            [self bounceAnimateTransition:transitionContext isPresenting:isPresenting];
        }
        
    } completion:^{
        NSLog(@"Custom : completion---%zi",indexPath.row);
    }];
}

/// 心跳动画
- (void)heartbeatAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                      isPresenting:(BOOL)isPresenting
                            isPush:(BOOL)isPush
{
    
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    if (isPresenting || isPush) {
        [transitionContext.containerView addSubview:toView];
    }
    
    UIView *targetView = isPresenting  ? toView : fromView;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.toValue = @0.8;
    animation.repeatCount = 3;
    animation.duration = 0.3;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    _transitionContext = transitionContext;
    [targetView.window.layer addAnimation:animation forKey:nil];
}

/// 弹性动画
- (void)bounceAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   isPresenting:(BOOL)isPresenting
{
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) { // iOS 8+ fromView/toView可能为nil
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    
    if (isPresenting) {
        [transitionContext.containerView addSubview:toView];
    }
    
    UIView *targetView = isPresenting  ? toView : fromView;
    if (isPresenting)
        targetView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    else
        targetView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    CGRect frame = targetView.frame;
    frame.origin.y = -frame.size.height;
    toView.frame = frame;
    [UIView animateWithDuration:1.0f
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5.0
                        options:0
                     animations:^{
                         CGRect frame = targetView.frame;
                         if (isPresenting) {
                             frame.origin.y = transit_ScreenH - 500;
                         }else {
                             frame.origin.y = 30;
                         }
                         
                         targetView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         CGRect frame = targetView.frame;
                         //                         frame.origin.y = 0;
                         targetView.frame = frame;
                         [transitionContext completeTransition:YES];
                         //                         targetView.transform = CGAffineTransformIdentity;
                     }];
}

/// 官方demo动画
- (void)checkerboardAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                         isPresenting:(BOOL)isPresenting
                               isPush:(BOOL)isPush
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView * fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UIImage *fromViewSnapshot;
    __block UIImage *toViewSnapshot;
    if (isPresenting || isPush) {
        [transitionContext.containerView addSubview:toView];
    }
    
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
        [toView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        toViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    transitionContainer.opaque = YES;
    transitionContainer.backgroundColor = UIColor.redColor;//blackColor;
    [containerView addSubview:transitionContainer];
    
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -900.0;
    transitionContainer.layer.sublayerTransform = t;
    
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame) / 10.f);
    NSUInteger horizontalSlices = ceil(CGRectGetWidth(transitionContainer.frame) / sliceSize);
    NSUInteger verticalSlices = ceil(CGRectGetHeight(transitionContainer.frame) / sliceSize);
    
    const CGFloat transitionSpacing = 160.f;
    NSTimeInterval transitionDuration = 3;
    
    CGVector transitionVector;
    if (isPresenting) {
        transitionVector = CGVectorMake(CGRectGetMaxX(transitionContainer.bounds) - CGRectGetMinX(transitionContainer.bounds),
                                        CGRectGetMaxY(transitionContainer.bounds) - CGRectGetMinY(transitionContainer.bounds));
    } else {
        transitionVector = CGVectorMake(CGRectGetMinX(transitionContainer.bounds) - CGRectGetMaxX(transitionContainer.bounds),
                                        CGRectGetMinY(transitionContainer.bounds) - CGRectGetMaxY(transitionContainer.bounds));
    }
    
    CGFloat transitionVectorLength = sqrtf( transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy );
    CGVector transitionUnitVector = CGVectorMake(transitionVector.dx / transitionVectorLength, transitionVector.dy / transitionVectorLength);
    
    for (NSUInteger y = 0 ; y < verticalSlices; y++)
    {
        for (NSUInteger x = 0; x < horizontalSlices; x++)
        {
            CALayer *fromContentLayer = [CALayer new];
            fromContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            fromContentLayer.rasterizationScale = fromViewSnapshot.scale;
            fromContentLayer.contents = (__bridge id)fromViewSnapshot.CGImage;
            
            CALayer *toContentLayer = [CALayer new];
            toContentLayer.frame = CGRectMake(x * sliceSize * -1.f, y * sliceSize * -1.f, containerView.bounds.size.width, containerView.bounds.size.height);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL wereActiondDisabled = [CATransaction disableActions];
                [CATransaction setDisableActions:YES];
                
                toContentLayer.rasterizationScale = toViewSnapshot.scale;
                toContentLayer.contents = (__bridge id)toViewSnapshot.CGImage;
                
                [CATransaction setDisableActions:wereActiondDisabled];
            });
            
            UIView *toCheckboardSquareView = [UIView new];
            toCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            toCheckboardSquareView.opaque = NO;
            toCheckboardSquareView.layer.masksToBounds = YES;
            toCheckboardSquareView.layer.doubleSided = NO;
            toCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            [toCheckboardSquareView.layer addSublayer:toContentLayer];
            
            UIView *fromCheckboardSquareView = [UIView new];
            fromCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            fromCheckboardSquareView.opaque = NO;
            fromCheckboardSquareView.layer.masksToBounds = YES;
            fromCheckboardSquareView.layer.doubleSided = NO;
            fromCheckboardSquareView.layer.transform = CATransform3DIdentity;
            [fromCheckboardSquareView.layer addSublayer:fromContentLayer];
            
            [transitionContainer addSubview:toCheckboardSquareView];
            [transitionContainer addSubview:fromCheckboardSquareView];
        }
    }
    
    __block NSUInteger sliceAnimationsPending = 0;
    
    for (NSUInteger y = 0 ; y < verticalSlices; y++)
    {
        for (NSUInteger x = 0; x < horizontalSlices; x++)
        {
            UIView *toCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2)];
            UIView *fromCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2 + 1)];
            
            CGVector sliceOriginVector;
            if (isPresenting) {
                sliceOriginVector = CGVectorMake(CGRectGetMinX(fromCheckboardSquareView.frame) - CGRectGetMinX(transitionContainer.bounds),
                                                 CGRectGetMinY(fromCheckboardSquareView.frame) - CGRectGetMinY(transitionContainer.bounds));
            } else {
                sliceOriginVector = CGVectorMake(CGRectGetMaxX(fromCheckboardSquareView.frame) - CGRectGetMaxX(transitionContainer.bounds),
                                                 CGRectGetMaxY(fromCheckboardSquareView.frame) - CGRectGetMaxY(transitionContainer.bounds));
            }
            
            CGFloat dot = sliceOriginVector.dx * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy;
            CGVector projection = CGVectorMake(transitionUnitVector.dx * dot/transitionVectorLength,
                                               transitionUnitVector.dy * dot/transitionVectorLength);
            
            CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
            
            NSTimeInterval startTime = projectionLength/(transitionVectorLength + transitionSpacing) * transitionDuration;
            NSTimeInterval duration = ( (projectionLength + transitionSpacing)/(transitionVectorLength + transitionSpacing) * transitionDuration ) - startTime;
            
            sliceAnimationsPending++;
            
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                toCheckboardSquareView.layer.transform = CATransform3DIdentity;
                fromCheckboardSquareView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
            } completion:^(BOOL finished) {
                if (--sliceAnimationsPending == 0) {
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    
                    [transitionContainer removeFromSuperview];
                    [transitionContext completeTransition:!wasCancelled];
                }
            }];
        }
    }
}

#pragma mark TFY_Animator(个人收集)
- (void)presentByAnimator:(NSIndexPath *)indexPath {
    TFY_SecondViewController *vc = [[TFY_SecondViewController alloc] init];
    vc.imgName = @"modal_animator";
    
    AnimatorType type = [self.data[indexPath.section].rowsOfSubTitle[indexPath.row] integerValue];
    if (type == AnimatorTypeSlidingDrawer) {
        type = AnimatorTypeTiltRight;
        vc.isShowBtn = YES;
        vc.disableInteractivePopGestureRecognizer = YES;
    }
    TFY_Animator *animator = [TFY_Animator animatorWithType:type];
    //    animator.transitionDuration = 1.f;
    
    if (type == AnimatorTypeFrame) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect frame = [self.tableView convertRect:cell.frame toView:TFY_TransitFunction.appKeyWindow];
        animator.initialFrame = frame;
        
    }else if (type == AnimatorTypeRectScale) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect frame = [cell convertRect:cell.imageView.frame toView:TFY_TransitFunction.appKeyWindow];
        animator.fromRect = frame;
        animator.toRect = CGRectMake(0, transit_ScreenH - 210, transit_ScreenW, 210);
        animator.isOnlyShowRangeForRect = indexPath.row > AnimatorTypeRectScale;
        vc.isShowImage = YES;
        
    }else if (type == AnimatorTypeCircular) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGPoint center = [self.tableView convertPoint:cell.center toView:TFY_TransitFunction.appKeyWindow];
        center.x = arc4random_uniform(cell.bounds.size.width - 40) + 20;
        animator.center = center;
    }else if (type == AnimatorTypeCards) {
        animator.transitionDuration = 1.f;
    }
    
    [self presentViewController:vc animator:animator completion:^{
       
    }];
}

#pragma mark - CAAnimationDelegate
/// CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:YES];
}


@end
