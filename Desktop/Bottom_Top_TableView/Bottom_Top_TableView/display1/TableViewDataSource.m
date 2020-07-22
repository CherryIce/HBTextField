//
//  TableViewDataSource.m
//  Bottom_Top_TableView
//
//  Created by Mr.Zhu on 21/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "TableViewDataSource.h"

#define txtFont [UIFont systemFontOfSize:11]
#define iconW 25
#define txtLimitLines 3

@implementation TableViewDataSource

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        self.isRow = YES;
    }
    return self;
}

#pragma mark --  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isRow) {
        return 1;
    } else {
        return self.dataSourceArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isRow) {
        return self.dataSourceArray.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tbDelegate && [self.tbDelegate respondsToSelector:@selector(AAheightForRowAtIndexPath:)]) {
        return [self.tbDelegate AAheightForRowAtIndexPath:indexPath];
    }
    id model = self.dataSourceArray[indexPath.section];
    CGSize txtSize = [self calculateStringSizeWithBaseSize:CGSizeMake(100, MAXFLOAT) font:txtFont currentStr:model];
    CGFloat h = txtSize.height <= iconW ? iconW : txtSize.height;
    //计算高度
    return h + 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tbDelegate && [self.tbDelegate respondsToSelector:@selector(AAviewForHeaderInSection:)]) {
        return [self.tbDelegate AAviewForHeaderInSection:section];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataSourceArray[indexPath.section];
    CGSize txtSize = [self calculateStringSizeWithBaseSize:CGSizeMake(100, MAXFLOAT) font:txtFont currentStr:model];
    UITableViewCell *cell = nil;
    if (self.tbDelegate && [self.tbDelegate respondsToSelector:@selector(AAcellForRowAtIndexPath:model:width:)]) {
        cell = [self.tbDelegate AAcellForRowAtIndexPath:indexPath model:model width:txtSize.width];
    } else {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tbDelegate && [self.tbDelegate respondsToSelector:@selector(AAheightForHeaderInSection:)]) {
        return [self.tbDelegate AAheightForHeaderInSection:section];
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

/**
 * 计算文本所占size
 */
- (CGSize)calculateStringSizeWithBaseSize:(CGSize)baseSize font:(UIFont *)font currentStr:(NSString *) currentStr{
    CGSize finalSize = CGSizeZero;
#ifdef DEBUG
    //不限制行数计算宽高
    finalSize  = [currentStr boundingRectWithSize:baseSize
    options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName:font}
    context:nil].size;
#else
    //限制行数计算宽高
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.font = font;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = txtLimitLines;
    titleLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
    titleLabel.text = currentStr;
    CGFloat w = ceilf([titleLabel sizeThatFits:baseSize].width);
    CGFloat h = ceilf([titleLabel sizeThatFits:baseSize].height);
    finalSize = CGSizeMake(w, h);
#endif
    return finalSize;
}

@end
