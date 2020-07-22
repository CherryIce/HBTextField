//
//  TableViewDataSource.h
//  Bottom_Top_TableView
//
//  Created by Mr.Zhu on 21/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol TableViewDataSourceDelegate <NSObject>
@required
- (UITableViewCell *_Nullable)AAcellForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath model:(id _Nullable )model width:(CGFloat)width;

@optional
- (CGFloat)AAheightForRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

- (UIView *_Nullable)AAviewForHeaderInSection:(NSInteger)section;

- (CGFloat)AAheightForHeaderInSection:(NSInteger)section;

@end

@interface TableViewDataSource : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * _Nonnull dataSourceArray;

/**
 *  设置是否是按组还是row  yes : row   no : section  默认是yes
 */
@property (nonatomic, assign) BOOL isRow;

/**
 有意思的代理
 */
@property (nonatomic, weak) id<TableViewDataSourceDelegate> _Nullable tbDelegate;

@end

