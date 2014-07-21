#import "GameMainMenuScene.h"
#import "GameMainMenuLayer.h"

@implementation GameMainMenuScene

-(id) init
{
	self = [super init];
    if (self != nil) {
	GameMainMenuLayer *gamemainmenuLayer = [GameMainMenuLayer node];
        [self addChild:gamemainmenuLayer z:5];
	
	}
	return self;

}

@end