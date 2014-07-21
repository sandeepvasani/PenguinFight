#import "GameOptionsScene.h"
#import "GameOptionsLayer.h"

@implementation GameOptionsScene

-(id) init
{
	self = [super init];
    if (self != nil) {
	GameOptionsLayer *gameoptionsLayer = [GameOptionsLayer node];
        [self addChild:gameoptionsLayer z:5];
	
	}
	return self;

}

@end