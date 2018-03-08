//
//  LoongPieceImage.m
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import "LoongPieceImage.h"

@implementation LoongPieceImage

-(id)initWithImage:(UIImage*) image imageID:(NSString*) imgID{
    self=[super init];
    if (self) {
        _pieceImg=image;
        _pieceImgID=[imgID copy];
    }
    return self;
}
@end
