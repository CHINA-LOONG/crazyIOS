//
//  LoongLinkInfo.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoongPoint.h"

@interface LoongLinkInfo : NSObject
@property (nonatomic,strong) NSMutableArray* points;

-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2;
-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2 P3:(LoongPoint*)p3;
-(id)initWithP1:(LoongPoint*)p1 P2:(LoongPoint*)p2 P3:(LoongPoint*)p3 P4:(LoongPoint*)p4;

@end
