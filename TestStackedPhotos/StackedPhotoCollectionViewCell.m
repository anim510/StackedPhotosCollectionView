//
//  StackedPhotoCollectionViewCell.m
//  
//
//  Created by Neil lv on 13-2-17.
//
//

#import "StackedPhotoCollectionViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "NINetworkImageView.h"

@interface StackedPhotoCollectionViewCell ()

@property (nonatomic, strong) NINetworkImageView *photoImv;

@end

@implementation StackedPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.photoImv = [self networkImvWithImageURL:self.photo imageName:@"image_load.png" width:self.frame.size.width height:self.frame.size.height];
    if (![self.photoImv superview]) {
        
        [self.contentView addSubview:self.photoImv];
    }
}


#pragma mark - Helpers

- (NINetworkImageView *)networkImvWithImageURL:(NSString *)imageURL imageName:(NSString *)imageName width:(float)width height:(float)height {
    
    UIImage *initialImage = [UIImage imageNamed:imageName];
    
    NINetworkImageView *networkImageView = [[NINetworkImageView alloc] initWithImage:initialImage];
    networkImageView.contentMode = UIViewContentModeCenter;
    
    // Try playing with the following scale options and turning off clips to bounds to
    // see the effects on the result image.
    //    networkImageView.scaleOptions = (NINetworkImageViewScaleToFillLeavesExcess
    //                                     | NINetworkImageViewScaleToFitCropsExcess);
    networkImageView.clipsToBounds = YES;
    
    networkImageView.backgroundColor = [UIColor clearColor];
    
    
    networkImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    networkImageView.layer.borderWidth = 1;
    networkImageView.layer.cornerRadius = 5.0f;
    
    networkImageView.frame = CGRectMake(0, 0, width, height);
    
    [networkImageView setPathToNetworkImage:imageURL
                             forDisplaySize:CGSizeMake(width, height)
                                contentMode:UIViewContentModeScaleToFill];
    
    return networkImageView;
}

@end
