//
// 
//  
#import "GamePlayLayer.h"
#import "GameOptionsLayer.h"
#import "GameMainMenuScene.h"
#import "Credits.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
@implementation GameOptionsLayer
@synthesize iPad, device;

- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
   // [SceneManager goMainMenu];
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
  // [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameMainMenuScene node] ]];
    
    [[CCDirector sharedDirector] replaceScene:[GameMainMenuScene node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
}

- (void)onMuteMusic: (id) sender {
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
    
    GamePlayLayer *gpl = [[GamePlayLayer alloc]init];
    [gpl playBackgroundMusic];
}

- (void)addBackButton {
    
    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];        
    //CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal
                                                    // selectedImage:selected
                                                       //     target:self
                                                       //   selector:@selector(onBack:)];
    
    CCButton *goBack = [CCButton buttonWithTitle:@""
                        
                                     spriteFrame:[CCSpriteFrame frameWithImageNamed:normal]
                        
                          highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:selected]
                        
                             disabledSpriteFrame:nil];
    
    [goBack setTarget:self selector:@selector(onBack:)];
  //  CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
    if (self.iPad) {
        goBack.position = ccp(64, 64);
        
    }
    else {
        goBack.position = ccp(32, 32);
    }
    
    [self addChild:goBack];
}

- (void)onCredits: (id) sender {
   [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Credits node] ]];
    
    [[CCDirector sharedDirector] replaceScene:[Credits node]
                               withTransition:
     [CCTransition transitionCrossFadeWithDuration:1.0f]];
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
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Options Menu"
                                               fontName:@"Marker Felt" 
                                               fontSize:largeFont];  
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height*0.8);
        
        // Add label to this scene
		[self addChild:label z:0]; 

        //  Put a 'back' button in the scene
        [self addBackButton];   
        
        //CCMenuItemImage *playStyle = [CCMenuItemImage itemWithNormalImage:@"playStyle.png" selectedImage:@"playStyle.png" target:self selector:@selector(onMuteMusic:)];
     ///   CCMenuItemImage *credits = [CCMenuItemImage itemWithNormalImage:@"credits.png" selectedImage:@"credits.png" target:self selector:@selector(onCredits:)];
        CCButton *credits = [CCButton buttonWithTitle:@""
                            
                                         spriteFrame:[CCSpriteFrame frameWithImageNamed:@"credits.png"]
                            
                              highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"credits.png"]
                            
                                 disabledSpriteFrame:nil];
        
        [credits setTarget:self selector:@selector(onCredits:)];
        
        //CCMenu *menu = [CCMenu menuWithItems:credits, playStyle, nil];
        //CCMenu *menu = [CCMenu menuWithItems:credits, nil];
       // [menu alignItemsVertically];
        credits.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:credits];
        
        
    }
    return self;
}

@end
