// 
//
//  Created by macuser2 on 2/10/14.
//  Copyright Sandeep 2014. All rights reserved.

// Import the interfaces
#import "GameOverLayer.h"
#import "GameLevelSelectScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

@implementation GameOverLayer

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
        
		CCLabelTTF *label =[CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:65];
		CGSize size=[[CCDirector sharedDirector]viewSize];

		label.position=ccp(size.width/2,size.height/2);
		[self addChild: label ];
		[self addBackButton];
	}
	return self;

}


- (void)onBack: (id) sender {
    /* 
     This is where you choose where clicking 'back' sends you.
     */
   // [SceneManager goChapterSelect];
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
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

@end