//
//  ITContainerController.h
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITAnimation.h"
#import "ITContainerControllerProtocol.h"

@interface ITContainerController : UIViewController
<ITContainerControllerProtocol>

- (instancetype)initWithContentView:(UIView *)contentView
                      animationType:(ITAnimationType)animationType;

@end
