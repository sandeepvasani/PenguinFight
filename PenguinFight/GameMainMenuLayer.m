//
//  MainMenu.m
//  

#import "GameMainMenuLayer.h"
//#import "GameChapterSelectScene.h"
#import "GameOptionsScene.h"  
#import "GameData.h"
#import "GameDataParser.h"
#import "GameLevelSelectScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"

@implementation GameMainMenuLayer
@synthesize iPad, device;

- (void)onPlay: (id) sender {
    //[SceneManager goChapterSelect];
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLevelSelectScene node] ]];
    
    [[CCDirector sharedDirector] replaceScene:[GameLevelSelectScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

- (void)onOptions: (id) sender {
    //[SceneManager goOptionsMenu];
   [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOptionsScene node] ]];
    [[CCDirector sharedDirector] replaceScene:[GameOptionsScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

- (void)addBackButton {
     [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
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
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge; 
        NSLog(@"%d",largeFont);
        // Set font settings
        //[CCButton setFontName:@"Marker Felt"];
       // [CCMenuItemFont setFontSize:largeFont];
        
        
        
     //   CCSprite * play_button_normal = [CCSprite spriteWithImageNamed:@"play.png"];
     // CCSprite * play_button_selected = [CCSprite spriteWithImageNamed:@"play_selected.png"];
        
        // Create font based items ready for CCMenu
      //  CCMenuItemSprite *item1 = [CCMenuItemSprite itemWithNormalSprite:play_button_normal  selectedSprite:play_button_selected disabledSprite:nil target:self selector:@selector(onPlay:)];
        
        CCButton *item1 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"play.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"play_selected.png"] disabledSpriteFrame:nil];
        
        [item1 setTarget:self selector:@selector(onPlay:)];
       // CCLabelTTF *play = [CCLabelTTF labelWithString:@"Play" fontName:@"Marker Felt" fontSize:largeFont];
        //CCMenuItemFont *item1_top = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(onPlay:)];
    //    CCMenuItemImage *item2 = [CCMenuItemImage itemWithNormalImage:@"option.png" selectedImage:@"option_selected.png" target:self selector:@selector(onOptions:)];
        
        CCButton *item2 = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"option.png"] highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"option_selected.png"]
                           
                                disabledSpriteFrame:nil];
         [item2 setTarget:self selector:@selector(onOptions:)];
        
       // CCMenuItemFont *item2_top = [CCMenuItemFont itemWithString:@"Options" target:self selector:@selector(onOptions:)];
        
        // Add font based items to CCMenu
      //  CCMenu *menu = [CCMenu menuWithItems:item1,item2, nil];
        
        CCLayoutBox *menu = [[CCLayoutBox alloc] init];
        
       
        [menu addChild:item2];
         [menu addChild:item1];
       
     //   NSLog(@"%f",item1.position);
        // Align the menu
        menu.direction=CCLayoutBoxDirectionVertical;
        menu.anchorPoint=ccp(0.5f,0.5f);
        menu.position = ccp(screenSize.width/2,screenSize.height/2);
        menu.spacing=10.0;
        //play.position = item1.position;
        // Add the menu to the scene
        
        [self addChild:menu];
       // [self addChild:play];
       // [self addBackButton];
        // Testing GameData
        /*
        GameData *gameData = [GameDataParser loadData];

        CCLOG(@"Read from XML 'Selected Chapter' = %i", gameData.selectedChapter);
        CCLOG(@"Read from XML 'Selected Level' = %i", gameData.selectedLevel);
        CCLOG(@"Read from XML 'Music' = %i", gameData.music);
        CCLOG(@"Read from XML 'Sound' = %i", gameData.sound);
        
        gameData.selectedChapter = 7;
        gameData.selectedLevel = 4;
        gameData.music = 0;
        gameData.sound = 0;
        
        [GameDataParser saveData:gameData];
        */
    }
    return self;
}

@end
