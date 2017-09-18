//
//  ITAnimation.m
//  ITAlertBox
//
//  Created by Wit on 2017/9/16.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITAnimation.h"
#import "ITBottomAnimation.h"
#import "ITCenterAnimation.h"

@implementation ITAnimation

#pragma mark - Init

- (instancetype)initWithPresenting:(BOOL)isPresenting {
    self = [super init];
    if (self) {
        _presenting = isPresenting;
    }
    return self;
}

+ (instancetype)animationWithType:(ITAnimationType)animationType presenting:(BOOL)isPresenting {

    switch (animationType) {
        case ITAnimationTypeBottom: {
            ITBottomAnimation *bottomAnimation = [[ITBottomAnimation alloc] initWithPresenting:isPresenting];
            return bottomAnimation;
        }
        case ITAnimationTypeCenter: {
            ITCenterAnimation *centerAnimation = [[ITCenterAnimation alloc] initWithPresenting:isPresenting];
            return centerAnimation;
        }
    }
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

@end
