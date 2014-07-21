//
//  GameplayLayer.m
//  
//
//  Created by macuser2 on 2/10/14.
//  Copyright Sandeep 2014. All rights reserved.

#import "GamePlayLayer.h"
#import "GamePlayScene.h"
#import "GameLevelSelectScene.h"
#import "GameOverScene.h"
#import "LevelParser.h"
#import "Level.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
#import "Constants.h"

@implementation GamePlayLayer

@synthesize iPad, device, mute;




-(void)initJoystickAndButtons {
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    CGRect joystickBaseDimensions =  CGRectMake(0, 0, 128.0f, 128.0f);
    CGPoint joystickBasePosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // The device is an iPad running iPhone 3.2 or later.
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition = ccp(screenSize.width*0.0625f, screenSize.height*0.052f);
        
    } else {
        // The device is an iPhone or iPod touch.
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        joystickBasePosition = ccp(screenSize.width*0.07f, screenSize.height*0.11f);
        
    }
    SneakyJoystickSkinnedBase *joystickBase =
    [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position = joystickBasePosition;
    joystickBase.backgroundSprite =
    [CCSprite spriteWithFile:@"transparentDark05.png"];
    joystickBase.thumbSprite =
    [CCSprite spriteWithFile:@"shadedLight01.png"];
    joystickBase.joystick = [[SneakyJoystick alloc]
                             initWithRect:joystickBaseDimensions];
    leftJoystick = [joystickBase.joystick retain];
    [self addChild:joystickBase z:10];
}

-(void)playBackgroundMusic
{
    if (mute == true)
    {
        mute = false;
    }
    else if (mute == false)
    {
        mute = true;
        [[OALSimpleAudio sharedInstance]stopBg];
    }
}

-(void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime
{
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    float maxX = screenSize.width + penguinSprite.contentSize.width/2-4;
    float minX = -penguinSprite.contentSize.width/2+4;
   
    
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 240.0f);
    CGPoint newPosition =
    ccp(tempNode.position.x + scaledVelocity.x * deltaTime,
        tempNode.position.y);
    
    if (newPosition.x>maxX) {
        newPosition.x=minX;
    }
    if (newPosition.x<minX) {
        newPosition.x=maxX;
    }
    /*
     if(intPlayerNewX > (355 - MovingObjectRadius))
     {
     intPlayerNewX = (355 - MovingObjectRadius);
     }
     if (intPlayerNewX <(-30 + MovingObjectRadius))
     {
     intPlayerNewX = (-30 + MovingObjectRadius);
     }
     if(intPlayerNewY >(480 - MovingObjectRadius))
     {
     intPlayerNewY = (480 - MovingObjectRadius);
     }
     if (intPlayerNewY <(0 + MovingObjectRadius))
     {
     intPlayerNewY = (0 + MovingObjectRadius);
     }
     */
    
    [tempNode setPosition:newPosition];
    [balloonBlueSprite setPosition:ccp(newPosition.x-10,newPosition.y+20)];
    [balloonGreenSprite setPosition:ccp(newPosition.x+15,newPosition.y+20)];
}


-(void)myAppResignActive
{
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
    [pauseBtnClassObj  pauseButtonTouched:self];
}

-(void)tick:(CCTime)dt
{
 /*   if(self.isGamePaused || self.isGameOver)
        return;*/

    mTimeInSec +=dt;

    float digit_min = mTimeInSec/60.0f;
   // float digit_hour = (digit_min)/60.0f;
    float digit_sec = ((int)mTimeInSec%60);

    int min = (int)digit_min;
  //  int hours = (int)digit_hour;
    int sec = (int)digit_sec;

    [mTimeLbl setString:[NSString stringWithFormat:@"%.2d:%.2d",min,sec]];

}

- (id)init
{
    self = [super init];
    if (self != nil) {
        
        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
      //  self.tag= 1000;      // change this for other levels
        int myInt=1000;
        self.name=[NSString stringWithFormat:@"%d", myInt];
		
        // Determine Screen Size
        screenSize = [CCDirector sharedDirector].viewSize;
        paused=NO;
		
		//initialise all game variables
		enemyPenguinCount=3;
        penguinLives=3;
		penguinballoonCount=2;
		enemy1balloonCount=2;
		enemy2balloonCount=2;
		enemy3balloonCount=2;
        
         redflag=0;
        yellowflag=0;
        
        redflag1=0;
        yellowflag1=0;

        
        redflag2=0;
        yellowflag2=0;

        
        redflag3=0;
        yellowflag3=0;

        
        penguindied=0;
         enemy1died=0;
         enemy2died=0;
        enemy3died=0;
		
        if(mute == false)
        {
        [[OALSimpleAudio sharedInstance]playBg:@"Dream Culture.mp3" loop:YES];
        }
        else
        {
            [[OALSimpleAudio sharedInstance]stopBg];
        }
        
		 pauseBtnClassObj = [PauseButton  node];
        [self  addChild:pauseBtnClassObj z:1000];
        
        mTimeLbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"00:00:", self.device]
                                               fontName:@"Marker Felt" 
                                               fontSize:14]; 
        
        mTimeLbl.position = ccp( screenSize.width*0.85,screenSize.height*0.95);
		 
        // Add timelabel to this layer
        [self addChild:mTimeLbl z:0]; 
		
		mTimeInSec = 0.0f;
		[self schedule:@selector(tick:)];
        
        penguinlivesLbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Lives X  3"]
                                      fontName:@"Marker Felt"
                                      fontSize:14];
         penguinlivesLbl.position = ccp( screenSize.width*0.10,screenSize.height*0.95);
         [self addChild:penguinlivesLbl z:0];
        
        CCSpriteBatchNode *penguinSpriteBatchNode;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
        penguinSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"penguinatlas.png"];
        penguinSprite = [CCSprite spriteWithSpriteFrameName:@"penguin.png"];
        [penguinSpriteBatchNode addChild:penguinSprite];
        [self addChild:penguinSpriteBatchNode];
        [penguinSprite setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.5f)];
        CCAnimation *penguinAnim = [CCAnimation animation];
        [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin2.png"]];
        [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin3.png"]];
        [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin4.png"]];
        [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin5.png"]];
        [penguinAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin6.png"]];
        id animateAction = [CCActionAnimate actionWithDuration:0.5f animation:penguinAnim restoreOriginalFrame:NO];
        id repeatAction = [CCActionRepeatForever actionWithAction:animateAction];
        [penguinSprite runAction:repeatAction];
        
        //Creates Player Ballon Sprites
        balloonBlueSprite = [CCSprite spriteWithFile:@"ballonBlue.png"];
        [balloonBlueSprite setPosition:ccp(penguinSprite.position.x-10,penguinSprite.position.y+20)];
        [self addChild:balloonBlueSprite];
        balloonGreenSprite = [CCSprite spriteWithFile:@"ballonGreen.png"];
        [balloonGreenSprite setPosition:ccp(penguinSprite.position.x+15,penguinSprite.position.y+20)];
        [self addChild:balloonGreenSprite];
        
        //Creates Enemy Penguin Sprite
        CCSpriteBatchNode *enemySpriteBatchNode1;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
        enemySpriteBatchNode1 = [CCSpriteBatchNode batchNodeWithFile:@"penguinatlas.png"];
        enemySprite1 = [CCSprite spriteWithSpriteFrameName:@"penguin.png"];
        [enemySpriteBatchNode1 addChild:enemySprite1];
        [self addChild:enemySpriteBatchNode1];
       // [enemySprite1 setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        CCAnimation *enemyAnim1 = [CCAnimation animation];
        [enemyAnim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin2.png"]];
        [enemyAnim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin3.png"]];
        [enemyAnim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin4.png"]];
        [enemyAnim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin5.png"]];
        [enemyAnim1 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin6.png"]];
        id animateEnemyAction1 = [CCActionAnimate actionWithDuration:0.5f animation:enemyAnim1 restoreOriginalFrame:NO];
        id repeatEnemyAction1 = [CCActionRepeatForever actionWithAction:animateEnemyAction1];
        [enemySprite1 runAction:repeatEnemyAction1];
        

        CCSpriteBatchNode *enemySpriteBatchNode2;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
        enemySpriteBatchNode2 = [CCSpriteBatchNode batchNodeWithFile:@"penguinatlas.png"];
        enemySprite2 = [CCSprite spriteWithSpriteFrameName:@"penguin.png"];
        [enemySpriteBatchNode2 addChild:enemySprite2];
        [self addChild:enemySpriteBatchNode2];
         //[enemySprite2 setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        CCAnimation *enemyAnim2 = [CCAnimation animation];
        [enemyAnim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin2.png"]];
        [enemyAnim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin3.png"]];
        [enemyAnim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin4.png"]];
        [enemyAnim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin5.png"]];
        [enemyAnim2 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin6.png"]];
        id animateEnemyAction2 = [CCActionAnimate actionWithDuration:0.5f animation:enemyAnim2 restoreOriginalFrame:NO];
        id repeatEnemyAction2 = [CCActionRepeatForever actionWithAction:animateEnemyAction2];

        [enemySprite2 runAction:repeatEnemyAction2];
        
        
        CCSpriteBatchNode *enemySpriteBatchNode3;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"penguinatlas.plist"];
        enemySpriteBatchNode3 = [CCSpriteBatchNode batchNodeWithFile:@"penguinatlas.png"];
        enemySprite3 = [CCSprite spriteWithSpriteFrameName:@"penguin.png"];
        [enemySpriteBatchNode3 addChild:enemySprite3];
        [self addChild:enemySpriteBatchNode3];
        //[enemySprite2 setPosition:CGPointMake(screenSize.width/2, screenSize.height*0.17f)];
        CCAnimation *enemyAnim3 = [CCAnimation animation];
        [enemyAnim3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin2.png"]];
        [enemyAnim3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin3.png"]];
        [enemyAnim3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin4.png"]];
        [enemyAnim3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin5.png"]];
        [enemyAnim3 addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"penguin6.png"]];
        id animateEnemyAction3 = [CCActionAnimate actionWithDuration:0.5f animation:enemyAnim3 restoreOriginalFrame:NO];
        id repeatEnemyAction3 = [CCActionRepeatForever actionWithAction:animateEnemyAction3];
        
        [enemySprite3 runAction:repeatEnemyAction3];
    
        
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            // If NOT on the iPad, scale down Ole
            // In your games, use this to load art sized for the device
            [penguinSprite setScaleX:screenSize.width/1024.0f];
            [penguinSprite setScaleY:screenSize.height/768.0f];
            
            [enemySprite1 setScaleX:screenSize.width/1024.0f];
            [enemySprite1 setScaleY:screenSize.height/768.0f];
            
            [enemySprite2 setScaleX:screenSize.width/1024.0f];
            [enemySprite2 setScaleY:screenSize.height/768.0f];
            
            
            [enemySprite3 setScaleX:screenSize.width/1024.0f];
            [enemySprite3 setScaleY:screenSize.height/768.0f];
            
            
            waterSprite = [CCSprite spriteWithFile:@"water-hd.png"];
            [waterSprite setPosition:ccp(screenSize.width/2,waterSprite.contentSize.height/2)];
            [self addChild:waterSprite z:5];
            
            platformSprite1 = [CCSprite spriteWithFile:@"platform_1-hd.png"];
            [platformSprite1 setPosition:ccp(screenSize.width*0.8,screenSize.height*0.7)];
            [self addChild:platformSprite1];
            
            
            platformSprite2 = [CCSprite spriteWithFile:@"platform_2-hd.png"];
            [platformSprite2 setPosition:ccp(screenSize.width*0.3,screenSize.height*0.4)];
            [self addChild:platformSprite2];
        }

        
        int minX = platformSprite1.position.x-platformSprite1.contentSize.width / 2;
        int maxX = platformSprite1.position.x+platformSprite1.contentSize.width / 2;
        int rangeX = minX+(maxX - minX);
        
        [enemySprite1 setPosition:ccp((arc4random() % rangeX), platformSprite1.position.y+platformSprite1.contentSize.height)];
        
        [enemySprite2 setPosition:ccp((arc4random() % rangeX), platformSprite1.position.y+platformSprite1.contentSize.height)];
        
        [enemySprite3 setPosition:ccp((arc4random() % rangeX), platformSprite1.position.y+platformSprite1.contentSize.height)];
        
                // enable touches
      //  self.touchEnabled = YES;
        self.userInteractionEnabled=YES;
        
        
        
      
       // int actualX = ();
        

        
        
        

        
        balloonRedSprite1 = [CCSprite spriteWithFile:@"ballonRed.png"];
        [balloonRedSprite1 setPosition:ccp(enemySprite1.position.x-10,enemySprite1.position.y+20)];
        [self addChild:balloonRedSprite1];
        
        balloonYellowSprite1 = [CCSprite spriteWithFile:@"ballonYellow.png"];
        [balloonYellowSprite1 setPosition:ccp(enemySprite1.position.x+15,enemySprite1.position.y+20)];
        [self addChild:balloonYellowSprite1];
        
        
        
        balloonRedSprite2 = [CCSprite spriteWithFile:@"ballonRed.png"];
        [balloonRedSprite2 setPosition:ccp(enemySprite2.position.x-10,enemySprite2.position.y+20)];
        [self addChild:balloonRedSprite2];
        
        balloonYellowSprite2 = [CCSprite spriteWithFile:@"ballonYellow.png"];
        [balloonYellowSprite2 setPosition:ccp(enemySprite2.position.x+15,enemySprite2.position.y+20)];
        [self addChild:balloonYellowSprite2];
        
        
        balloonRedSprite3 = [CCSprite spriteWithFile:@"ballonRed.png"];
        [balloonRedSprite3 setPosition:ccp(enemySprite3.position.x-10,enemySprite3.position.y+20)];
        
        [self addChild:balloonRedSprite3];
        
        balloonYellowSprite3 = [CCSprite spriteWithFile:@"ballonYellow.png"];
        [balloonYellowSprite3 setPosition:ccp(enemySprite3.position.x+15,enemySprite3.position.y+20)];
        [self addChild:balloonYellowSprite3];
        
        
        
        
        [self initJoystickAndButtons];
        [self scheduleUpdate];
        [self setIsTouchEnabled:YES];
		[self schedule:@selector(fall:)];
        
              
       
      //  [self createPauseButton];
	//	[self createPausedMenu];
        
        [self makeRandomMovement:enemySprite1];
        [self makeRandomMovement:enemySprite2];
        [self makeRandomMovement:enemySprite3];
    }
    return self;
}

/*- (void) addenemyPenguin{
    
    // Determine where to spawn the monster along the platform
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minX = platformSprite1.position.x-platformSprite1.contentSize.width / 2;
    int maxX = platformSprite1.position.x+platformSprite1.contentSize.width / 2;
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX);
    
    //Creates Enemy Penguin Sprite
   CCSprite * penguinSprite = [CCSprite spriteWithFile:@"penguin.png"];
    [self addChild:penguinSprite];
    [penguinSprite setPosition:ccp(actualX, platformSprite1.position.y+platformSprite1.contentSize.height)];
    
  
    
    //Creates Enemy Ballon Sprites
   CCSprite * balloonRedSprite = [CCSprite spriteWithFile:@"ballonYellow.png"];
    [balloonRedSprite setPosition:ccp(penguinSprite.position.x-10,penguinSprite.position.y+20)];
 //   [self addChild:balloonRedSprite];
 CCSprite *  balloonYellowSprite = [CCSprite spriteWithFile:@"ballonRed.png"];
    [balloonYellowSprite setPosition:ccp(penguinSprite.position.x+15,penguinSprite.position.y+20)];
//    [self addChild:balloonYellowSprite];
    [self makeRandomMovement:penguinSprite];
    //[balloonRedSprite setPosition:ccp(penguinSprite.position.x-10,penguinSprite.position.y+20)];
    //[balloonYellowSprite setPosition:ccp(penguinSprite.position.x+15,penguinSprite.position.y+20)];
}*/

- (void) makeRandomMovement: (CCSprite *)sprite {
	//movementsnot resrt ricted
    int rangeY=(screenSize.height-(waterSprite.contentSize.height+30+balloonRedSprite1.contentSize.height+sprite.contentSize.height/2));
    CGPoint randomPoint = ccp(arc4random()%(int)(screenSize.width), arc4random()%(int)(rangeY)+waterSprite.contentSize.height+30);
    NSLog(@"%@", NSStringFromCGPoint(randomPoint));
    
    [[sprite runAction:
     [CCActionSequence actions:
      [CCActionMoveTo actionWithDuration:arc4random()%5+1 position: randomPoint],
      [CCActionCallBlock actionWithBlock:^{
         [self performSelector:@selector(makeRandomMovement:) withObject:sprite afterDelay:0.5];
     }],
      nil]
     ] setTag:1001];
    
   /* id randomMoveAction = [CCActionMoveTo actionWithDuration:5
                                              position:ccp(sprite.contentSize.width/2, arc4random()%300)];
    id moveEndCallback = [CCCallBlock actionWithBlock:^{ [self performSelector:@selector(moveRandomMovement:) withObject:sprite afterDelay:0.5];}];
    id sequence = [CCActionSequence actions:randomMoveAction,moveEndCallback,nil ];
    [sprite runAction: sequence];*/
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(penguindied!=1)
    {
        [self unschedule:@selector(fly:)];
        [self schedule:@selector(fall:)];
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(penguindied!=1)
    {
        [self unschedule:@selector(fall:)];
        [self schedule:@selector(fly:)];
    }
}

-(void) fly:(CCTime)delta
{
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
    
   
    float maxY = screenSize.height - balloonBlueSprite.contentSize.height/2;
   // float minY = -100;
    CCNode * tempNode = penguinSprite;
    
    CGPoint newPosition =
    ccp(tempNode.position.x ,
        tempNode.position.y + delta*60);
    
    if (newPosition.y>maxY) {
        newPosition.y=maxY;
    }
   
  /*  if (newPosition.y<minY) {
        newPosition.y=minY;
    }*/
    
    [tempNode setPosition:newPosition];
    [balloonBlueSprite setPosition:ccp(newPosition.x-10,newPosition.y+20)];
    [balloonGreenSprite setPosition:ccp(newPosition.x+15,newPosition.y+20)];
    
}

-(void) fall:(CCTime)delta
{
    CGSize screenSize = [CCDirector sharedDirector].viewSize;
   
    float maxY = screenSize.height - penguinSprite.contentSize.height;
    float minY = -100;
    CCNode * tempNode = penguinSprite;
    
    CGPoint newPosition =
    ccp(tempNode.position.x ,
        tempNode.position.y - delta*50);
    
    if (newPosition.y>maxY) {
        newPosition.y=maxY;
    }
   /* if (newPosition.y<minY) {
        newPosition.y=minY;
    }*/
    [tempNode setPosition:newPosition];
    [balloonBlueSprite setPosition:ccp(newPosition.x-10,newPosition.y+20)];
    [balloonGreenSprite setPosition:ccp(newPosition.x+15,newPosition.y+20)];
    
}

- (void) die: (CCSprite *)sprite
{
/*[sprite stopActionByTag: 1001];

id penguinmoveAction=[CCActionMoveTo actionWithDuration:3 position:ccp(sprite.position.x,-100)];
  [sprite runAction:[CCActionSequence actions:penguinmoveAction,nil]];   */
    
    [sprite runAction:
      [CCActionSequence actions:
       [CCActionCallBlock actionWithBlock:^{
          [sprite stopActionByTag: 1001];
      }], [CCActionMoveTo actionWithDuration:3 position:ccp(sprite.position.x,-100)],
       nil]];
    
    
   
enemyPenguinCount--;
}


-(void) saveandmovetoNextlevel{
    [self unscheduleUpdate];
    GameData *gameData = [GameDataParser loadData];
    int selectedLevel = gameData.selectedLevel;
     int largeFont = screenSize.height / kFontScaleLarge;
    NSMutableArray *levels = [LevelParser loadLevelsForChapter:1];
    
	for (Level *level in levels) {
        if (level.number == selectedLevel) {
            float sec = ((int)mTimeInSec%60);
            if(sec<=10)
            level.stars=3;
            else if(sec >10 && sec<=20)
                 level.stars=2;
            else
            {level.stars=1;}
          CCLabelTTF  *starsLbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d stars",level.stars]
                                                 fontName:@"Marker Felt"
                                                 fontSize:largeFont];
            starsLbl.position = ccp( screenSize.width*0.5,screenSize.height*0.5);
            [self addChild:starsLbl z:0];
            
            id labelAction = [CCActionSpawn actions:
                              [CCActionScaleBy actionWithDuration:2.0f scale:4],
                              [CCActionFadeOut actionWithDuration:2.0f],
                              nil];
            [starsLbl runAction:labelAction];
            
        }
        if (level.number == (selectedLevel+1)) {
            
            level.unlocked=1;
            
        }
        
    }
	[LevelParser saveData:levels forChapter:1];
    
    
   // GameData *gameData = [GameDataParser loadData];
    gameData.selectedLevel = (selectedLevel+1);
    [GameDataParser saveData:gameData];
    [[OALSimpleAudio sharedInstance]stopBg];
    //go to second level
    //replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene node] ]];

   // [[CCDirector sharedDirector] replaceScene:[GamePlayScene node] withTransition:
     [[CCDirector sharedDirector] replaceScene:[GamePlayScene node]
                                withTransition:
      [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

-(void) update:(CCTime)deltaTime

{
    
    [balloonBlueSprite setPosition:ccp(penguinSprite.position.x-10,penguinSprite.position.y+20)];
    [balloonGreenSprite setPosition:ccp(penguinSprite.position.x+15,penguinSprite.position.y+20)];

if(enemyPenguinCount!=0)
{	
    //set position of ballons with enemy
    
   
   
    [balloonRedSprite1 setPosition:ccp(enemySprite1.position.x-10,enemySprite1.position.y+20)];
    [balloonYellowSprite1 setPosition:ccp(enemySprite1.position.x+15,enemySprite1.position.y+20)];
  
    [balloonRedSprite2 setPosition:ccp(enemySprite2.position.x-10,enemySprite2.position.y+20)];
    [balloonYellowSprite2 setPosition:ccp(enemySprite2.position.x+15,enemySprite2.position.y+20)];
    
    [balloonRedSprite3 setPosition:ccp(enemySprite3.position.x-10,enemySprite3.position.y+20)];
    [balloonYellowSprite3 setPosition:ccp(enemySprite3.position.x+15,enemySprite3.position.y+20)];
   
    
    
    //penguin
	if(penguinLives==0)
	{
        [[OALSimpleAudio sharedInstance]stopBg];
		//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOverScene node] ]];
        [[CCDirector sharedDirector] replaceScene:[GameOverScene node]
                                   withTransition:
         [CCTransition transitionCrossFadeWithDuration:1.0f]];
	}
    
	
   
    
	if (((CGRectIntersectsRect(enemySprite1.boundingBox, balloonBlueSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite1.boundingBox, balloonGreenSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite2.boundingBox, balloonBlueSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite2.boundingBox, balloonGreenSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite3.boundingBox, balloonBlueSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite3.boundingBox, balloonGreenSprite.boundingBox))) && penguindied==0)
		{
					
			
				
				if (((CGRectIntersectsRect(enemySprite1.boundingBox, balloonBlueSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite2.boundingBox, balloonBlueSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite3.boundingBox, balloonBlueSprite.boundingBox))) && redflag==0)
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
                    penguinballoonCount--;
					balloonBlueSprite.visible=NO;
                    redflag=1;
				}
                if(((CGRectIntersectsRect(enemySprite1.boundingBox, balloonGreenSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite2.boundingBox, balloonGreenSprite.boundingBox)) || (CGRectIntersectsRect(enemySprite3.boundingBox, balloonGreenSprite.boundingBox)) ) && yellowflag==0)
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					penguinballoonCount--;
                    balloonGreenSprite.visible=NO;
                    yellowflag=1;
				}
            
            if(penguinballoonCount==0)
            {
                
                penguindied=1;
                
                [self unschedule:@selector(fly:)];
                [self unschedule:@selector(fall:)];
                
                [penguinSprite runAction:
                 [CCActionSequence actions:
                  [CCActionMoveTo actionWithDuration:2 position:ccp(penguinSprite.position.x,-100)],
                  [CCActionFadeOut actionWithDuration:3],
                  [CCActionCallBlock actionWithBlock:^{
                     [penguinSprite setPosition:ccp(screenSize.width/2,screenSize.height*0.5)];
                     balloonBlueSprite.visible=YES;
                     balloonGreenSprite.visible=YES;
                     penguinballoonCount=2;
                     penguindied=0;
                      [self schedule:@selector(fall:)];
                 }],
                  [CCActionFadeIn actionWithDuration:1],
                  nil]];
                
                redflag=0;
                yellowflag=0;
                penguinLives--;
                [penguinlivesLbl setString:[NSString stringWithFormat:@"Lives X  %d",penguinLives]];
                
            }
			
			
		}
    
    
    if(penguinSprite.position.y<waterSprite.position.y+waterSprite.contentSize.height && penguindied!=1)
    {
    
        penguindied=1;
        [[OALSimpleAudio sharedInstance] playEffect:@"splash-01.wav"];
        [penguinSprite runAction:
         [CCActionSequence actions:
          [CCActionMoveTo actionWithDuration:2 position:ccp(penguinSprite.position.x,-100)],
          [CCActionFadeOut actionWithDuration:3],
          [CCActionCallBlock actionWithBlock:^{
             [penguinSprite setPosition:ccp(screenSize.width/2,screenSize.height*0.5)];
             balloonBlueSprite.visible=YES;
             balloonGreenSprite.visible=YES;
             penguinballoonCount=2;
             penguindied=0;
            [self schedule:@selector(fall:)];
             
         }],
          [CCActionFadeIn actionWithDuration:1],
          nil]];
        [self unschedule:@selector(fly:)];
        [self unschedule:@selector(fall:)];
        
        redflag=0;
        yellowflag=0;
        penguinLives--;
        [penguinlivesLbl setString:[NSString stringWithFormat:@"Lives X  %d",penguinLives]];
    
    
    }

 
    
    if ((CGRectIntersectsRect(penguinSprite.boundingBox, platformSprite1.boundingBox) || CGRectIntersectsRect(penguinSprite.boundingBox, platformSprite2.boundingBox)) && penguindied==0) {
        CGPoint currentSpritePosition=[penguinSprite position];
        //[penguinSprite setPosition:penguinSprite.position];
        //[penguinSprite setPosition:ccp([penguinSprite position].x, [penguinSprite position].y)];
        
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite1.position.y+platformSprite1.contentSize.height ) && (currentSpritePosition.y-(platformSprite1.position.y))>0) {
            [penguinSprite setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y+platformSprite1.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite1.position.y-platformSprite1.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite1.position.y)<0)) {
            [penguinSprite setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y-platformSprite1.contentSize.height-15)];
            NSLog(@"down");
        }
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite2.position.y+platformSprite2.contentSize.height )) {
            [penguinSprite setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y+platformSprite2.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite2.position.y-platformSprite2.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite2.position.y)<0)) {
            [penguinSprite setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y-platformSprite2.contentSize.height-15)];
            NSLog(@"down");
        }
        
    }
	
//----------------------------------------
	
    if(enemy1died==0){
        //enemy1
		if (((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite1.boundingBox)) || (CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite1.boundingBox))) )
		{
			if(enemy1balloonCount==0)
			{
                [enemySprite1 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                enemy1died=1;
                [self die:enemySprite1];
                if ((enemySprite1.position.y) == 0)
                {
                    [[OALSimpleAudio sharedInstance] playEffect:@"splash-01.wav"];
                }
		
			}
			else
			{
				
				if ((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite1.boundingBox)) && redflag1==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonRedSprite1.visible=NO;
                    redflag1=1;
                    enemy1balloonCount--;
				}
				if((CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite1.boundingBox)) && yellowflag1==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonYellowSprite1.visible=NO;
                    yellowflag1=1;
                    enemy1balloonCount--;
				}
                
                if(enemy1balloonCount==0)
                {
                    [enemySprite1 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                    enemy1died=1;
                    [self die:enemySprite1];
                    
                }

			
			}
		}
        
	}
    
    else if(enemySprite1.position.y<-10){
        [enemySprite1 stopAllActions];
    }
    
    
    
    if ((CGRectIntersectsRect(enemySprite1.boundingBox, platformSprite1.boundingBox) || CGRectIntersectsRect(enemySprite1.boundingBox, platformSprite2.boundingBox)) && enemy1balloonCount!=0) {
            CGPoint currentSpritePosition=[enemySprite1 position];
            //[penguinSprite setPosition:penguinSprite.position];
            //[penguinSprite setPosition:ccp([penguinSprite position].x, [penguinSprite position].y)];
            
            if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite1.position.y+platformSprite1.contentSize.height ) && (currentSpritePosition.y-(platformSprite1.position.y))>0) {
                [enemySprite1 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y+platformSprite1.contentSize.height+3)];
                NSLog(@"coefefewfswfsfdsfasFwefn");
            }
            if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite1.position.y-platformSprite1.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite1.position.y)<0)) {
                [enemySprite1 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y-platformSprite1.contentSize.height-15)];
                NSLog(@"down");
            }
            if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite2.position.y+platformSprite2.contentSize.height )) {
                [enemySprite1 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y+platformSprite2.contentSize.height+3)];
                NSLog(@"coefefewfswfsfdsfasFwefn");
            }
            
            if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite2.position.y-platformSprite2.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite2.position.y)<0)) {
                [enemySprite1 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y-platformSprite2.contentSize.height-15)];
                NSLog(@"down");
            }
                
        
    }
 //----------------------------------------------------
    
    if(enemy2died==0){
        //enemy2
		if (((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite2.boundingBox)) || (CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite2.boundingBox))) )
		{
			if(enemy2balloonCount==0)
			{
                [enemySprite2 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                enemy2died=1;
                [self die:enemySprite2];
                if ((enemySprite2.position.y) == 0)
                {
                    [[OALSimpleAudio sharedInstance] playEffect:@"splash-01.wav"];
                }
                
			}
			else
			{
				
				if ((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite2.boundingBox)) && redflag2==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonRedSprite2.visible=NO;
                    redflag2=1;
                    enemy2balloonCount--;
				}
				if((CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite2.boundingBox)) && yellowflag2==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonYellowSprite2.visible=NO;
                    yellowflag2=1;
                    enemy2balloonCount--;
				}
                
                if(enemy2balloonCount==0)
                {
                    [enemySprite2 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                    enemy2died=1;
                    [self die:enemySprite2];
                   
                }
                
			}
		}
        
	}
    else if(enemySprite2.position.y<-10){
        [enemySprite2 stopAllActions];
    }
    
    
    
    if ((CGRectIntersectsRect(enemySprite2.boundingBox, platformSprite1.boundingBox) || CGRectIntersectsRect(enemySprite2.boundingBox, platformSprite2.boundingBox)) && enemy2balloonCount!=0) {
        CGPoint currentSpritePosition=[enemySprite2 position];
        //[penguinSprite setPosition:penguinSprite.position];
        //[penguinSprite setPosition:ccp([penguinSprite position].x, [penguinSprite position].y)];
        
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite1.position.y+platformSprite1.contentSize.height ) && (currentSpritePosition.y-(platformSprite1.position.y))>0) {
            [enemySprite2 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y+platformSprite1.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite1.position.y-platformSprite1.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite1.position.y)<0)) {
            [enemySprite2 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y-platformSprite1.contentSize.height-15)];
            NSLog(@"down");
        }
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite2.position.y+platformSprite2.contentSize.height )) {
            [enemySprite2 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y+platformSprite2.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite2.position.y-platformSprite2.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite2.position.y)<0)) {
            [enemySprite2 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y-platformSprite2.contentSize.height-15)];
            NSLog(@"down");
        }
        
        
    }

  //----------------------------------------------------
    
    if(enemy3died==0){
        //enemy3
		if (((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite3.boundingBox)) || (CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite3.boundingBox))) )
		{
			if(enemy3balloonCount==0)
			{
                [enemySprite3 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                enemy3died=1;
                [self die:enemySprite3];
                
                
			}
			else
			{
				
				if ((CGRectIntersectsRect(penguinSprite.boundingBox, balloonRedSprite3.boundingBox)) && redflag3==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonRedSprite3.visible=NO;
                    redflag3=1;
                    enemy3balloonCount--;
				}
				if((CGRectIntersectsRect(penguinSprite.boundingBox, balloonYellowSprite3.boundingBox)) && yellowflag3==0 )
				{
                    [[OALSimpleAudio sharedInstance] playEffect:@"blip.wav"];
					balloonYellowSprite3.visible=NO;
                    yellowflag3=1;
                    enemy3balloonCount--;
				}
                
                
                if(enemy3balloonCount==0)
                {
                    [enemySprite3 runAction:[CCActionBlink actionWithDuration:1.0 blinks:9]];
                    enemy3died=1;
                    [self die:enemySprite3];                 
                    
                }

                
			}
		}
        
	}
    else if(enemySprite3.position.y<-10){
        
        [enemySprite3 stopAllActions];
    }
    
    
    
    if ((CGRectIntersectsRect(enemySprite3.boundingBox, platformSprite1.boundingBox) || CGRectIntersectsRect(enemySprite3.boundingBox, platformSprite2.boundingBox)) && enemy3balloonCount!=0) {
        CGPoint currentSpritePosition=[enemySprite3 position];
        //[penguinSprite setPosition:penguinSprite.position];
        //[penguinSprite setPosition:ccp([penguinSprite position].x, [penguinSprite position].y)];
        
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite1.position.y+platformSprite1.contentSize.height ) && (currentSpritePosition.y-(platformSprite1.position.y))>0) {
            [enemySprite3 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y+platformSprite1.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite1.position.y-platformSprite1.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite1.position.y)<0)) {
            [enemySprite3 setPosition:ccp(currentSpritePosition.x,platformSprite1.position.y-platformSprite1.contentSize.height-15)];
            NSLog(@"down");
        }
        if ((currentSpritePosition.y-penguinSprite.contentSize.height <= platformSprite2.position.y+platformSprite2.contentSize.height )) {
            [enemySprite3 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y+platformSprite2.contentSize.height+3)];
            NSLog(@"coefefewfswfsfdsfasFwefn");
        }
        
        if((currentSpritePosition.y+penguinSprite.contentSize.height >= platformSprite2.position.y-platformSprite2.contentSize.height/2 )&& (currentSpritePosition.y-(platformSprite2.position.y)<0)) {
            [enemySprite3 setPosition:ccp(currentSpritePosition.x,platformSprite2.position.y-platformSprite2.contentSize.height-15)];
            NSLog(@"down");
        }
        
        
    }

    
   //--------------------------------------------------
    
    if(penguindied!=1)
    [self applyJoystick:leftJoystick toNode:penguinSprite forTimeDelta:deltaTime];
    
    
}
else
{
    
    [self saveandmovetoNextlevel];
}    
    
}


@end
