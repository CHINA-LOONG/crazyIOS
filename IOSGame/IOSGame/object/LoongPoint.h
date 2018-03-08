//
//  LoongPoint.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoongPoint : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
- (id)initWithX:(NSInteger)x y:(NSInteger)y;

@end
