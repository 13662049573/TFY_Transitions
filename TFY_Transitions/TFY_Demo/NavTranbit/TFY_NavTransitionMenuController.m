//
//  TFY_NavTransitionMenuController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_NavTransitionMenuController.h"
#import "TFY_FirstTableController.h"
#import "TFY_RegisterInteractiveController.h"
#import "TFY_Section.h"

@interface TFY_NavTransitionMenuController ()
@property(nonatomic, strong) NSArray <TFY_Section *>*data;
@end

@implementation TFY_NavTransitionMenuController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 手动恢复tabbar的显示
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Menu";
    TFY_Section *pushSection = [TFY_Section new];
    pushSection.title = @"Push / pop";
    pushSection.show = YES;
    pushSection.rows = @[@"Swipe Animator", @"CATransition Animator" ,
                         @"CuStom Animator", @"个人动画案例收集（TLAnimator）"];
    
    TFY_Section *registerInteractiveSection = [TFY_Section new];
    registerInteractiveSection.title = @"注册手势进行push";
    registerInteractiveSection.show = YES;
    registerInteractiveSection.rows = @[@"Push"];
    _data = @[pushSection,registerInteractiveSection];
    
    self.tableView.tableFooterView = [UIView new];
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
        vc.isModal = NO;
        viewController = vc;
    }else {
        TFY_FirstTableController *vc = [TFY_FirstTableController new];
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
