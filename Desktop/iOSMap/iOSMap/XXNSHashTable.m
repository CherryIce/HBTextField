//
//  XXNSHashTable.m
//  iOSMap
//
//  Created by Mr.Zhu on 02/06/2020.
//  Copyright © 2020 Mr.hu. All rights reserved.
//

#import "XXNSHashTable.h"

@implementation XXNSHashTable

- (instancetype)init {
    if (self == [super init]) {
        self.delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

+ (void) load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XXNSHashTable * xx = [[XXNSHashTable alloc] init];
        TestYY * yy = [[TestYY alloc] init];
        TestZZ * zz = [[TestZZ alloc] init];
        
        [xx addDelegate:yy];
        [xx dosomething];
        
        [xx addDelegate:zz];
        [xx dosomething];
    });
}

- (void) addDelegate:(__weak id)delegate {
    if(delegate &&self.delegates&& ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void) dosomething {
    for (id<XXNSHashTableDelegate>delegate in self.delegates) {
        if (delegate && ![delegate isKindOfClass:[NSNull class]] && [delegate respondsToSelector:@selector(delegateFunc)]) {
            [delegate delegateFunc];
        }
    }
}

@end

@implementation TestYY

- (void)delegateFunc {
    NSLog(@"yy do it");
}

@end

@implementation TestZZ

- (void)delegateFunc {
    NSLog(@"zz do it");
}

@end
