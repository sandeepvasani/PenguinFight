//
//  PauseButton.m
//  
//
//
#import "cocos2d-ui.h"
#import "PauseButton.h"
#import "GameLevelSelectScene.h"
#import "GamePlayScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
#define TAG_RESUME_BUTTON  33

@implementation PauseButton
-(id)init
{
    if ((self = [super init]))
    {
      /*  CGSize screenSize = [[CCDirector sharedDirector] winSize];
        pauseBtn1 = [CCMenuItemImage itemWithNormalImage:@"pausedemobtn.png" selectedImage:@"pausedemobtn.png" target:self selector:@selector(pauseButtonTouched:)];
        
        CCMenu* menu = [CCMenu menuWithItems:pauseBtn1, nil];
        menu.position = ccp(screenSize.width * 0.9f, screenSize.height * 0.9f);
        [self addChild:menu];*/
        [self createPauseButton];
        mePaused = false;
        
                              //but we will add it as child only when game is paused
                                        //and remove on resume.
        [self createPausedMenu];
       /* resumeSlider = [CCSprite spriteWithFile:@"resume_bg.png"];
        [self addChild:resumeSlider z:10];
        resumeSlider.position = ccp((screenSize.width + [resumeSlider texture].contentSize.width / 2) , screenSize.height/2);
        
        CCMenuItemImage* resumeBtn = [CCMenuItemImage itemWithNormalImage:@"resume_button.png" selectedImage:@"resume_button.png" target:self selector:@selector(pauseButtonTouched:)];
        resumeBtn.tag = TAG_RESUME_BUTTON;
        CCMenu* resMenu = [CCMenu menuWithItems:resumeBtn, nil];
        
        [resumeSlider addChild:resMenu];
        [resMenu setPosRelativeToParentPos:ccp(-70.0f,65.0f)];*/
    }
    return self;
}


- (void)createPauseButton {
    
    // create sprite for the pause button
    pauseBtn = [CCSprite spriteWithImageNamed:@"PauseButton.png"];
    
    // create menu item for the pause button from the pause sprite
    CCButton *item = [ CCButton buttonWithTitle:@"" spriteFrame:pauseBtn.spriteFrame];
    [item setTarget:self selector:@selector(pauseButtonTouched)];
    
    // create menu for the pause button and put the menu item on the menu
  //  NSArray* menuItems = @[item];
    CCLayoutBox* menuBox = [[CCLayoutBox alloc] init];
   
    [menuBox setAnchorPoint:ccp(0, 0)];
    //[menuBox setIsRelativeAnchorPoint:NO];
    [menuBox setPosition:ccp([CCDirector sharedDirector].viewSize.width/2, [CCDirector sharedDirector].viewSize.height-16)];
    [menuBox setScale:0.3];
    [menuBox addChild:item];
    [self addChild:menuBox];
}

 -(void)createPausedMenu {
 
    // create a sprite that says simply 'Paused'
     
    pausedSprite = [CCSprite spriteWithImageNamed:@"Paused.png"];
 
    // create the quit button
    CCButton *item1 =
     [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"QuitButton.png"]];
      [item1 setTarget:self selector:@selector(quitButtonWasPressed)];
      
    // create the restart button
  /*  CCMenuItemSprite *item2 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"RestartButton.png"]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(restartButtonWasPressed:)]; */
      CCButton *item2 =
      [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"RestartButton.png"]];
       [item2 setTarget:self selector:@selector(restartButtonWasPressed)];
      
    // create the resume button
  /*  CCMenuItemSprite *item3 =
    [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"ResumeButton.png"]
                            selectedSprite:nil
                                    target:self
                                  selector:@selector(pauseButtonTouched:)];*/
     
     CCButton *item3 =
     [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"ResumeButton.png"]];
     [item3 setTarget:self selector:@selector(pauseButtonTouched)];
     
     item3.name = @"TAG_RESUME_BUTTON";
     NSArray* menuItems = @[item1, item2, item3];
    // put all those three buttons on the menu
   // pausedMenu = [CCMenu menuWithItems:item1, item2, item3, nil];
    CCLayoutBox* pausedMenu = [[CCLayoutBox alloc] init];
    // align the menu
  /*  [pausedMenu alignItemsInRows:
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     [NSNumber numberWithInt:1],
     nil];*/
     
     pausedMenu.direction=CCLayoutBoxDirectionHorizontal;
     
 
    // create the paused sprite and paused menu buttons off screen
    [pausedSprite setPosition:ccp([CCDirector sharedDirector].viewSize.width/2-10, [CCDirector sharedDirector].viewSize.height + 200)];
    [pausedMenu setPosition:ccp([CCDirector sharedDirector].viewSize.width/2, -300)];
 
    // add the Paused sprite and menu to the current layer
    [self addChild:pausedSprite z:100];
    [self addChild:pausedMenu z:100];
}


- (void)quitButtonWasPressed:(id)sender {
    // [SceneManager goLevelSelect];
    [[OALSimpleAudio sharedInstance]stopEverything];
    /*[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLevelSelectScene node] ]];*/
    
    [[CCDirector sharedDirector] replaceScene:[GameLevelSelectScene node] withTransition:[CCTransition transitionFadeWithDuration:1.0]];
}
- (void)restartButtonWasPressed:(id)sender {
    //[SceneManager goGameScene];
	[[CCDirector sharedDirector] replaceScene:[GamePlayScene node] withTransition:[CCTransition transitionFadeWithDuration:1.0]];
}

- (void)resumeButtonWasPressed:(id)sender {
 
    // unpause the game
    paused = NO;
        // show the pause button
    [pauseBtn runAction:[CCActionFadeIn actionWithDuration:0.5]];
 
    // hide the sprite that shows the word 'Paused' from view
    [pausedSprite runAction:[CCActionMoveTo actionWithDuration:0.5
                                                position:ccp([CCDirector sharedDirector].viewSize.width/2-10, [CCDirector sharedDirector].viewSize.height + 200)]];
    // hide the paued menu from view
    [pausedMenu runAction:[CCActionMoveTo actionWithDuration:0.5
                                              position:ccp([CCDirector sharedDirector].viewSize.width/2, -300)]];
 
}
//This function is called whenever pause button is touched
//or can be called from outside (for example from AppDelegate's applicationWillResignActive)
//We do Pause or Resume in this function depending on the state of game.
//Single function is used for both the operations so that same behaviour is achieved even if
//we remvove the resume button. i.e. pause/resume are both done by the pause button itself.
-(void)pauseButtonTouched:(id)sender
{
    NSLog(@"Pause/unpause called!!!");
    CCNode* node = [self parent];
    
    BOOL fromButton = NO;   //Boolean to check whether the function is called from the resume button or
                            //from somewhere else(for example AppDelegate's applicationWillResignActive)
    
    if ([sender isKindOfClass:[CCButton class]])
    {
        CCButton* senderBtn = (CCButton*)sender;
        fromButton = ([@"TAG_RESUME_BUTTON"  isEqual: senderBtn.name]);
    }
    
    //Resume shud be done only from resume-button press..
    //If not done so and applicationWillResignActive also calls this function, then it will unpause
    //the game if its already paused(For eg. when Home button pressed while game is paused).
    if(mePaused)
    {
        if (fromButton)
        {
            mePaused = false;
            
            CGSize screenSize = [[CCDirector sharedDirector] viewSize];
          //  CGPoint hiddenPos = ccp((screenSize.width + [resumeSlider texture].contentSize.width / 2) , screenSize.height/2);
            
            CCActionCallFunc* func0 = [CCActionCallFunc actionWithTarget:self selector:@selector(resumeButtonWasPressed:)];
            
            CCActionCallFunc* func1 = [CCActionCallFunc actionWithTarget:self selector:@selector(funcRemoveLayer)];
            
            CCActionCallFunc* func2 = [CCActionCallFunc actionWithTarget:self selector:@selector(funcResumeGame)];
            
            CCActionSequence* seq = [CCActionSequence actions:func0,func1,func2, nil];
            
                                //resume after all actions are over.
                                //and since puasebtn and its children are not
                                //not paused,there's no problem.
            
            [pausedMenu runAction:seq];
            [[OALSimpleAudio sharedInstance]playBg];
        }
        else
        {
            //From applicationWillResignActive while game paused...nothing to do.
            NSLog(@"Not from ResumeButton while game paused.Not resuming.");
        }
    }
    else
    {
        [self pauseSchedulerAndActionsRecursive:node];
        mePaused = true;
        [[OALSimpleAudio sharedInstance]stopBg];
        
        //Adding pause layer that will create transparent hue on the game
        //and swallow all the touches.
        //To achieve this add the layer with z-order higher than other game elements.
     //  [self addChild:pausedLayer z:5];
        pausedLayer = [PauseLayer node];  //A layer to create a hue on game and swallow all touches
        [self addChild:pausedLayer z:5];
        CGSize screenSize = [[CCDirector sharedDirector] viewSize];
     // hide the pause button
    [pauseBtn1 runAction:[CCActionFadeOut actionWithDuration:0.5]];
 
    // bring the sprite that shows the word 'Paused' into view
    [pausedSprite runAction:[CCActionMoveTo actionWithDuration:0.5
                                               position:ccp([CCDirector sharedDirector].viewSize.width/2-10, [CCDirector sharedDirector].viewSize.height/2+50)]];
    // bring the paued menu into view
    [pausedMenu runAction:[CCActionMoveTo actionWithDuration:0.5
                                              position:ccp([CCDirector sharedDirector].viewSize.width/2, [CCDirector sharedDirector].viewSize.height/2-100)]];
    }
}

-(void)funcRemoveLayer
{
    [self removeChild:pausedLayer cleanup:NO];
}

-(void)funcResumeGame
{
    CCNode* node = [self parent];
    [self resumeSchedulerAndActionsRecursive:node];
}


//These functions will pause/resume the game.
//Notice that we are not using the CCDirector pause/resume api as it stops everything in the game.
//Here only the game is paused but the puase layer and pause button are not, so we can still
//run actions or animations on it , if need be.
- (void)pauseSchedulerAndActionsRecursive:(CCNode *)node
{
    //NSLog(@"node: %@",node);
    if (node != self)  //actions have to run for pauselayer sprites.skipping PauseButton & its children
    {
        node.paused=true;
        for (CCNode *child in [node children])
        {
            [self pauseSchedulerAndActionsRecursive:child];
        }
    }
}

- (void)resumeSchedulerAndActionsRecursive:(CCNode *)node
{
    if (node != self) 
    {
        node.paused=false;
        for (CCNode *child in [node children])
        {
            [self resumeSchedulerAndActionsRecursive:child];
        }
    }
}
@end

@implementation CCNode (IABPauseButton)
-(void) setPosRelativeToParentPos:(CGPoint)pos
{
    CGPoint parentAP = _parent.anchorPoint;
    CGSize parentCS = _parent.contentSize;
    self.position = ccp(parentCS.width * parentAP.x + pos.x,
						parentCS.height * parentAP.y + pos.y);
}
@end
