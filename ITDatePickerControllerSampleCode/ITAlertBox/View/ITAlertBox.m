//
//  ITAlertBox.m
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITAlertBox.h"
#import "ITDatePicker.h"

@implementation ITAlertBox

#pragma mark - Init
#pragma mark -

+ (instancetype)alertBoxWithType:(ITAlertBoxType)type {
    switch (type) {
        case ITAlertBoxTypeDatePicker: {
            ITDatePicker *datePicker = [[ITDatePicker alloc] init];
            return datePicker;
        }
    }
    return nil;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self viewDidLoad];
    [self autoLayoutSubviews];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self viewDidLoad];
    [self autoLayoutSubviews];
}

#pragma mark - Public
#pragma mark -

- (void)viewDidLoad {
    
}

- (void)autoLayoutSubviews {
    
}

@end
