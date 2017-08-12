//
//  ITDatePickerController.m
//  ITDatePickerControllerSampleCode
//
//  Created by Wit on 2017/8/10.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITDatePickerController.h"

#define kITScreenWidth        ([[UIScreen mainScreen] bounds].size.width)
#define kITScreenHeight       ([[UIScreen mainScreen] bounds].size.height)

static NSInteger kITDatePickerViewHeight = 216+44;

#define kITLocalDate(date) \
\
NSTimeZone *zone = [NSTimeZone systemTimeZone];\
NSInteger interval = [zone secondsFromGMTForDate:date];\
date = [date dateByAddingTimeInterval:interval]

#pragma mark - ***************** ITDatePickerController *************
#pragma mark -

@interface ITDatePickerController ()
<UIViewControllerTransitioningDelegate,
ITDatePickerControllerDelegate>

@property (strong, nonatomic, readwrite) ITDatePickerView *datePickerView;
@property (strong, nonatomic, readwrite) UIView *backgroundView;

@end

@implementation ITDatePickerController


#pragma mark - init
#pragma mark -

- (instancetype)init
{
    if (self = [super init]) {
        [self configDatePickerController];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configDatePickerController];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configDatePickerController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configDatePickerController];
    }
    return self;
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.backgroundView atIndex:0];
    [self.view addSubview:self.datePickerView];
    [self addSingleTapGestures];
}


#pragma mark - Public
#pragma mark -

- (void)refreshData {
    [self.datePickerView refreshData];
}


#pragma mark - IBActions
#pragma mark -

- (void)singleTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Private
#pragma mark -

- (void)configDatePickerController {
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

- (void)addSingleTapGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.backgroundView addGestureRecognizer:singleTap];
}


#pragma mark - Delegate Collection

#pragma mark - ITDatePickerControllerDelegate

- (void)datePickerController:(ITDatePickerController *)datePickerController
             didSelectedDate:(NSDate *)date
                  dateString:(NSString *)dateString {
    if ([self.delegate respondsToSelector:@selector(datePickerController:didSelectedDate:dateString:)]) {
        [self.delegate datePickerController:self didSelectedDate:date dateString:dateString];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [ITAnimation animationWithPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [ITAnimation animationWithPresenting:NO];
}


#pragma mark - Custom Accessors
#pragma mark -

- (void)setShowToday:(BOOL)showToday {
    [self.datePickerView setShowToday:showToday];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    [self.datePickerView setMaximumDate:maximumDate];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    [self.datePickerView setMinimumDate:minimumDate];
}

- (void)setDefaultYear:(NSInteger)defaultYear {
    [self.datePickerView setDefaultYear:defaultYear];
}

- (void)setDefaultMonth:(NSInteger)defaultMonth {
    [self.datePickerView setDefaultMonth:defaultMonth];
}

- (void)setDefaultDate:(NSDate *)defaultDate {
    
    [self.datePickerView setDefaultDate:defaultDate];
}

- (void)setLeftItems:(NSArray *)leftItems {
    [self.datePickerView setLeftItems:leftItems];
}

- (void)setRightItems:(NSArray *)rightItems {
    [self.datePickerView setRightItems:rightItems];
}

- (ITDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[ITDatePickerView alloc] initWithFrame:CGRectMake(0, kITScreenHeight-kITDatePickerViewHeight, kITScreenWidth, kITDatePickerViewHeight)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _backgroundView;
}

@end


#pragma mark - ***************** ITAnimation *************
#pragma mark -

@implementation ITAnimation

#pragma mark - Init
#pragma mark -

- (instancetype)initWithPresenting:(BOOL)isPresenting {
    self = [super init];
    if (self) {
        _presenting = isPresenting;
    }
    return self;
}

+ (instancetype)animationWithPresenting:(BOOL)isPresenting {
    return [[ITAnimation alloc] initWithPresenting:isPresenting];
}


#pragma mark - Private
#pragma mark -

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ITDatePickerController *toViewController = (ITDatePickerController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.backgroundView.alpha = 0.0;
    
    toViewController.datePickerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(toViewController.datePickerView.frame));
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        toViewController.backgroundView.alpha = 1.0;
    } completion:nil];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         toViewController.datePickerView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ITDatePickerController *fromViewController = (ITDatePickerController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromViewController.datePickerView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.25 animations:^{
        fromViewController.backgroundView.alpha = 0.0;
    } completion:nil];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         fromViewController.datePickerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(fromViewController.datePickerView.frame));
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}


#pragma mark - UIViewControllerAnimatedTransitioning
#pragma mark -

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        [self presentAnimateTransition:transitionContext];
    }else {
        [self dismissAnimateTransition:transitionContext];
    }
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        return 0.45;
    }
    return 0.25;
}

@end

#pragma mark - ***************** IDDatePickerView *************
#pragma mark -

static NSInteger maxCount = 1000;

@interface ITDatePickerView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

@property (nonatomic) NSInteger yearCount;
@property (nonatomic) NSInteger monthCount;
@property (nonatomic) NSInteger thisYear;
@property (nonatomic) NSInteger thisMonth;
@property (nonatomic) NSInteger thisDay;
@property (nonatomic) NSInteger maximumYear;
@property (nonatomic) NSInteger minimumYear;
@property (nonatomic) NSInteger maximumMonth;
@property (nonatomic) NSInteger minimumMonth;
@property (nonatomic) NSInteger selectedYear;
@property (nonatomic) NSInteger selectedMonth;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, getter=isHideMonth) BOOL hideMonth;

@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *confirmButton;
@property (strong, nonatomic, readwrite) UIBarButtonItem *flexibleSpaceItem;
@property (strong, nonatomic, readwrite) UIToolbar *toolBar;
@property (strong, nonatomic) UIPickerView *pickerView;

/**
 Cancel the operation
 */
- (void)cancelButtonOnClicked:(UIButton *)sender;

/**
 Confirm the operation
 */
- (void)confirmButtonOnClicked:(UIButton *)sender;

@end

@implementation ITDatePickerView

@synthesize yearCount = _yearCount;

#pragma mark - Init
#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDatePickerView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatePickerView];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self refreshData];
}

#pragma mark - Public
#pragma mark -

- (void)refreshData {
    
    if (self.showToday && self.defaultYear == self.thisYear) {
        self.hideMonth = YES;
    } else {
        self.hideMonth = NO;
    }
    
    [self.pickerView reloadAllComponents];
    [self setDefaultYear:_defaultYear];
    [self setDefaultMonth:_defaultMonth];
}


#pragma mark - IBActions
#pragma mark -

- (void)cancelButtonOnClicked:(UIButton *)sender {
    [[self topVC] dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonOnClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(datePickerController:didSelectedDate:dateString:)]) {
        NSString *dateString = [NSString stringWithFormat:@"%ld.%02ld", self.selectedYear, self.selectedMonth];
        NSDate *selectedDate = [self.dateFormatter dateFromString:dateString];
        if (self.selectedYear == self.thisYear &&
            self.selectedMonth == self.thisMonth &&
            self.showToday) {
            dateString = @"至今";
        }
        
        kITLocalDate(selectedDate);
        
        [self.delegate datePickerController:nil didSelectedDate:selectedDate dateString:dateString];
    }
    
    [self cancelButtonOnClicked:nil];
}


#pragma mark - Private
#pragma mark -

- (void)initDatePickerView {
    
    [self initThisDate];
    self.maximumDate = [self.dateFormatter dateFromString:@"2100.12"];
    self.minimumDate = [self.dateFormatter dateFromString:@"1900.01"];
    
    _monthCount = 12;
    _yearCount = _maximumYear - _minimumYear+1;
    _defaultYear = _thisYear;
    _defaultMonth = _thisMonth;
    _showToday = YES;
    
    [self addSubview:self.toolBar];
    [self addSubview:self.pickerView];
}

- (void)initThisDate {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    _thisYear = [components year];
    _thisMonth = [components month];
    _thisDay = [components day];
}

- (UIViewController *)topVC {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)resetToolbar{
    
    NSMutableArray *items = [NSMutableArray array];
    if (self.leftItems.count>0) {
        [items addObjectsFromArray:self.leftItems];
    }
    
    [items addObject:self.flexibleSpaceItem];
    
    if (self.rightItems.count>0) {
        [items addObjectsFromArray:self.rightItems];
    }
    
    [self.toolBar setItems:items];
}

#pragma mark - Delegate Collectioin
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return maxCount;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSInteger index = row % self.yearCount;
        NSString *text = [NSString stringWithFormat:@"%ld", self.minimumYear+index];
        if (self.isShowToday &&
            text.integerValue == self.thisYear &&
            self.selectedYear == self.thisYear &&
            self.selectedMonth == self.thisMonth) {
            text = @"至今";
        }
        return text;
    } else {
        NSInteger index = row % self.monthCount+1;
        if (self.isHideMonth && self.thisMonth == index) {
            return @"--";
        }
        return [NSString stringWithFormat:@"%02ld", index];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedYear = row%self.yearCount+self.minimumYear;
    } else {
        self.selectedMonth = row%self.monthCount+1;

    }
    
    if (self.selectedYear == self.maximumYear &&
        self.selectedMonth > self.maximumMonth) {
        self.defaultMonth = self.maximumMonth;
    }
    
    if (self.selectedYear == self.minimumYear &&
         self.selectedMonth < self.minimumMonth) {
            self.defaultMonth = self.minimumMonth;
    }
    
    if (self.isShowToday) {
        if ((self.selectedYear != self.thisYear &&
             self.selectedMonth == self.thisMonth) ||
            (self.selectedYear == self.thisYear &&
             self.selectedMonth != self.thisMonth)) {
                self.hideMonth = NO;
                [self.pickerView reloadAllComponents];
            }
        
        if ( self.selectedYear == self.thisYear &&
            self.selectedMonth == self.thisMonth) {
            self.hideMonth = YES;
            [self.pickerView reloadAllComponents];
        }
    }
}


#pragma mark - Custom Accessors
#pragma mark -

- (void)setDefaultYear:(NSInteger)defaultYear {
    if (defaultYear> self.maximumYear) {
        _defaultYear = self.maximumYear;
    } else if (defaultYear < self.minimumYear) {
        _defaultYear = self.minimumYear;
    } else {
        _defaultYear = defaultYear;
    }
    
    NSInteger selctRow = (maxCount/2)/self.yearCount*self.yearCount+ self.defaultYear- self.minimumYear;
    self.selectedYear = defaultYear;
    [self.pickerView reloadComponent:0];
    [self.pickerView selectRow:selctRow inComponent:0 animated:NO];
}

- (void)setDefaultMonth:(NSInteger)defaultMonth {
    if (defaultMonth> 12) {
        _defaultMonth = 12;
    } else if (defaultMonth < 1) {
        _defaultYear = 1;
    } else {
        _defaultMonth = defaultMonth;
    }
    
    _defaultMonth = defaultMonth;
    NSInteger selectRow = (maxCount/2)/self.monthCount*self.monthCount+ self.defaultMonth-1;
    self.selectedMonth = defaultMonth;
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:selectRow inComponent:1 animated:NO];
}

- (void)setShowToday:(BOOL)showToday {
    _showToday = showToday;
}

- (void)setMinimumYear:(NSInteger)minimumYear {
    _minimumYear = minimumYear;
    self.yearCount = _maximumYear - _minimumYear+1;
}

- (void)setMaximumYear:(NSInteger)maximumYear {
    _maximumYear = maximumYear;
    self.yearCount = _maximumYear - _minimumYear+1;
}

- (void)setYearCount:(NSInteger)yearCount {
    _yearCount = yearCount;
}

- (NSInteger)yearCount {
    if (self.isShowToday) {
        return _yearCount;
    } else {
        return _yearCount;
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {

    _maximumDate = maximumDate;
    if (_maximumDate == nil) {
        _maximumDate = [self.dateFormatter dateFromString:@"2100.12"];
    }

    kITLocalDate(_maximumDate);
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_maximumDate];
    self.maximumYear = [components year];
    self.maximumMonth = [components month];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    
    _minimumDate = minimumDate;
    if (_defaultDate == nil) {
        _minimumDate = [self.dateFormatter dateFromString:@"1900.01"];
    }

    kITLocalDate(_minimumDate);

    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_minimumDate];
    self.minimumYear = [components year];
    self.minimumMonth = [components month];
}

- (void)setDefaultDate:(NSDate *)defaultDate {
    
    _defaultDate = defaultDate;
    if (_defaultDate == nil) {
        _defaultDate = [NSDate date];
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_defaultDate];
    NSInteger year = [components year];
    NSInteger month = [components month];
    [self setDefaultYear:year];
    [self setDefaultMonth:month];
}

- (void)setLeftItems:(NSArray *)leftItems {
    _leftItems = [leftItems copy];
    [self resetToolbar];
}

- (void)setRightItems:(NSArray *)rightItems {
    _rightItems = rightItems;
    [self resetToolbar];
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy.MM";
    }
    return _dateFormatter;
}

- (UIBarButtonItem *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonOnClicked:)];
    }
    return _cancelButton;
}

- (UIBarButtonItem *)flexibleSpaceItem {
    if (!_flexibleSpaceItem) {
        _flexibleSpaceItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:self
                                                      action:nil];
    }
    
    return _flexibleSpaceItem;
}

- (UIBarButtonItem *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmButtonOnClicked:)];
    }
    return _confirmButton;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kITScreenWidth, 0.5)];
        _line.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    }
    return _line;
}

- (UIToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kITScreenWidth, 44)];
        _toolBar.translucent = NO;
        
        self.leftItems = @[self.cancelButton];
        self.rightItems = @[self.confirmButton];
        [self resetToolbar];
        
        [_toolBar addSubview:self.line];
    }
    return _toolBar;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kITScreenWidth, 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end

