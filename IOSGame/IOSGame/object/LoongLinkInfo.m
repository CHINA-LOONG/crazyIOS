//
//  LoongLinkInfo.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongLinkInfo.h"

@implementation LoongLinkInfo

-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2{
    self=[super init];
    if (self) {
        _points=[[NSMutableArray alloc] init];
        [_points addObject:p1];
        [_points addObject:p2];
    }
    return self;
}
-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2 P3:(LoongPoint*)p3{
    
    self=[super init];
    if (self) {
        _points=[[NSMutableArray alloc] init];
        [_points addObject:p1];
        [_points addObject:p2];
        [_points addObject:p3];
    }
    return self;
}
-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2 P3:(LoongPoint*)p3 P4:(LoongPoint*)p4{
    
    self=[super init];
    if (self) {
        _points=[[NSMutableArray alloc] init];
        [_points addObject:p1];
        [_points addObject:p2];
        [_points addObject:p3];
        [_points addObject:p4];
    }
    return self;
}

@end
