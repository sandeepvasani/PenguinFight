//
//  PauseButton.h
//  
//

#import "CCNode.h"
#import "PauseLayer.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"


@interface PauseButton : CCNode
{
    BOOL mePaused;  // boolean to keep track of paused state of game
    PauseLayer *pausedLayer;
 //   CCSprite* resumeSlider;
	CCSprite *pauseBtn;
    CCSprite *pausedSprite;
    CCLayoutBox *pausedMenu;
    BOOL paused;
    CCButton* pauseBtn1;
    
    
}

-(void)pauseButtonTouched:(id)sender;

@end

@interface CCNode (IABPauseButton)
-(void) setPosRelativeToParentPos:(CGPoint)pos;
@end
