
#import "CCAnimation.h"
#import "IntroLayer.h"
#import "GameMainMenuScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
@implementation IntroLayer

@synthesize iPad, device;

-(id) init
{
	self = [super init];
    if (self != nil) {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
        
		CCLabelTTF *label =[CCLabelTTF labelWithString:@"Penguin Fight" fontName:@"American Typewriter" fontSize:65];
		CGSize size=[[CCDirector sharedDirector]viewSize];
        
		label.position=ccp(size.width/2,size.height/2);
		[self addChild: label ];
	}
    
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    
   /* CCSpriteBatchNode *penguinSpriteBatchNode;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
    penguinSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"penguinatlas.png"];
    penguinSprite = [CCSprite spriteWithSpriteFrame:@"penguin.png"];
    
    
    [penguinSpriteBatchNode addChild:penguinSprite];
    [self addChild:penguinSpriteBatchNode];
    
    [penguinSprite setPosition:CGPointMake(0 - penguinSprite.boundingBox.size.width, screenSize.height/4)];
    CCActionAnimation *penguinAnim = [CCActionAnimation animation];
    [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin2.png"]];
    [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin3.png"]];
    [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin4.png"]];
    [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin5.png"]];
    [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin6.png"]];
    id animateAction = [CCActionAnimate actionWithDuration:0.5f animation:penguinAnim restoreOriginalFrame:NO];
    id repeatAction = [CCRepeatForever actionWithAction:animateAction];
    [penguinSprite runAction:repeatAction];*/
    
    //The sprite animation
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
    
    NSMutableArray *flyAnimFrames = [NSMutableArray array];
    for(int i = 2; i <= 6; ++i)
    {
        [flyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"penguin%d.png", i]]];
    }
    CCAnimation *flyAnim = [CCAnimation
                             animationWithSpriteFrames:flyAnimFrames delay:0.1f]; //Speed in which the frames will go at
    
    //Adding png to sprite
   penguinSprite = [CCSprite spriteWithImageNamed:@"penguin.png"];
    [penguinSprite setPosition:CGPointMake(0 - penguinSprite.boundingBox.size.width, screenSize.height/4)];
    
    //Positioning the sprite
   // penguinSprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    
    //Repeating the sprite animation
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:flyAnim];
    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
    
    //Animation continuously repeating
    [penguinSprite runAction:repeatingAnimation];
    
    //Adding the Sprite to the Scene
    [self addChild:penguinSprite];
    
    
    
    [[OALSimpleAudio sharedInstance] playEffect:@"bicycle_bell.wav"];
    balloonBlueSprite = [CCSprite spriteWithImageNamed:@"ballonBlue.png"];
    [balloonBlueSprite setPosition:ccp(penguinSprite.position.x-10,penguinSprite.position.y+20)];
    [self addChild:balloonBlueSprite];
    balloonGreenSprite = [CCSprite spriteWithImageNamed:@"ballonGreen.png"];
    [balloonGreenSprite setPosition:ccp(penguinSprite.position.x+15,penguinSprite.position.y+20)];
    [self addChild:balloonGreenSprite];
    
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // If NOT on the iPad, scale down Ole
        // In your games, use this to load art sized for the device
        [penguinSprite setScaleX:screenSize.width/1024.0f];
        [penguinSprite setScaleY:screenSize.height/768.0f];
        [balloonBlueSprite setScaleX:screenSize.width/1024.0f];
        [balloonBlueSprite setScaleY:screenSize.height/768.0f];
        [balloonGreenSprite setScaleX:screenSize.width/1024.0f];
        [balloonGreenSprite setScaleY:screenSize.height/768.0f];
       

        
    }
    
    CGPoint pPoint = ccp(screenSize.width+100, penguinSprite.position.y);
    CGPoint bPoint = ccp(screenSize.width+100, balloonBlueSprite.position.y);
    CGPoint gPoint = ccp(screenSize.width+100, balloonGreenSprite.position.y);

    id flyAction = [CCActionMoveTo actionWithDuration:3.0f position:pPoint];
    id BflyAction = [CCActionMoveTo actionWithDuration:3.0f position:bPoint];
    id GflyAction = [CCActionMoveTo actionWithDuration:3.0f position:gPoint];
    
    [penguinSprite runAction:flyAction];
    [balloonBlueSprite runAction:BflyAction];
    [balloonGreenSprite runAction:GflyAction];
    
	return self;
    
}

-(void) onEnter
{
	[super onEnter];
	//[[CCDirector sharedDirector] replaceScene:[CCTransition transitionFadeWithDuration:4.0f scene:[GameMainMenuScene node] ]];
    
  /* [[CCDirector sharedDirector] replaceScene:[GameMainMenuScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:4.0f]];*/
}


@end
