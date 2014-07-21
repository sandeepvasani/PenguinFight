//
//  GameBackgroundLayer.h
//  
//
//  
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCParallaxScrollNode.h"
#import "CCParallaxScrollOffset.h"

@interface GameBackgroundLayer : CCNode {
CCSprite *background1;
    CCSprite *background2;
    CCParallaxScrollNode * parallax;
}

@end