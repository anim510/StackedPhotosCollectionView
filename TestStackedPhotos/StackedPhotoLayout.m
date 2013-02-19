//
//  StackedPhotoLayout.m
//  
//
//  Created by Neil lv on 13-2-17.
//
//

#import "StackedPhotoLayout.h"

@implementation StackedPhotoLayout

- (id)init {
    
    if (self = [super init]) {
        
        self.stackFactor = 1.0f;
    }
    
    return self;
}

// Custom setter for redrawing the layout
- (void)setStackFactor:(CGFloat)stackFactor {
    
    _stackFactor = stackFactor;
    [self invalidateLayout];
}

- (void)setStackCenter:(CGPoint)stackCenter {
    
    _stackCenter = stackCenter;
    [self invalidateLayout];
}


#pragma mark - Override

// Subclasses must override this method and use it to return the width and height of the collection view’s content. These values represent the width and height of all the content, not just the content that is currently visible. The collection view uses this information to configure its own content size to facilitate scrolling.
- (CGSize)collectionViewContentSize {
    
    CGSize contentSize = [super collectionViewContentSize];
    
    if (self.collectionView.bounds.size.width > contentSize.width)
        contentSize.width = self.collectionView.bounds.size.width;
    
    if (self.collectionView.bounds.size.height > contentSize.height)
        contentSize.height = self.collectionView.bounds.size.height;
    
    return contentSize;
}

// return an array layout attributes instances for all the views in the given rect
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    // Calculate the new position of each cell based on stackFactor and stackCenter
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        
        CGFloat xPosition = self.stackCenter.x + (attributes.center.x - self.stackCenter.x) * self.stackFactor;
        CGFloat yPosition = self.stackCenter.y + (attributes.center.y - self.stackCenter.y) * self.stackFactor;
        
        attributes.center = CGPointMake(xPosition, yPosition);
        
        if (attributes.indexPath.row == 0) {
            attributes.alpha = 1.0;
            attributes.zIndex = 1.0; // Put the first cell on top of the stack
            
        } else {
            attributes.alpha = self.stackFactor; // fade the other cells out
            attributes.zIndex = 0.0; //Other cells below the first one
        }
    }
    
    return attributesArray;
}


@end
