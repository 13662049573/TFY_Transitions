//
//  TFY_ModalMenuController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_ModalMenuController.h"
#import "TFY_RegisterInteractiveController.h"
#import "TFY_Section.h"
#import "TFY_ModalFirstController.h"
#import "TFY_TestViewController.h"


@interface TFY_ModalMenuController ()
@property(nonatomic, strong) NSArray <TFY_Section *>*data;
@end

@implementation TFY_ModalMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Menu";
    
    TFY_Section *presentSection = [TFY_Section new];
    presentSection.title = @"Modal";
    presentSection.show = YES;
    presentSection.rows = @[@"System Animator", @"Swipe Animator" ,@"CATransition Animator",
                            @"CuStom Animator",@"个人动画案例收集（TLAnimator）"];
    
    
    TFY_Section *registerInteractiveSection = [TFY_Section new];
    registerInteractiveSection.title = @"注册手势进行presention";
    registerInteractiveSection.show = YES;
    registerInteractiveSection.rows = @[@"Modal"];
    _data = @[presentSection,registerInteractiveSection];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self testRegisterInteractiveTransition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 手动恢复tabbar的显示
    self.tabBarController.tabBar.hidden = NO;
}

- (void)testRegisterInteractiveTransition {
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
    
    // 注册手势
    TFY_SwipeAnimator *animator = [TFY_SwipeAnimator animatorWithSwipeType:SwipeTypeInAndOut pushDirection:DirectionToLeft popDirection:DirectionToRight];
    animator.transitionDuration = 0.35f;
    // 必须初始化的属性
    animator.isPushOrPop = NO;
    animator.interactiveDirectionOfPush = DirectionToLeft;
    
    [self registerInteractiveTransitionToViewController:vc animator:animator];
}

#pragma mark - Table view data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data[section].show ? self.data[section].rows.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSString *text = self.data[indexPath.section].rows[indexPath.row];
    cell.textLabel.text = text;
    return cell;
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
    UIViewController *viewController;
    if (indexPath.section == 1) {
        TFY_RegisterInteractiveController *vc = [TFY_RegisterInteractiveController new];
        vc.isModal = YES;
        viewController = vc;
    }else {
        TFY_ModalFirstController *vc = [TFY_ModalFirstController new];
        ContentType type = ContentTypeOther;
        NSString *text = self.data[indexPath.section].rows[indexPath.row];
        if ([text containsString:@"System"]) {
            type = ContentTypeSystemAnimator;
        }else if ([text containsString:@"Swipe"]) {
            type = ContentTypeSwipeAnimator;
        }else if ([text containsString:@"CATransition"]) {
            type = ContentTypeCATransitionAnimator;
        }else if ([text containsString:@"CuStom"]) {
            type = ContentTypeCuStomAnimator;
        }
        vc.type = type;
        viewController = vc;
    }
    
    // 手动隐藏tabbar，解决tabbar和VC动画不统一的问题他
    viewController.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = YES;
    TFY_CATransitonAnimator *amn = [TFY_CATransitonAnimator animatorWithTransitionType:TransitionCube direction:DirectionToLeft transitionTypeOfDismiss:TransitionCube directionOfDismiss:DirectionToRight];
    [self pushViewController:viewController animator:amn];
}


@end
