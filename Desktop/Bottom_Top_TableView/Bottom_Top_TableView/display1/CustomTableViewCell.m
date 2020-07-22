//
//  CustomTableViewCell.m
//  Bottom_Top_TableView
//
//  Created by Mr.Zhu on 21/07/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "CustomTableViewCell.h"

#define txtFont [UIFont systemFontOfSize:11]
#define iconW 25
#define txtLimitLines 3

@interface CustomTableViewCell()
{
    CGFloat _txtWidth;
}

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIImageView * icon;

@property (nonatomic, strong) UILabel * txtLabel;

@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)createChatTableViewCellWithTableView:(UITableView *)tableView{
    CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    if (!cell) {
        cell = [[CustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDChatTableViewCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.mainView];
        [self.mainView addSubview:self.icon];
        [self.mainView addSubview:self.txtLabel];
    }
    return self;
}

- (void)fillCellWithString:(id)str txtWidth:(CGFloat)txtWidth{
    
    _txtWidth = txtWidth;

    self.txtLabel.text = str;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat total_width = 5 + _txtWidth + 5 + iconW + 3;
    
    CGRect mainFrame = self.mainView.frame;
    mainFrame.origin.x = CGRectGetWidth(self.frame) - total_width - 10;
    mainFrame.origin.y = 0;
    mainFrame.size.width = total_width;
    mainFrame.size.height = CGRectGetHeight(self.frame);
    self.mainView.frame = mainFrame;
    
    CGRect iconFrame = self.icon.frame;
    iconFrame.origin.y = CGRectGetHeight(mainFrame) - 3 - iconW;//倒过来的 不能给3
    iconFrame.origin.x = CGRectGetWidth(mainFrame) - iconW - 3;
    iconFrame.size.width = iconW;
    iconFrame.size.height = iconW;
    self.icon.frame = iconFrame;
    
    CGRect txtFrame = self.txtLabel.frame;
    txtFrame.origin.y = 3;
    txtFrame.origin.x = 5;
    txtFrame.size.height = CGRectGetHeight(mainFrame) - 6;
    txtFrame.size.width = _txtWidth;
    self.txtLabel.frame =  txtFrame;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    UIView * filterView = [super hitTest:point withEvent:event];
    if (filterView == self.contentView) {
        NSLog(@">>>>>>%@",filterView.superview.superview.superview);
        /**
         * 操作view上面的
         UIView * view = filterView.superview.superview.superview;
         for (int i = 0; i < view.subviews.count; i++) {
             UIView * v1 = view.subviews[i];
             if ([v1 isKindOfClass:[OtherView class]]) {
                 return v1;
             }
         }
         */
    }
    return filterView;
}

#pragma mark -- lazy load
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _mainView.layer.cornerRadius = 15.f;
        _mainView.layer.masksToBounds  = YES;
        _mainView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    }
    return _mainView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.layer.cornerRadius = iconW/2;
        _icon.layer.masksToBounds = YES;
        _icon.backgroundColor = [UIColor whiteColor];
        _icon.transform = CGAffineTransformMakeScale(1, -1);
    }
    return _icon;;
}

- (UILabel *)txtLabel {
    if (!_txtLabel) {
        _txtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _txtLabel.font = txtFont;
#ifdef DEBUG
        _txtLabel.numberOfLines = 0;
#else
        _txtLabel.numberOfLines = txtLimitLines;
#endif
        _txtLabel.textColor = [UIColor whiteColor];
        _txtLabel.transform = CGAffineTransformMakeScale(1, -1);
    }
    return _txtLabel;
}

@end
