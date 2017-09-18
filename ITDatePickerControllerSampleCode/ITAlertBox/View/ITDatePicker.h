//
//  ITDatePicker.h
//  ITAlertBox
//
//  Created by Wit on 2017/9/15.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITAlertBox.h"

typedef NS_ENUM(NSUInteger, ITDatePickerMode) {
    ITDatePickerModeYearAndMonth,
    ITDatePickerModeYearAndMonthAndDay,
};

@interface ITDatePicker : ITAlertBox

@property (nonatomic) ITDatePickerMode mode;

/**
 The maximum date defaults to December 2100.12.31
 */
@property (copy, nonatomic) NSString *maximumDate;

/**
 You can set the default date or default year or defalut month
 The default select date is now
 */
@property (copy, nonatomic) NSString *defaultDate;

/**
 The minimum default date is January 1900.01.01
 */
@property (copy, nonatomic) NSString *minimumDate;

/**
 Whether to show "today", default is yes
 If today is displayed, the maximum date is now
 If you do not show today, the minimum date defaults to January 1900, the maximum date defaults to December 2100,
 */
@property (nonatomic, getter = isShowToday) BOOL showToday;

/**
 Whether to display the time outside the range, the default is not
 */
@property (nonatomic, getter=iSshowOutsideDate) BOOL showOutsideDate;

/**
 You can set the default date or default year or defalut month
 Default is this year
 minimumDate <= defaultYear <= maximumDate
 */
@property (nonatomic) NSInteger defaultYear;

/**
 You can set the default date or default year or defalut month
 Default is this month
 1 < defaultMonth < 12
 */
@property (nonatomic) NSInteger defaultMonth;

/**
 You can set the default date or default year or defalut month
 Default is this month
 1 < defaultMonth < 31
 */
@property (nonatomic) NSInteger defaultDay;

/**
 Refresh the data
 */
- (void)refreshData;

@end
