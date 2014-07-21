//
//  GameScene.m
//  

#import "GameplayScene.h"
#import "GameLevelSelectScene.h"
#import "GameData.h"
#import "GameDataParser.h"
#import "LevelParser.h"
#import "Level.h"
#import "GameBackgroundLayer.h"
#import "GamePlayLayer.h"


@implementation GamePlayScene
@synthesize iPad, device;
//@synthesize TAG_MY_GAME;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
   // [SceneManager goLevelSelect];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLevelSelectScene node] ]];
    [[CCDirector sharedDirector] replaceScene:[GameLevelSelectScene node]
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

        // Determine Device
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].viewSize;
        
        // Add background to this scene
        GameBackgroundLayer *gameBackgroundLayer = [GameBackgroundLayer node];
        [self addChild:gameBackgroundLayer z:-10];
        
        // Add the gameplay layer to this scene
        GamePlayLayer *gamePlayLayer = [GamePlayLayer node];
        
        [self addChild:gamePlayLayer z:-9];
        
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 
        
        GameData *gameData = [GameDataParser loadData];
        
      //  int selectedChapter = gameData.selectedChapter;
        int selectedLevel = gameData.selectedLevel;
        
        NSMutableArray *levels = [LevelParser loadLevelsForChapter:1];
        
        for (Level *level in levels) {
            if (level.number == selectedLevel) {
                
                NSString *data = [NSString stringWithFormat:@"%@",level.data];
                
                CCLabelTTF *label = [CCLabelTTF labelWithString:data
                                                       fontName:@"Marker Felt" 
                                                       fontSize:largeFont]; 
                label.position = ccp( screenSize.width/2, screenSize.height/2);  
                
                // Add label to this scene
                [self addChild:label z:0]; 
				
				id labelAction = [CCActionSpawn actions:
                          [CCActionScaleBy actionWithDuration:2.0f scale:4],
                          [CCActionFadeOut actionWithDuration:2.0f],
                          nil];
				[label runAction:labelAction];
            }
        }

     /*   //  Put a 'back' button in the scene
        [self addBackButton];   */

    }
    return self;
}

@end
