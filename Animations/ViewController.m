//
//  ViewController.m
//  Animations
//
//  Created by Gordon Kung on 10/24/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIPushBehavior *pusher;
@property CGPoint start;
@property (strong, nonatomic) UILabel *scoreLabel;
@property int score;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

@property (nonatomic) CGFloat bottomBarPosition;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeScoreLabel];
    
    self.tinyBall.layer.cornerRadius = 15;
    
    [self.loselbl setHidden:YES];
    [self.finalScoreLbl setHidden:YES];
    self.start = self.tinyBall.center;
    self.score = 0;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.bar addGestureRecognizer:panGestureRecognizer];

    
    
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    if(self.bottomBarPosition == 0){
        self.bottomBarPosition = self.bar.center.y;
    }
    panGestureRecognizer.view.center = CGPointMake(touchLocation.x, self.bottomBarPosition);
    [self.animator updateItemUsingCurrentState:self.bar];
}

-(void)makeScoreLabel {
    
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    self.scoreLabel.text = @"0";
    self.scoreLabel.font = [UIFont fontWithName:@"Chalkduster" size:26];
    self.scoreLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.scoreLabel];
    
}

- (IBAction)startButton:(id)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(startGame)
                                                userInfo:nil
                                                 repeats:NO];
}
-(void)startGame{
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",_score];
    [self.finalScoreLbl setHidden:YES];
    [self.loselbl setHidden:YES];
    [self.tinyBall setHidden:NO];
    [self.bar setHidden:NO];
    [self.startbtn setHidden:YES];
    
    self.tinyBall.center = self.start;
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.tinyBall]];
    [animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *barBehavior = [[UIDynamicItemBehavior alloc]init];
    [barBehavior addItem:self.bar];
    barBehavior.allowsRotation = NO;
    barBehavior.density = 5000.0f;
    [animator addBehavior:barBehavior];
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc]init];
    [ballBehavior addItem:self.tinyBall];
    ballBehavior.elasticity = 1.01f;
    ballBehavior.allowsRotation = YES;
    ballBehavior.friction = 0.0;
    ballBehavior.resistance = 0.0;
    ballBehavior.angularResistance = 0.0;
    [animator addBehavior:ballBehavior];
    
    
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.tinyBall] mode:UIPushBehaviorModeInstantaneous];
    self.pusher.pushDirection = CGVectorMake(0.5, 1.0);
    self.pusher.magnitude = 0.3f;
    self.pusher.active = YES;
    [animator addBehavior:self.pusher];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.tinyBall, self.bar]];
    
    
    CGFloat bottomY = CGRectGetMaxY(self.view.frame);
    CGFloat leftX = CGRectGetMinX(self.view.frame);
    CGFloat rightX = CGRectGetMaxX(self.view.frame);
    
    CGPoint bottomLeftCorner = CGPointMake(leftX, bottomY);
    CGPoint bottomRightCorner = CGPointMake(rightX, bottomY);
    
    [collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:bottomLeftCorner toPoint:bottomRightCorner];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [animator addBehavior:collisionBehavior];
    
    self.animator = animator;
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{
    
    
    NSString *string = [NSString stringWithFormat:@"%@",identifier];
    if([string isEqualToString:@"bottom"] && item == self.tinyBall){
        NSLog(@"You lose");
        [self.animator removeAllBehaviors];
        self.finalScoreLbl.text = [NSString stringWithFormat:@"Score: %d",self.score];
        [self.finalScoreLbl setHidden:NO];
        [self.tinyBall setHidden:YES];
        [self.bar setHidden:YES];
        [self.loselbl setHidden:NO];
        [self.startbtn setHidden:NO];
        self.score = 0;
        
        self.startbtn.titleLabel.text = @"Restart";
    }
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {
    
    
    if ((item1 == self.tinyBall && item2 == self.bar) || (item1 == self.bar && item2 == self.tinyBall)) {
        _score++;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d",_score];
    }
}

@end
