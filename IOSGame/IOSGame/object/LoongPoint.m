//
//  LoongPoint.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongPoint.h"

@implementation LoongPoint
- (id)initWithX:(NSInteger)x y:(NSInteger)y{
    
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    
    // 复制一个对象
    LoongPoint* newPt = [[[self class] allocWithZone:zone] init];
    // 将被复制对象的实变量的值赋给新对象的实例变量
    newPt->_x = _x;
    newPt->_y = _y;
    return newPt;
}

- (BOOL)isEqual:(LoongPoint*)other
{
    return _x == other.x && _y == other.y;
}
- (NSUInteger) hash
{
    return _x * 31 + _y;
}
- (NSString*)description
{
    return [NSString stringWithFormat:@"{x=%d, y=%d}" , _x , _y];
}

@end
