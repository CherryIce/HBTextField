//
//  RAViewController.m
//  ATB
//
//  Created by Mr.Zhu on 02/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "RAViewController.h"

#import "CollectionViewCell.h"

@interface RAViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , assign) bool isIsLandscapeOrientation;//是否是横屏

@property (nonatomic , strong) UICollectionViewFlowLayout * layout;

@property (nonatomic , strong) UICollectionView * cv;

@end

@implementation RAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isIsLandscapeOrientation = NO;
    [self.cv registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
}

- (void)viewDidLayoutSubviews {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        //横屏
    }else{
        //竖屏
    }
}

- (UICollectionView *)cv {
    if (!_cv) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0.1;
        _layout.minimumInteritemSpacing = 0.1;
        _cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.backgroundColor = [UIColor whiteColor];
        _cv.pagingEnabled = YES;
        _cv.showsHorizontalScrollIndicator = NO;
        _cv.showsVerticalScrollIndicator = NO;
        _cv.alwaysBounceVertical = NO;
        _cv.alwaysBounceHorizontal = NO;
        _cv.decelerationRate = UIScrollViewDecelerationRateFast;
        if (@available(iOS 11.0, *)) {
            _cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_cv];
    }
    return _cv;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = @[[UIColor blueColor],[UIColor brownColor],[UIColor blackColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor redColor]][indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionViewLayout.collectionView.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    _isIsLandscapeOrientation = size.width < size.height ? YES : NO;
    // 翻转的时间
    CGFloat duration = [coordinator transitionDuration];
    [_layout invalidateLayout];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.cv.frame;
        frame.size = size;
        self.cv.frame = frame;
        self.cv.contentSize = CGSizeMake(size.width * 6, size.height);
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        [UIView animateWithDuration:0.25 animations:^{
            [self.cv performBatchUpdates:^{
                [self.cv scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
          } completion:nil];
        }];
    }];
}

// 允许自动旋转
-(BOOL)shouldAutorotate{
    return YES;
}

//  状态栏隐藏
-(BOOL)prefersStatusBarHidden{
    return YES;
}


@end
