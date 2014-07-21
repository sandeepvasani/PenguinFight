//
//  GameBackgroundLayer.m
//  Testing
//
//  
//  
//

#import "GameBackgroundLayer.h"


@implementation GameBackgroundLayer

- (id)init
{
    self = [super init];
    if (self != nil) {

        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            // Indicates game is running on iphone
            background1 = [CCSprite spriteWithImageNamed:@"background-hd.png"];
              background2 = [CCSprite spriteWithImageNamed:@"background-hd.png"];
            
        }
        
       // CGSize screenSize = [[CCDirector sharedDirector] winSize];
        parallax = [CCParallaxScrollNode node];
        [parallax addInfiniteScrollXWithZ:0 Ratio:ccp(0.5,0.5) Pos:ccp(0,0) Objects:background1, background2, nil];
        [self addChild:parallax z:-1];
      /*  [background setPosition:
         CGPointMake(screenSize.width/2, screenSize.height/2)];
        
        [self addChild:background z:0 tag:0];*/
     //   [self scheduleUpdate];

    }
    return self;
}
-(void)update:(CCTime)delta
{
    
    
    float myVelocity = -1;
    [parallax updateWithVelocity:ccp(myVelocity, 0) AndDelta:delta];
}
@end


