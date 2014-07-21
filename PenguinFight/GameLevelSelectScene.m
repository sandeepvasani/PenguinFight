#import "GameLevelSelectScene.h"
#import "GameLevelSelectLayer.h"

@implementation GameLevelSelectScene

-(id) init
{
	self = [super init];
    if (self != nil) {
	GameLevelSelectLayer *gamelevelselectLayer = [GameLevelSelectLayer node];
        [self addChild:gamelevelselectLayer z:5];
	
	}
	return self;

}

@end