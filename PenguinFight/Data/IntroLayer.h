#import <GameKit/GameKit.h>
#import "CCNode.h"
#import "cocos2d.h"

@interface IntroLayer : CCNode
{
    CCSprite *penguinSprite;
    CCSprite *balloonBlueSprite;
    CCSprite *balloonGreenSprite;
}

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;

@end

