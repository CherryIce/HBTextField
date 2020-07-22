//
//  CustomTableViewCell.h
//  Bottom_Top_TableView
//
//  Created by Mr.Zhu on 21/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell

+ (instancetype)createChatTableViewCellWithTableView:(UITableView *)tableView;

- (void)fillCellWithString:(id)sting txtWidth:(CGFloat)txtWidth;

@end

NS_ASSUME_NONNULL_END
