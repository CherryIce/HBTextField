//
//  ViewController.m
//  Bottom_Top_TableView
//
//  Created by Mr.Zhu on 21/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "ViewController.h"

#import "CustomTableViewCell.h"
#import "TableViewDataSource.h"

static const NSInteger maxCell = 7;

@interface ViewController ()<TableViewDataSourceDelegate>

@property (nonatomic,strong)UITableView * myTableView;

@property (nonatomic,strong)TableViewDataSource * dataSource;

@property (nonatomic,strong)NSMutableArray * textArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createTableView];
    [self setUpDataSource];

}
- (void)createTableView{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(100, 100, 200, 200) style:UITableViewStylePlain];
    //tableView.backgroundColor = [UIColor redColor];
    tableView.dataSource = self.dataSource;
    tableView.delegate = self.dataSource;
    self.dataSource.tbDelegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    tableView.transform = CGAffineTransformMakeScale(1, -1);
    self.myTableView = tableView;
}

/**
 *  造点假数据
 */
- (void)setUpDataSource
{
    for (NSInteger i = 0; i < 6; i++) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:@"生而为人,你且修身,你且渡人,你且如水,居恶渊而为善,无尤也"];
        for (NSInteger j = 0; j <= i; j++) {
            [text appendFormat:@"上善若水。水善利万物而不争，处众人之所恶，故几于道。居善地，心善渊，与善仁，言善信，政善治，事善能，动善时。夫唯不争，故无尤。"];
        }
        [text appendFormat:@"%zd", i];
        [self.textArr addObject:text];
    }
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
}

- (void)sendMessage
{
    NSString *text = self.textArr[arc4random() % 6];
   
    [self.dataSource.dataSourceArray insertObject:text atIndex:0];
    [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    if (self.dataSource.dataSourceArray.count > maxCell) {
        [self.dataSource.dataSourceArray removeLastObject];
        [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:self.dataSource.dataSourceArray.count] withRowAnimation:UITableViewRowAnimationNone];
    }
  
}

#pragma mark -- TableViewDataSourceDelegate
- (UITableViewCell *_Nullable)AAcellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath model:(id)model width:(CGFloat)width{
    CustomTableViewCell * cell = [CustomTableViewCell createChatTableViewCellWithTableView:self.myTableView];
    [cell fillCellWithString:model txtWidth:width];
    return cell;
}

#pragma mark -- lazy load
- (TableViewDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[TableViewDataSource alloc]init];
        _dataSource.isRow = NO;
    }
    return _dataSource;
}

- (NSMutableArray *)textArr
{
    if (!_textArr) {
        _textArr = [[NSMutableArray alloc] init];
    }
    return _textArr;
}

@end
