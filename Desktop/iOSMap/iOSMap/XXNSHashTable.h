//
//  XXNSHashTable.h
//  iOSMap
//
//  Created by Mr.Zhu on 02/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXNSHashTableDelegate <NSObject>

- (void) delegateFunc;

@end

@interface XXNSHashTable : NSObject

@property (nonatomic , strong) NSHashTable * delegates;

- (void) addDelegate:(__weak id)delegate;

@end

@interface TestYY : NSObject <XXNSHashTableDelegate>

@end

@interface TestZZ : NSObject <XXNSHashTableDelegate>

@end

