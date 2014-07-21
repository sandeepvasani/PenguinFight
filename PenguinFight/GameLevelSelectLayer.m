//
//  LevelSelect.m
//  
#import "GameLevelSelectLayer.h"
#import"GamePlayScene.h"
//#import"GameChapterSelectScene.h"
#import "Level.h"
#import "LevelParser.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "Chapter.h"
#import "ChapterParser.h"
#import "GameMainMenuScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
@implementation GameLevelSelectLayer  
@synthesize iPad, device;

- (void) onPlay: (CCButton*) sender {

 // the selected level is determined by the tag in the menu item
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
    int selectedLevel = [sender.name intValue];
    
 // store the selected level in GameData
    GameData *gameData = [GameDataParser loadData];
    gameData.selectedLevel = selectedLevel;
    [GameDataParser saveData:gameData];
    
 // load the game scene
  //  [SceneManager goGameScene];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GamePlayScene node] ]];
    [[CCDirector sharedDirector] replaceScene:[GamePlayScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
   // [SceneManager goChapterSelect];
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameMainMenuScene node] ]];
    
    [[CCDirector sharedDirector] replaceScene:[GameMainMenuScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

- (void)addBackButton {

    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];        
  //  CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal
                                                   //  selectedImage:selected
                                                         //   target:self
                                                        //  selector:@selector(onBack:)];
    
    
    CCButton *goBack = [CCButton buttonWithTitle:@""
                                     spriteFrame:[CCSpriteFrame frameWithImageNamed:normal]
                          highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:selected]
                             disabledSpriteFrame:nil];
    [goBack setTarget:self selector:@selector(onBack:)];
    
  //  CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
   // CCLayoutBox *layoutBox = [[CCLayoutBox alloc] init];
    
     
    if (self.iPad) {
        goBack.position = ccp(64, 64);
    
    }
    else {
        goBack.position = ccp(32, 32);
    }
    
    [self addChild:goBack];
}

- (id)init {
    
    if( (self=[super init])) {
        
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }

        int smallFont = [CCDirector sharedDirector].viewSize.height / kFontScaleSmall;
        
        CGSize screenSize = [CCDirector sharedDirector].viewSize;
        
    
        
        
     // Read in selected chapter levels
       // CCMenu *levelMenu = [CCMenu menuWithItems: nil];
        CCLayoutBox *levelMenu = [[CCLayoutBox alloc] init];
        levelMenu.position=ccp(screenSize.width/2,screenSize.height/2);
        NSMutableArray *overlay = [NSMutableArray new];
        
        NSMutableArray *selectedLevels = [LevelParser loadLevelsForChapter:1];
    
        
     // Create a button for every level
        for (Level *level in selectedLevels) {
            
            NSString *normal =   [NSString stringWithFormat:@"Normal-%@.png", self.device];
            NSString *selected = [NSString stringWithFormat:@"Selected-%@.png",self.device];

           // CCMenuItemImage *item = [CCMenuItemImage itemFromNormalImage:normal
                                                          // selectedImage:selected
                                                              //    target:self
                                                             //   selector:@selector(onPlay:)];
            
            CCButton *item = [CCButton buttonWithTitle:@""
                                             spriteFrame:[CCSpriteFrame frameWithImageNamed:normal]
                                  highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:selected]
                                     disabledSpriteFrame:nil];
            [item setTarget:self selector:@selector(onPlay:)];

            
            
           // [item setTag:level.number]; // note the number in a tag for later usage
            item.name=[NSString stringWithFormat:@"%d",level.number];
        //    [item setIsEnabled:level.unlocked];  // ensure locked levels are inaccessible
            
            item.enabled=level.unlocked;
          //  item.position=ccp(screenSize.width/2,screenSize.height/2);
            [levelMenu addChild:item];
            
            if (!level.unlocked) {
                
                NSString *overlayImage = [NSString stringWithFormat:@"Locked-%@.png", self.device];
                CCSprite *overlaySprite = [CCSprite spriteWithImageNamed:overlayImage];
             //   [overlaySprite setTag:level.number];
                overlaySprite.name=[NSString stringWithFormat:@"%d",level.number];
                [overlay addObject:overlaySprite];
            }
            else {
                
                NSString *stars = [[NSNumber numberWithInt:level.stars] stringValue];
                NSString *overlayImage = [NSString stringWithFormat:@"%@Star-Normal-%@.png",stars, self.device];
                CCSprite *overlaySprite = [CCSprite spriteWithImageNamed:overlayImage];
              //  [overlaySprite setTag:level.number];
                 overlaySprite.name=[NSString stringWithFormat:@"%d",level.number];
                [overlay addObject:overlaySprite];
            }

        }

      //  [levelMenu alignItemsInColumns:
      //    [NSNumber numberWithInt:6],
        //  [NSNumber numberWithInt:6],
      //    [NSNumber numberWithInt:6],
      //    nil];
        
        levelMenu.direction=CCLayoutBoxDirectionHorizontal;
        
        
     // Move the whole menu up by a small percentage so it doesn't overlap the back button
        CGPoint newPosition = levelMenu.position;
        newPosition.y = newPosition.y + (newPosition.y / 10);
        [levelMenu setPosition:newPosition];
        
        [self addChild:levelMenu z:-3];


     // Create layers for star/padlock overlays & level number labels
        CCNode *overlays = [[CCNode alloc] init];
        CCNode *labels = [[CCNode alloc] init];

        
        for (CCButton *item in levelMenu.children) {

         // create a label for every level
            
            CCLabelTTF *label = [CCLabelTTF labelWithString:item.name
                                                        fontName:@"Marker Felt" 
                                                        fontSize:smallFont];
            
            [label setAnchorPoint:item.anchorPoint];
            [label setPosition:item.position];
            [labels addChild:label];
            
            
         // set position of overlay sprites
         
            for (CCSprite *overlaySprite in overlay) {
                if ([overlaySprite.name isEqualToString:item.name]) {
                    [overlaySprite setAnchorPoint:item.anchorPoint];
                    [overlaySprite setPosition:item.position];
                    [overlays addChild:overlaySprite];
                }
            }
        }
        
     // Put the overlays and labels layers on the screen at the same position as the levelMenu
        
        [overlays setAnchorPoint:levelMenu.anchorPoint];
        [labels setAnchorPoint:levelMenu.anchorPoint];
        [overlays setPosition:levelMenu.position];
        [labels setPosition:levelMenu.position];
        [self addChild:overlays];
        [self addChild:labels];
        [overlays release];
        [labels release];
        [overlay release]; // FIX MEMORY LEAK
        
     // Add back button
        
        [self addBackButton]; 
    }
    return self;
}

@end
