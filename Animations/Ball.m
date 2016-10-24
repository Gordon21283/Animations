//
//  Ball.m
//  Animations
//
//  Created by Gordon Kung on 10/24/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "Ball.h"

@implementation Ball

- (UIDynamicItemCollisionBoundsType)collisionBoundsType{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
