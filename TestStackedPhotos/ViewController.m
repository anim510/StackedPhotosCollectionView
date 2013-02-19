//
//  ViewController.m
//  TestStackedPhotos
//
//  Created by Neil lv on 13-2-17.
//
//

#import "ViewController.h"

#import "StackedPhotoLayout.h"
#import "StackedPhotoCollectionViewCell.h"

#define CELL_IDENTIFIER                         @"StackedPhotoCell"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isOpenStack;
@property (nonatomic, assign) float lastScale;

@property (nonatomic, strong) NSMutableArray *photoURLs;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // http://www.raywenderlich.com/22324/beginning-uicollectionview-in-ios-6-part-12
    // http://www.raywenderlich.com/22417/beginning-uicollectionview-in-ios-6-part-22
    
    self.photoURLs = [@[] mutableCopy];
    self.lastScale = 0.0f;
    
    [self.view addSubview:self.collectionView];
    
    self.photoURLs = [@[
                      @"http://images-fast.digu.com/9bf191bb762c4a909dcfee81b203c8b70003.jpg",
                      @"http://img2.126.net/xoimages/game/20130101/wh/x/130x100.jpg",
                      @"http://m2.img.libdd.com/farm5/255/14624AF3D7CE4A49F5A883D06F1D99FF_486_575.JPEG",
                      @"http://images-fast.digu.com/c777ff81fa4d40f48e2c639b31cddc4e0004.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/804790aejw1dv61la1jv2j.jpg",
                      @"http://images-fast.digu.com/d40cb49d3da54a21aef7105df0c483e20004.jpg",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=bfaad44c5982b2b7a79f39cc01accb0a/95eef01f3a292df5fe10e05dbc315c6035a873a2.jpg",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=f05ce76efdfaaf5184e381b7bc5594ed/960a304e251f95caef8fddfec9177f3e6709527b.jpg",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=876bc9a69c82d158bb8259b9b00b19d5/9345d688d43f8794f2a00766d21b0ef41bd53a1e.jpg",
                      @"http://imgsrc.baidu.com/forum/w%3D580/sign=ff1d8c7b738da9774e2f86238050f872/63d0f703918fa0ecbd772b45269759ee3c6ddbc2.jpg",
                      
                      @"http://www.guancha.cn/pic/2012/5/20/63473121860140625020115231434587521329231412_%E5%89%AF%E6%9C%AC.jpg",
                      @"http://i2.17173.itc.cn/2012/818/2012/05/08/5206/origin/57253.jpg",
                      @"http://images-fast.digu.com/602c51de0e6449fea057c75e8302975a0003.jpg",
                      @"http://i2.17173.itc.cn/2012/818/2012/05/08/5206/origin/57253.jpg",
                      @"http://images-fast.digu.com/602c51de0e6449fea057c75e8302975a0003.jpg",
                      @"http://img.tpzj.com/upload/DaqiDownloadImg/67/047_95ae6c5a5c37aeb6b3d835d0e8539fd4.jpg",] mutableCopy];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}


#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGRect frame = CGRectMake(0,
                                  0,
                                  [[UIScreen mainScreen] applicationFrame].size.width,
                                  [[UIScreen mainScreen] applicationFrame].size.height);
        
        StackedPhotoLayout *stackLayout = [[StackedPhotoLayout alloc] init];
        stackLayout.stackCenter = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        stackLayout.stackFactor = 0.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:stackLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor purpleColor];
        [_collectionView registerClass:[StackedPhotoCollectionViewCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openStackedPhoto:)];
        tapGestureRecognizer.cancelsTouchesInView = YES;
        tapGestureRecognizer.delaysTouchesEnded = NO;
        tapGestureRecognizer.numberOfTapsRequired = 1;
        
        [_collectionView addGestureRecognizer:tapGestureRecognizer];
        
//        // Pinch - scale
//        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
//        [pinchGestureRecognizer setDelegate:self];
//        [_collectionView addGestureRecognizer:pinchGestureRecognizer];
    }
    return _collectionView;
}


#pragma mark - UIGestureRecognizerDelegate

- (void)scale:(UIPinchGestureRecognizer*)sender {
    
    if([sender state] == UIGestureRecognizerStateEnded) {

        self.lastScale = 1.0;
        [_collectionView performBatchUpdates:^{
            ((StackedPhotoLayout *)_collectionView.collectionViewLayout).stackFactor = 1.0f;
        } completion:nil];
        
        return;
    }
    
    [_collectionView performBatchUpdates:^{
        ((StackedPhotoLayout *)_collectionView.collectionViewLayout).stackFactor = self.lastScale;
    } completion:nil];
    
//    CGFloat scale = 1.0 - (self.lastScale - [(UIPinchGestureRecognizer *)sender scale]);
//    CGAffineTransform currentTransform = self.photoCar.transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    
//    [self.photoImv setTransform:newTransform];
    self.lastScale = [sender scale];
}


#pragma mark - UITapGestureRecognizer

- (void)openStackedPhoto:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
        NSLog(@"openStackedPhoto.....  %d", self.isOpenStack);
        
        BOOL shouldOpen = NO;
        float factor = 0.0f;
        
        CGPoint initialTapPoint = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialTapPoint];
        
        if (tappedCellPath) {
            
            NSLog(@"tappedCellPath.........  isOpenStack: %d, yeyeyeyeeysss : %@", self.isOpenStack, tappedCellPath);
            // Did tap the selected cell when the stack is not opened, then open it
            if (!self.isOpenStack) {
                
                self.isOpenStack = YES;
                factor = 1.0f;
                shouldOpen = YES;
                
            } else {
                
                // Did tap the selected cell when the stack is open, then execute the cell select action
                NSLog(@"to selected......  %@", tappedCellPath);
                // TODO:did select the collection view cell
            }
            
        } else {
            
            NSLog(@"tappedCellPath......... isOpenStack : %d,  nonononono : %@", self.isOpenStack, tappedCellPath);
            self.isOpenStack = !self.isOpenStack;
            
            if (self.isOpenStack) {
                
                factor = 1.0f;
            }
            shouldOpen = YES;
        }
        
//        NSLog(@"shouldOpen:   %d, self.isOpenStack: %d, factor: %f", shouldOpen, self.isOpenStack, factor);
        
        if (shouldOpen) {
            
            [_collectionView performBatchUpdates:^{
                ((StackedPhotoLayout *)_collectionView.collectionViewLayout).stackFactor = factor;
            } completion:nil];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.photoURLs count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    
    StackedPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.row < [self.photoURLs count]) {
        
        cell.photo = self.photoURLs[indexPath.row];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"should...");
//    return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"did select........,  isOpenStack:  %d", self.isOpenStack);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"did de-select....");
}


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
