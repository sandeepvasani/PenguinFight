//
//  PauseLayer.m
//  
//

#import "PauseLayer.h"

@implementation PauseLayer

-(id)init
{
    //(150, 150, 150, 100) creates a greyish hue.Change these values as requirement.
    if ((self=[super initWithColor:[CCColor grayColor]]))
    {
        //Not adding touch delegate here
        // Touch will be added only when this layer gets added as child.. i.e. in onEnter
        // and removed in onExit
        [self setMultipleTouchEnabled:YES];
        
    }
    return self;
}


/*-(void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-3 swallowsTouches:YES];
    
    NSLog(@"Entering pause layer");
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    NSLog(@"exiting pause layer!!");
    [super onExit];
}
*/

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //We are swallowing all the touches here, so that they dont reach any other element in the game.
   // return YES;
}

@end
