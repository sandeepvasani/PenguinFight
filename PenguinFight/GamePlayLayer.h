//
//  GameplayLayer.h
//  SnakeGame
//
//  Created by macuser2 on 2/10/14.
//  Copyright Sandeep 2014. All rights reserved.

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"

#import "PauseButton.h"
#import "PauseLayer.h"
//#import "SceneManager.h"
//#import "TRBox2D.h"

@interface GamePlayLayer : CCNode {
    
    CCSprite *penguinSprite;
    CCSprite *enemySprite1;
    CCSprite *enemySprite2;
    CCSprite *enemySprite3;
	
	int penguinballoonCount;
	int enemy1balloonCount;
	int enemy2balloonCount;
	int enemy3balloonCount;
	
	int enemyPenguinCount;
	int penguinLives;
    
    int redflag;
    int yellowflag;
    
    int  redflag1;
    int yellowflag1;
    
    int redflag2;
    int yellowflag2;
    
    int redflag3;
    int yellowflag3;
    
     int penguindied;
   int enemy1died;
    int enemy2died;
    int enemy3died;


    
    CCSprite *platformSprite1;
    CCSprite *platformSprite2;
    CCSprite *waterSprite;
    
    CCSprite *balloonBlueSprite;
    CCSprite *balloonGreenSprite;
   
    CCSprite *balloonRedSprite1;
    CCSprite *balloonYellowSprite1;
    
    CCSprite *balloonRedSprite2;
    CCSprite *balloonYellowSprite2;
    
    CCSprite *balloonRedSprite3;
    CCSprite *balloonYellowSprite3;
    
    SneakyJoystick *leftJoystick;
    CCSprite *pauseBtn;
    CCSprite *pausedSprite;
    CCLayout *pausedMenu;
    BOOL paused;
    CGSize screenSize;
//    GLESDebugDraw *debugDraw;
    CCLabelTTF *penguinlivesLbl;
	CCLabelTTF    *mTimeLbl;
	float   mTimeInSec;
    PauseButton*  pauseBtnClassObj;
}

-(void)playBackgroundMusic;
-(void)myAppResignActive;

@property (nonatomic, assign) BOOL iPad;
@property (nonatomic, assign) NSString *device;
@property (nonatomic, assign) BOOL mute;
@end