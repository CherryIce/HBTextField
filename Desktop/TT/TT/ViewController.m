//
//  ViewController.m
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"
#import "TTModel.h"
#import "TFCell.h"
#import "T1Cell.h"
#import "T2Cell.h"

@interface ViewController ()<TFCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , copy) NSArray * ttArray;

@property (nonatomic , strong) UICollectionView * cv;

@property (nonatomic , strong) NSMutableSet * reuseSet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TTModel * t1 = [[TTModel alloc] init];
    t1.titleStr = @"111";
    t1.cellClass = TFCell.class;
    
    TTModel * t2 = [[TTModel alloc] init];
    t2.titleStr = @"222";
    t2.cellClass = T1Cell.class;
    
    TTModel * t3 = [[TTModel alloc] init];
    t3.titleStr = @"333";
    t3.cellClass = T2Cell.class;
    
    _ttArray = @[t1,t2,t3];
    
    _reuseSet = [NSMutableSet set];
    [self.view addSubview:self.cv];
}

- (void)doTT {
    NSLog(@"cellEvent:%@",@"yes");
}

- (UICollectionView *)cv {
    if (!_cv) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.backgroundColor = [UIColor whiteColor];
    }
    return _cv;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _ttArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTModel * data = _ttArray[indexPath.item];
    TFCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self reuseIdentifierForCellClass:data.cellClass collectionView:collectionView] forIndexPath:indexPath];
    [cell setData:data atItem:indexPath.item];
    cell.delegate = self;
    return cell;
}

- (NSString *)reuseIdentifierForCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView{
    NSString *identifier = NSStringFromClass(cellClass);
    if (!identifier) {
        NSLog(@"cell or nib not existed");
        identifier = @"ttidentifier";
    }
    if (![_reuseSet containsObject:identifier]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:identifier ofType:@"nib"];
        if (path) {
            [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
        } else {
            [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
        }
        [_reuseSet addObject:identifier];
    }
    return identifier;
}

@end
