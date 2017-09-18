//
//  ITAnimation.h
//  ITAlertBox
//
//  Created by Wit on 2017/9/16.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ITContainerControllerProtocol.h"

typedef NS_ENUM(NSUInteger, ITAnimationType) {
    ITAnimationTypeBottom = 0,
    ITAnimationTypeCenter,
};

@interface ITAnimation : NSObject
<UIViewControllerAnimatedTransitioning>

/**
 Whether it is presenting
 */
@property (nonatomic, getter=isPresenting) BOOL presenting;

/**
 Factory method, create transition animation
 
 @param animationType Animation type
 @param isPresenting  Whether it is presenting
 @return transition animation object
 */
+ (instancetype)animationWithType:(ITAnimationType)animationType presenting:(BOOL)isPresenting;

@end
