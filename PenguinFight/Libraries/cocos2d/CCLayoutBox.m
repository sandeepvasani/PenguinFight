/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2013 Apportable Inc.
 * Copyright (c) 2013-2014 Cocos2D Authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCLayoutBox.h"
#import "ccMacros.h"
#import "CGPointExtension.h"
#import "CCNode_Private.h"

@implementation CCLayoutBox

static float roundUpToEven(float f)
{
    return ceilf(f/2.0f) * 2.0f;
}

- (void) layout
{
    [super layout];
    if (_direction == CCLayoutBoxDirectionHorizontal)
    {
        // Get the maximum height
        float maxHeight = 0;
        for (CCNode* child in self.children)
        {
            float height = child.contentSizeInPoints.height;
            if (height > maxHeight) maxHeight = height;
        }
        
        // Position the nodes
        float width = 0;
        for (CCNode* child in self.children)
        {
            CGSize childSize = child.contentSizeInPoints;
            
            CGPoint offset = child.anchorPointInPoints;
            CGPoint localPos = ccp(roundf(width), roundf((maxHeight-childSize.height)/2.0f));
            CGPoint position = ccpAdd(localPos, offset);
            
            child.position = position;
            child.positionType = CCPositionTypePoints;
            
            width += childSize.width;
            width += _spacing;
        }
        
        // Account for last added increment
        width -= _spacing;
        if (width < 0) width = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(width), roundUpToEven(maxHeight));
    }
    else if(_direction == CCLayoutBoxDirectionVertical)
    {
        // Get the maximum width
        float maxWidth = 0;
        for (CCNode* child in self.children)
        {
            float width = child.contentSizeInPoints.width;
            if (width > maxWidth) maxWidth = width;
        }
        
        // Position the nodes
        float height = 0;
        for (CCNode* child in self.children)
        {
            CGSize childSize = child.contentSizeInPoints;
            
            CGPoint offset = child.anchorPointInPoints;
            CGPoint localPos = ccp(roundf((maxWidth-childSize.width)/2.0f), roundf(height));
            CGPoint position = ccpAdd(localPos, offset);
            
            child.position = position;
            child.positionType = CCPositionTypePoints;
            
            height += childSize.height;
            height += _spacing;
        }
        
        // Account for last added increment
        height -= _spacing;
        if (height < 0) height = 0;
        
        self.contentSizeType = CCSizeTypePoints;
        self.contentSize = CGSizeMake(roundUpToEven(maxWidth), roundUpToEven(height));
    }
    else if(_direction == CCLayoutBoxDirectionGrid) // We need a Grid Like Structure
    {
        if (self.children.count != _rowsInGrid * _columnsInGrid) {
            CCLOG(@"CCLayoutBox ERROR: Total No. of children is not equal to grid size");
        }
        else   // Positioning the nodes
        {
            // Get the maximum width and height
            float maxWidth = 0;
            float maxHeight = 0;
            for (CCNode* child in self.children)
            {
                float width = child.contentSizeInPoints.width;
                float height = child.contentSizeInPoints.height;
                if (width > maxWidth) maxWidth = width;
                if (height > maxHeight) maxHeight = height;
            }
            float height = 0;
            for (NSInteger rowCount = 0; rowCount < _rowsInGrid; rowCount++) {
                float width = 0;
                // Rowwise distribution
                for (NSInteger columnCount = 0; columnCount < _columnsInGrid; columnCount++) {
                    
                    CCNode *child = [self.children objectAtIndex:(rowCount * _columnsInGrid + columnCount)];
                    CGSize childSize = child.contentSizeInPoints;
                    CGPoint offset = child.anchorPointInPoints;
                    CGPoint localPos = ccp(roundf(width), roundf(((maxHeight-childSize.height)/2.0f)-height) );
                    CGPoint position = ccpAdd(localPos, offset);
                    
                    child.position = position;
                    child.positionType = CCPositionTypePoints;
                    
                    // Increasing the width after traversing each child
                    width += childSize.width;
                    width += _spacing;
                }
                
                height += maxHeight/2;
                height += _spacing*2;
            }
        }
        
    }
    
}

- (void) setSpacing:(float)spacing
{
    _spacing = spacing;
    [self needsLayout];
}

-(void) detachChild:(CCNode *)child cleanup:(BOOL)doCleanup
{
    [super detachChild:child cleanup:doCleanup];
    [self needsLayout];
}

-(void)setDirection:(CCLayoutBoxDirection)direction
{
    _direction = direction;
    [self needsLayout];
}

@end
