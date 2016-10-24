//
//  ViewController.h
//  Animations
//
//  Created by Gordon Kung on 10/24/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollisionBehaviorDelegate>

@property (strong, nonatomic) IBOutlet UIView *bar;
@property (strong, nonatomic) IBOutlet UIImageView *tinyBall;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UILabel *loselbl;
@property (strong, nonatomic) IBOutlet UIButton *startbtn;
@property (weak, nonatomic) IBOutlet UILabel *finalScoreLbl;


- (IBAction)startButton:(id)sender;
@end

