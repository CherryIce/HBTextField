//
//  TFCell.h
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNTProctol.h"
#import "TNTDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFCell : UICollectionViewCell<TTDataDelegate>

@property (nonatomic , weak) id <TFCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
