//
//  TFY_AppStoreListController.m
//  TFY_Transitions
//
//  Created by 田风有 on 2021/1/17.
//

#import "TFY_AppStoreListController.h"
#import "TFY_AppStoreCardCell.h"
#import "TFY_AppStoreDetialController.h"
#import "TFY_AppStoreCardAmiator.h"


@interface TFY_AppStoreListController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *cards;
@end

@implementation TFY_AppStoreListController

static NSString * const reuseIdentifier = @"AppStoerCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"App Store";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cards = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(transit_ScreenW-30, transit_ScreenH/3-10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 5, 15);
    layout.headerReferenceSize = CGSizeMake(transit_ScreenW, 40);
    UICollectionView *cView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:cView];
    cView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    cView.delegate = self;
    cView.dataSource = self;
    self.collectionView = cView;
    
    [self.collectionView registerClass:[TFY_AppStoreCardCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _cards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFY_AppStoreCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:_cards[indexPath.row]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.transform = CGAffineTransformIdentity;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFY_AppStoreDetialController *vc = [TFY_AppStoreDetialController new];
    vc.imgName = _cards[indexPath.row];
    
    TFY_AppStoreCardCell *cell = (TFY_AppStoreCardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect frame = [collectionView convertRect:cell.frame toView:TFY_TransitFunction.appKeyWindow];
    TFY_AppStoreCardAmiator *animator = [TFY_AppStoreCardAmiator new];
    animator.fromRect = frame;
    
    animator.textView = vc.textLabel;
    animator.cardView = vc.imageView;
    
    [self presentViewController:vc animator:animator completion:^{}];
    
}

@end
