//
//  ITDatePicker.m
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITDatePicker.h"
#import "ITAppMacro.h"
#import "ITPickerView.h"

#define kITLocalDate(date) \
\
NSTimeZone *zone = [NSTimeZone systemTimeZone];\
NSInteger interval = [zone secondsFromGMTForDate:date];\
date = [date dateByAddingTimeInterval:interval]

@interface ITDatePicker ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

@property (nonatomic) NSInteger yearCount;
@property (nonatomic) NSInteger monthCount;
@property (nonatomic) NSInteger dayCount;
@property (nonatomic) NSInteger thisYear;
@property (nonatomic) NSInteger thisMonth;
@property (nonatomic) NSInteger thisDay;
@property (nonatomic) NSInteger maximumYear;
@property (nonatomic) NSInteger maximumMonth;
@property (nonatomic) NSInteger maximumDay;
@property (nonatomic) NSInteger minimumYear;
@property (nonatomic) NSInteger minimumMonth;
@property (nonatomic) NSInteger minimumDay;

@property (nonatomic) NSInteger limitYear;
@property (nonatomic) NSInteger lowerLimitYear;

@property (nonatomic, getter=isHideMonth) BOOL hideMonth;

@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *confirmButton;
@property (strong, nonatomic, readwrite) UIBarButtonItem *flexibleSpaceItem;
@property (strong, nonatomic, readwrite) UIToolbar *toolBar;
@property (strong, nonatomic) ITPickerView *pickerView;

/**
 Cancel the operation
 */
- (void)cancelButtonOnClicked:(UIButton *)sender;

/**
 Confirm the operation
 */
- (void)confirmButtonOnClicked:(UIButton *)sender;

@end

@implementation ITDatePicker

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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshData];
        });
    });
}

#pragma mark - Public
#pragma mark -

- (void)refreshData {
    
    if (self.showToday && self.defaultYear == self.thisYear) {
        self.hideMonth = YES;
    } else {
        self.hideMonth = NO;
    }
    
    [self.pickerView selectRow:(self.defaultYear-self.lowerLimitYear) inComponent:0 animated:NO];
    [self.pickerView selectRow:(self.defaultMonth-1) inComponent:1 animated:NO];
    
    if (self.mode == ITDatePickerModeYearAndMonthAndDay) {
        [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:NO];
    }
}


#pragma mark - IBActions
#pragma mark -

- (void)cancelButtonOnClicked:(UIButton *)sender {
    [[self topVC] dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmButtonOnClicked:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(alertBox:didSelectedResult:)]) {
        NSString *dateString = [NSString stringWithFormat:@"%ld.%02ld", self.defaultYear, self.defaultMonth];
        
        if (self.mode == ITDatePickerModeYearAndMonthAndDay) {
            dateString = [dateString stringByAppendingString:[NSString stringWithFormat:@".%02ld", self.defaultDay]];
        }
        
        if (self.defaultYear == self.thisYear &&
            self.defaultMonth == self.thisMonth &&
            self.defaultDay == self.thisDay &&
            self.showToday) {
            dateString = @"至今";
        }
        
        [self.delegate alertBox:self didSelectedResult:dateString];
    }
    
    [self cancelButtonOnClicked:nil];
}


#pragma mark - Private
#pragma mark -

- (void)initDatePickerView {
    
    [self initThisDate];
    
    self.defaultYear = self.thisYear;
    self.defaultMonth = self.thisMonth;
    self.defaultDay = self.thisDay;
    
    _monthCount = 12;
    _dayCount = 31;
    
    
    NSString *defalultDate = [NSString stringWithFormat:@"%ld.%02ld.%02ld", self.defaultYear, self.defaultMonth, self.defaultDay];
    self.defaultDate = defalultDate;
    self.minimumDate = @"1900.01.01";
    self.maximumDate = @"2200.12.31";
    
    _showToday = YES;
    self.showOutsideDate = NO;
    [self addSubview:self.toolBar];
    [self addSubview:self.pickerView];
    
    self.frame = CGRectMake(0, 0, kITScreenWidth, 260);
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

#pragma mark - Delegate Collectioin
#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.mode == ITDatePickerModeYearAndMonth) {
        return 2;
    } else {
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (component) {
        case 0: return self.yearCount;
        case 1: return self.monthCount;
        case 2: return self.dayCount;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSString *text = [NSString stringWithFormat:@"%ld", self.lowerLimitYear+row];
        if (self.isShowToday &&
            text.integerValue == self.thisYear &&
            self.defaultYear == self.thisYear &&
            self.defaultMonth == self.thisMonth &&
            (self.mode == ITDatePickerModeYearAndMonthAndDay && self.defaultDay == self.thisDay)) {
            text = @"至今";
        }
        return text;
    } else if (component == 1){
        if (self.isHideMonth && self.thisMonth == row+1) {
            return @"--";
        }
        return [NSString stringWithFormat:@"%ld", row+1];
    } else {
        if (self.isHideMonth && self.thisDay == row+1) {
            return @"--";
        }
        return [NSString stringWithFormat:@"%ld", row+1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.defaultYear = row+self.lowerLimitYear;
            break;
        case 1: {
            self.defaultMonth = row+1;
            break;
        }
        case 2: {
            self.defaultDay = row+1;
            break;
        }
        default:
            break;
    }
    
    if (self.defaultYear < self.minimumYear) {
        self.defaultYear = self.minimumYear;
        [self.pickerView selectRow:(self.defaultYear-self.lowerLimitYear) inComponent:0 animated:YES];
        
        if (self.defaultMonth < self.minimumMonth) {
            self.defaultMonth = self.minimumMonth;
            [self.pickerView selectRow:(self.defaultMonth-1) inComponent:1 animated:YES];
            
            if (self.defaultDay < self.minimumDay && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.minimumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        }
    } else if ( self.defaultYear == self.minimumYear) {
        
        if (self.defaultMonth < self.minimumMonth) {
            self.defaultMonth = self.minimumMonth;
            [self.pickerView selectRow:(self.defaultMonth-1) inComponent:1 animated:YES];
            
            if (self.defaultDay < self.minimumDay  && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.minimumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        } else if (self.defaultMonth == self.minimumMonth){
            if (self.defaultDay < self.minimumDay  && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.minimumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        }
    }
    
    
    if (self.defaultYear > self.maximumYear) {
        self.defaultYear = self.maximumYear;
        [self.pickerView selectRow:(self.defaultYear-self.lowerLimitYear) inComponent:0 animated:YES];
        
        if (self.defaultMonth > self.maximumMonth) {
            self.defaultMonth = self.maximumMonth;
            [self.pickerView selectRow:(self.defaultMonth-1) inComponent:1 animated:YES];
            
            if (self.defaultDay > self.maximumDay  && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.maximumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        }
    } else if ( self.defaultYear == self.maximumYear) {
        
        if (self.defaultMonth > self.maximumMonth) {
            self.defaultMonth = self.maximumMonth;
            [self.pickerView selectRow:(self.defaultMonth-1) inComponent:1 animated:YES];
            
            if (self.defaultDay > self.maximumDay  && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.maximumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        } else if (self.defaultMonth == self.maximumMonth){
            if (self.defaultDay > self.maximumDay  && self.mode == ITDatePickerModeYearAndMonthAndDay) {
                self.defaultDay = self.maximumDay;
                [self.pickerView selectRow:(self.defaultDay-1) inComponent:2 animated:YES];
            }
        }
    }
    
    if (self.isShowToday) {
        if ( self.defaultYear == self.thisYear &&
            self.defaultMonth == self.thisMonth &&
            self.defaultDay == self.thisDay) {
            self.hideMonth = YES;
        } else {
            self.hideMonth = NO;
        }
        [self.pickerView reloadAllComponents];
    }
}


#pragma mark - Custom Accessors
#pragma mark -

- (void)setShowOutsideDate:(BOOL)showOutsideDate {
    _showOutsideDate = showOutsideDate;
    if (showOutsideDate) {
        self.limitYear = 2200;
        self.lowerLimitYear = 1900;
        self.yearCount = self.limitYear - self.lowerLimitYear+1;
    } else {
        [self setMaximumDate:_maximumDate];
        [self setMinimumDate:_minimumDate];
        self.limitYear = self.maximumYear;
        self.lowerLimitYear = self.minimumYear;
    }
}

- (void)setDefaultYear:(NSInteger)defaultYear {
    if (defaultYear> self.limitYear) {
        _defaultYear = self.limitYear;
    } else if (defaultYear < self.lowerLimitYear) {
        _defaultYear = self.lowerLimitYear;
    } else {
        _defaultYear = defaultYear;
    }
}

- (void)setDefaultMonth:(NSInteger)defaultMonth {
    if (defaultMonth> 12) {
        _defaultMonth = 12;
    } else if (defaultMonth < 1) {
        _defaultMonth = 1;
    } else {
        _defaultMonth = defaultMonth;
    }
}

- (void)setDefaultDay:(NSInteger)defaultDay {
    if (defaultDay> 31) {
        _defaultDay = 31;
    } else if (defaultDay < 1) {
        _defaultDay = 1;
    } else {
        _defaultDay = defaultDay;
    }
}

- (void)setMinimumYear:(NSInteger)minimumYear {
    _minimumYear = minimumYear;
    self.yearCount = _maximumYear - _minimumYear+1;
}

- (void)setMaximumYear:(NSInteger)maximumYear {
    _maximumYear = maximumYear;
    self.yearCount = _maximumYear - _minimumYear+1;
}

- (void)setMaximumDate:(NSString *)maximumDate {
    
    if ([_maximumDate isEqualToString:maximumDate] || maximumDate.length == 0) {
        return;
    }
    
    _maximumDate = [maximumDate copy];
    
    NSArray *date = [_maximumDate componentsSeparatedByString:@"."];
    if (date.count < 2) {
        return;
    }
    
    self.maximumYear = [date[0] integerValue];
    self.maximumMonth = [date[1] integerValue];
    
    if (self.mode == ITDatePickerModeYearAndMonthAndDay) {
        self.maximumDay = [date[2] integerValue];
    }
}

- (void)setMinimumDate:(NSString *)minimumDate {
    
    if ([_minimumDate isEqualToString:minimumDate] || minimumDate.length == 0) {
        return;
    }
    
    _minimumDate = [minimumDate copy];
    
    NSArray *date = [_minimumDate componentsSeparatedByString:@"."];
    if (date.count < 2) {
        return;
    }
    
    self.minimumYear = [date[0] integerValue];
    self.minimumMonth = [date[1] integerValue];
    if (self.mode == ITDatePickerModeYearAndMonthAndDay) {
        self.minimumDay = [date[2] integerValue];
    }
    
    [self setShowOutsideDate:_showOutsideDate];
}

- (void)setDefaultDate:(NSString *)defaultDate {
    
    if ([_defaultDate isEqualToString:defaultDate] || defaultDate.length == 0) {
        return;
    }
    
    _defaultDate = [defaultDate copy];
    
    NSArray *date = [_defaultDate componentsSeparatedByString:@"."];
    if (date.count < 2) {
        return;
    }
    
    [self setDefaultYear:[date[0] integerValue]];
    [self setDefaultMonth:[date[1] integerValue]];
    if (self.mode == ITDatePickerModeYearAndMonthAndDay) {
        [self setDefaultDay:[date[2] integerValue]];
    }
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
        [_toolBar setItems:@[self.cancelButton, self.flexibleSpaceItem, self.confirmButton]];
        [_toolBar addSubview:self.line];
    }
    return _toolBar;
}

- (ITPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[ITPickerView alloc] initWithFrame:CGRectMake(0, 44, kITScreenWidth, 216)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
