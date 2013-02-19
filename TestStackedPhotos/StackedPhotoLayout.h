//
//  StackedPhotoLayout.h
//  
//
//  Created by Neil lv on 13-2-17.
//
//

#import <UIKit/UIKit.h>

@interface StackedPhotoLayout : UICollectionViewFlowLayout

// The point to which the stack collapses
@property (nonatomic) CGPoint stackCenter;

// 0.0 means completely stacked, 1.0 results in the default FlowLayout
// Values bigger than 1.0 will spread the layout even more
@property (nonatomic) CGFloat stackFactor;

@end
