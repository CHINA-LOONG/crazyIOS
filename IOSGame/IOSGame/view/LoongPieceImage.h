//
//  LoongPieceImage.h
//  IOSGame
//
//  Created by 薛龙 on 2018/3/6.
//  Copyright © 2018年 xuelong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface LoongPieceImage : NSObject
@property (nonatomic,strong) UIImage* pieceImg;
@property (nonatomic,copy) NSString* pieceImgID;

-(id)initWithImage:(UIImage*) image imageID:(NSString*) imgID;
@end
