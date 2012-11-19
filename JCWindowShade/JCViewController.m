//
//  JCViewController.m
//  JCWindowShade
//
//  Created by John Cadengo on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JCViewController.h"

NSString * const kRevealShadeViewSegueIdentifier = @"RevealShadeView";
NSString * const kSwipeUpLabel = @"Swipe Up";
NSString * const kSwipeDownLabel = @"Swipe Down";
NSString * const kDragUpLabel = @"Drag Up";
NSString * const kDragDownLabel = @"Drag Down";

@interface JCViewController ()

@end

@implementation JCViewController

@synthesize swipeableView = _swipeableView;
@synthesize dragableView = _dragableView;
@synthesize revealableView = _revealableView;
@synthesize swipeableViewFrame = _swipeableViewFrame;
@synthesize dragableViewFrame = _dragableViewFrame;
@synthesize revealableViewFrame = _revealableViewFrame;
@synthesize swipeUp = _swipeUp;
@synthesize swipeDown = _swipeDown;
@synthesize dragableViewLabel = _dragableViewLabel;
@synthesize drag = _drag;
@synthesize dragging = _dragging;
@synthesize revealableViewShowing = _revealableShowing;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // Set up the swipeable area
    self.swipeableViewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 370.0f);
    self.swipeableView = [[UIView alloc] initWithFrame:self.swipeableViewFrame];
    self.swipeableView.backgroundColor = [UIColor brownColor];
    UILabel *swipeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 160.0f, 320.0f, 50.0f)];
    [swipeLabel setText:kSwipeUpLabel];
    [swipeLabel setTextAlignment:UITextAlignmentCenter];
    [swipeLabel setBackgroundColor:[UIColor clearColor]];
    [self.swipeableView addSubview:swipeLabel];
    [self.view addSubview:self.swipeableView];
    
    // Draggable area
    self.dragableViewFrame = CGRectMake(0.0f, 370.0f, 320.0f, 90.0f);
    self.dragableView = [[UIView alloc] initWithFrame:self.dragableViewFrame];
    self.dragableView.backgroundColor = [UIColor orangeColor];
    self.dragableViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 50.0f)];
    [self.dragableViewLabel setText:kDragUpLabel];
    [self.dragableViewLabel setTextAlignment:UITextAlignmentCenter];
    [self.dragableViewLabel setBackgroundColor:[UIColor clearColor]];
    [self.dragableView addSubview:self.dragableViewLabel];
    [self.view addSubview:self.dragableView];
    
    // Revealable area. Initially hidden, but if you swipe or drag up it will show
    self.revealableViewFrame = CGRectMake(0.0f, 460.0f, 320.0f, 460.0f);
    self.revealableView = [[UIView alloc] initWithFrame:self.revealableViewFrame];
    self.revealableView.backgroundColor = [UIColor greenColor];
    UILabel *revealLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 160.0f, 320.0f, 50.0f)];
    [revealLabel setText:kSwipeDownLabel];
    [revealLabel setTextAlignment:UITextAlignmentCenter];
    [revealLabel setBackgroundColor:[UIColor clearColor]];
    [self.revealableView addSubview:revealLabel];
    [self.view addSubview:self.revealableView];
    
    // Add our gesture recognizers
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.dragableView addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
    [self.drag setCancelsTouchesInView:NO];
    
    self.swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.swipeUp setDelegate:self];
    
    self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.swipeDown setDelegate:self];
    
    [self.swipeableView addGestureRecognizer:self.swipeUp];
    [self.revealableView addGestureRecognizer:self.swipeDown];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.swipeableView = nil;
    self.dragableView = nil;
    self.revealableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kRevealShadeViewSegueIdentifier]) {
        // Do any necessary preparations for revealing the view
        NSLog(@"Revealing view");
    }
}

- (void)hideRevealableView
{
    [self offsetFrames:0.0f];
    [self.dragableViewLabel setText:kDragUpLabel];
}

- (void)showRevealableView
{
    [self performSegueWithIdentifier:kRevealShadeViewSegueIdentifier sender:nil];
    [self offsetFrames:-self.swipeableViewFrame.size.height];
    [self.dragableViewLabel setText:kDragDownLabel];
}

- (void)offsetFrames:(CGFloat)offset
{
    // Grab our views and drag them
    self.swipeableView.frame = CGRectOffset(self.swipeableViewFrame, 0.0f, offset);
    self.dragableView.frame = CGRectOffset(self.dragableViewFrame, 0.0f, offset);
    self.revealableView.frame = CGRectOffset(self.revealableViewFrame, 0.0f, offset);
}


- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.isDragging && gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Reset isDragging
        self.dragging = NO;
        
        // If it is over, we check the velocity of the drag
        // to see if we want to finish dragging it up or down
        CGPoint origin = [gestureRecognizer velocityInView:self.view];
        CGFloat velocity = origin.y;
        CGFloat vertical;
        NSTimeInterval duration;
        
        // If the y value is negative, we are moving up and so attach the view
        if (velocity < 0) {
            // Calculate how many points we have to go before we hit our destination
            vertical = self.revealableView.frame.origin.y - self.view.frame.origin.y;
            duration = MIN(ABS(vertical / velocity), 1.0f);
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 [self showRevealableView];
                             }
                             completion:^(BOOL finished){
                                 self.revealableViewShowing = YES;
                             }];
        }
        else {
            // Otherwise, at a standstill or moving back, we want to retract the view
            vertical = self.revealableView.frame.origin.y - self.dragableView.frame.origin.y;
            duration = MIN(ABS(vertical / velocity), 1.0f);
            
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:UIViewAnimationCurveLinear
                             animations:^{
                                 [self hideRevealableView];
                             }
                             completion:^(BOOL finished){
                                 self.revealableViewShowing = NO;
                             }];
        }
    }
    else if (self.isDragging) {
        [self performSegueWithIdentifier:kRevealShadeViewSegueIdentifier sender:nil];
        // Keep track of where we are
        CGPoint origin = [gestureRecognizer locationInView:self.view];
        
        // As long as we aren't going above the top of the view, have it follow the drag
        if (CGRectContainsPoint(self.view.frame, origin)) {
            // Only allow dragging to a certain point. Don't let drag further down.
            CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
            
            // Our offset is different depending on if the revealable view is showing or not
            CGFloat offset = (self.isRevealableViewShowing) ? self.swipeableViewFrame.size.height : 0.0f;
            
            if (translatedPoint.y < offset) {
                // Track the drag
                [self offsetFrames:translatedPoint.y - offset];
            }
            else {
                // Stick to the bottom
                [self hideRevealableView];
            }
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Now, we are dragging
        self.dragging = YES;
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (self.swipeUp == gestureRecognizer && !self.isRevealableViewShowing) {
        // If the  revealable view isn't showing, and we swipe up, then show it
        [UIView animateWithDuration:1.0f
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             [self showRevealableView];
                         }
                         completion:^(BOOL finished){
                             self.revealableViewShowing = YES;
                         }];
    }
    else if (self.swipeDown == gestureRecognizer && self.isRevealableViewShowing) {
        // If the  revealable view is showing, and we swipe down, then hide it
        [UIView animateWithDuration:1.0f
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             [self hideRevealableView];
                         }
                         completion:^(BOOL finished){
                             self.revealableViewShowing = NO;
                         }];
    }
}


@end
