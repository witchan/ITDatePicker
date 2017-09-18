//
//  ITContainerController.m
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITContainerController.h"
#import "ITAppMacro.h"
#import "ITAnimation.h"

@interface ITContainerController ()
<UIViewControllerTransitioningDelegate>

@property (nonatomic) ITAnimationType animationType;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation ITContainerController

#pragma mark - init
#pragma mark -

- (instancetype)init {
    if (self = [super init]) {
        [self configContainerController];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configContainerController];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configContainerController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configContainerController];
    }
    return self;
}

- (instancetype)initWithContentView:(ITAlertBox *)contentView
                      animationType:(ITAnimationType)animationType {
    self = [super init];
    if (self) {
        _contentView = contentView;
        _animationType = animationType;
        [self configContainerController];
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.backgroundView atIndex:0];
    [self.view addSubview:self.contentView];
    [self addSingleTapGestures];
    
    [self autoLayoutSubviews];
}

#pragma mark - IBActions
#pragma mark -

- (void)singleTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private
#pragma mark -

- (void)configContainerController {
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

- (void)addSingleTapGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.backgroundView addGestureRecognizer:singleTap];
}

- (void)autoLayoutSubviews {

    CGFloat contentWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat contentHeight = CGRectGetHeight(self.contentView.frame);

    switch (self.animationType) {
        case ITAnimationTypeBottom: {
            self.contentView.frame = CGRectMake((kITScreenWidth-contentWidth)/2, kITScreenHeight-contentHeight, contentWidth, contentHeight);
            break;
        }
        case ITAnimationTypeCenter: {
            self.contentView.center = self.view.center;
            break;
        }
    }
}

#pragma mark - Delegate Collection

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [ITAnimation animationWithType:self.animationType presenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [ITAnimation animationWithType:self.animationType presenting:NO];
}

- (UIView *)viewContainer {
    return self.view;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _backgroundView;
}

@end


