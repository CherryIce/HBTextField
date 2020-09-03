//
//  TNTDataProtocol.h
//  TT
//
//  Created by Mr.Zhu on 01/09/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#ifndef TNTDataProtocol_h
#define TNTDataProtocol_h

@protocol TTDataDelegate <NSObject>

- (void) setData:(id)data atItem:(NSInteger)item;

@end

#endif /* TNTDataProtocol_h */
