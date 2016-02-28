//
//  MainViewController.m
//  XProject
//
//  Created by Jerry.Yao on 16/2/13.
//  Copyright © 2016年 Jerry.Yao. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"
#import "MainViewFrame.h"
#import "MainViewModel.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"
#import "EViewController.h"
#import "FViewController.h"

#import "LoginViewController.h"

static NSString *reuseIdentifier = @"mainViewCell";

typedef  NS_ENUM(NSInteger, MainView){
    MainViewA,
    MainViewB,
    MainViewC,
    MainViewD,
    MainViewE,
    MainViewF,
    MainViewCount
};

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupView
{
    _datas = [[NSMutableArray alloc] init];
    NSArray *titlesArray = @[@"A", @"B", @"C", @"D", @"E", @"F"];
    NSArray *imagesArray = @[@"book_room", @"icon_contact", @"icon_meetingroom", @"icon_overtime", @"icon_vacation", @"vacation"];
    
    for (int index = 0; index < titlesArray.count; index++) {
        MainViewModel *mainViewModel = [[MainViewModel alloc] init];
        mainViewModel.title = titlesArray[index];
        mainViewModel.image = imagesArray[index];
        
        MainViewFrame *mainViewFrame = [[MainViewFrame alloc] init];
        mainViewFrame.mainViewModel = mainViewModel;
        [self.datas addObject:mainViewFrame];
        
    }
    
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 45);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[MainViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    return _collectionView;
}

#pragma mark - UICollectionView数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MainViewCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.mainViewFrame = self.datas[indexPath.row];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout : cell的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewFrame *mainViewFrame =  self.datas[indexPath.row];
    if (!mainViewFrame) return CGSizeZero;
    
    return CGSizeMake((kScreenWidth  - 10 ) / 2, mainViewFrame.rowHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    if (selectedItems.count) {
        [self.collectionView deselectItemAtIndexPath:[selectedItems firstObject] animated:YES];
    }
    
    switch (indexPath.row) {
        case MainViewA:
        {
            AViewController *aVC = [[AViewController alloc] init];
            [self.navigationController pushViewController:aVC animated:YES];
        }
            break;
        case MainViewB:
        {
            BViewController *bVC = [[BViewController alloc] init];
            [self.navigationController pushViewController:bVC animated:YES];
        }
            break;
        case MainViewC:
        {
            // IM登录页面
            LoginViewController *cVC = [[LoginViewController alloc] init];
            [XmppManager sharedManager].isLoginOperation = YES;
//            CViewController *cVC = [[CViewController alloc] init];
            [self.navigationController pushViewController:cVC animated:YES];
        }
            break;
        case MainViewD:
        {
            DViewController *dVC = [[DViewController alloc] init];
            [self.navigationController pushViewController:dVC animated:YES];
        }
            break;
        case MainViewE:
        {
            EViewController *eVC = [[EViewController alloc] init];
            [self.navigationController pushViewController:eVC animated:YES];
        }
            break;
        case MainViewF:
        {
            FViewController *fVC = [[FViewController alloc] init];
            [self.navigationController pushViewController:fVC animated:YES];
        }
            break;
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 允许选中时，高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置每组的cell的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//
////cell的最小行间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
//
////cell的最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}


//- (NSMutableArray *)datas
//{
//    if (_datas) {
//        _datas = [[NSMutableArray alloc] init];
//    }
//    return _datas;
//}

@end
