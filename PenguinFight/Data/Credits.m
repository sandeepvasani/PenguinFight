//
//  Credits.m
//  Penguin Fight
//
//  Created by Tomy Le on 4/25/14.
//  Copyright (c) 2014 sandeep vasani CSCI 5931.01. All rights reserved.
//

#import "Credits.h"
#import "GameOptionsScene.h"
#import "OALSimpleAudio.h"
//#import "CDAudioManager.h"
//#import "CocosDenshion.h"
@implementation Credits
@synthesize iPad, device;
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	Credits *creditsLayer = [Credits node];
	[scene addChild: creditsLayer];
	return scene;
}

- (void)onBack: (id) sender {
    [[OALSimpleAudio sharedInstance] playEffect:@"beep-02.wav"];
   // [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOptionsScene node] ]];
    
    [[CCDirector sharedDirector] replaceScene:[GameOptionsScene node]
withTransition:
    [CCTransition transitionCrossFadeWithDuration:1.0f]];
    
    
}

- (void)addBackButton {
    
    NSString *normal = [NSString stringWithFormat:@"Arrow-Normal-%@.png", self.device];
    NSString *selected = [NSString stringWithFormat:@"Arrow-Selected-%@.png", self.device];
   // CCMenuItemImage *goBack = [CCMenuItemImage itemFromNormalImage:normal
                                                    /// selectedImage:selected
                                                          //  target:self
                                                         // selector:@selector(onBack:)];
    CCButton *goBack = [CCButton buttonWithTitle:@""
                                     spriteFrame:[CCSpriteFrame frameWithImageNamed:normal]
                          highlightedSpriteFrame:[CCSpriteFrame frameWithImageNamed:selected]
                             disabledSpriteFrame:nil];
    [goBack setTarget:self selector:@selector(onBack:)];
    
    
 //   CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
    if (self.iPad) {
        goBack.position = ccp(64, 64);
        
    }
    else {
        goBack.position = ccp(32, 32);
    }
    
    [self addChild:goBack];
}


-(id) init
{
	if( (self=[super init])) {
        self.iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        if (self.iPad) {
            self.device = @"iPad";
        }
        else {
            self.device = @"iPhone";
        }
		CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"Credits:" fontName:@"Arial" fontSize:48];
		CGSize size = [[CCDirector sharedDirector] viewSize];
		creditsLabel.position =  ccp( size.width /2 , size.height*0.82 );
        
        CCLabelTTF *crediteesLabel = [CCLabelTTF labelWithString:@"Tomy Le\nSandeep Vasani" fontName:@"Arial" fontSize:28];
		crediteesLabel.position =  ccp( size.width /2 , size.height*0.55 );

        [self addChild: creditsLabel];
        [self addChild:crediteesLabel];
        [self addBackButton];
	}
	return self;
}




@end
