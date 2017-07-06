//
//  ViewController.m
//  DynamicToss
//
//  Created by 葛佳佳 on 2017/2/15.
//  Copyright © 2017年 葛佳佳. All rights reserved.
//

#import "ViewController.h"

static const CGFloat ThrowingThreshold = 1000;
static const CGFloat ThrowingVelocityPadding = 35;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *redSquare;
@property (weak, nonatomic) IBOutlet UIView *blueSquare;

@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.originalBounds = self.imageView.bounds;
    self.originalCenter = self.imageView.center;
}

- (IBAction)handleAttachmentGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint boxLocation = [sender locationInView:self.imageView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"you touch started position %@",NSStringFromCGPoint(location));
            NSLog(@"location in image started is %@",NSStringFromCGPoint(boxLocation));
            
            // 1
            [self.animator removeAllBehaviors];
            
            // 2
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.imageView.bounds),
                                                 boxLocation.y - CGRectGetMidY(self.imageView.bounds));
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.imageView
                                                                offsetFromCenter:centerOffset
                                                                attachedToAnchor:location];
            // 3
            self.redSquare.center = self.attachmentBehavior.anchorPoint;
            self.blueSquare.center = location;
            
            // 4
            [self.animator addBehavior:self.attachmentBehavior];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            NSLog(@"you touch ended position %@",NSStringFromCGPoint(location));
            NSLog(@"location in image ended is %@",NSStringFromCGPoint(boxLocation));
            
            [self.animator removeBehavior:self.attachmentBehavior];
            
            //1
            CGPoint velocity = [sender velocityInView:self.view];
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            
            if (magnitude > ThrowingThreshold) {
                //2
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                initWithItems:@[self.imageView]
                                                mode:UIPushBehaviorModeInstantaneous];
                pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                
                self.pushBehavior = pushBehavior;
                [self.animator addBehavior:self.pushBehavior];
                
                //3
                NSInteger angle = arc4random_uniform(20) - 10;
                
                self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.imageView]];
                self.itemBehavior.friction = 0.2;
                self.itemBehavior.allowsRotation = YES;
                [self.itemBehavior addAngularVelocity:angle forItem:self.imageView];
                [self.animator addBehavior:self.itemBehavior];
                
                //4
                [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.4];
            }
            
            else {
                [self resetDemo];
            }
            
            break;
        }
        default:
        {
            [self.attachmentBehavior setAnchorPoint:[sender locationInView:self.view]];
            self.redSquare.center = self.attachmentBehavior.anchorPoint;
        }
            break;
    }
    
}

- (void)resetDemo
{
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.45 animations:^{
        self.imageView.bounds = self.originalBounds;
        self.imageView.center = self.originalCenter;
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
