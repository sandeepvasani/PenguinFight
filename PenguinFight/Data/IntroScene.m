#import "IntroLayer.h"
#import "IntroScene.h"

@implementation IntroScene


-(id) init
{
	self = [super init];
    if (self != nil) {
        IntroLayer *introLayer = [IntroLayer node];
        [self addChild:introLayer z:5];
        
	}
	return self;
    
}

@end