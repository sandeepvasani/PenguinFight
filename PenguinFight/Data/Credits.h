//
//  Credits.h
//  Penguin Fight
//
//  Created by Tomy Le on 4/25/14.
//  Copyright (c) 2014 sandeep vasani CSCI 5931.01. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CCLayer.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

@interface Credits : CCNode

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;
+(CCScene *) scene;

@end
