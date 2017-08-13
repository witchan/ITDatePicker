//
//  ITDatePickerController.h
//  ITDatePickerControllerSampleCode
//
//  Created by Wit on 2017/8/10.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITDatePickerView;
@class ITDatePickerController;

@protocol ITDatePickerControllerDelegate <NSObject>

/**
 ITDatePickerController after the selection of the callback method
 @param date Select the date
 @param dateString Select the date string
 */
- (void)datePickerController:(nonnull ITDatePickerController *)datePickerController
             didSelectedDate:(nonnull NSDate *)date
                  dateString:(nonnull NSString *)dateString;

@end

/***************** ITDatePickerController *****************/

@interface ITDatePickerController : UIViewController

@property (nonatomic) NSInteger tag;

/**
The default includes the Cancel button
 */
@property (nullable ,copy, nonatomic) NSArray *leftItems;

/**
 The default includes the Done button
 */
@property (nullable, copy, nonatomic) NSArray *rightItems;

//@property (nonatomic, strong, readonly) UIToolbar *toolBar;

/**
 Use UIPickerView to customize datePickerView
 */
@property (nonnull, strong, nonatomic, readonly) ITDatePickerView *datePickerView;

/**
 Background view
 The default color is white:0 alpha:0.4
 */
@property (nonnull, strong, nonatomic, readonly) UIView *backgroundView;

/**
 The date picker controller delegate
 */
@property (nullable, weak, nonatomic) id<ITDatePickerControllerDelegate> delegate;

/**
The maximum date defaults to December 2100
 */
@property (nullable, weak, nonatomic) NSDate *maximumDate;

/**
You can set the default date or default year or defalut month
The default select date is now
 */
@property (nullable, weak, nonatomic) NSDate *defaultDate;

/**
The minimum default date is January 1900
 */
@property (nullable, weak, nonatomic) NSDate *minimumDate;

/**
 Whether to show "today", default is yes
 If today is displayed, the maximum date is now
 If you do not show today, the minimum date defaults to January 1900, the maximum date defaults to December 2100,
 */
@property (nonatomic, getter = isShowToday) BOOL showToday;

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
 Refresh the data
 */
- (void)refreshData;

@end


/***************** ITDatePickerView *****************/

@interface ITDatePickerView : UIView

/**
  The date picker controller delegate
  */
@property (nullable, weak, nonatomic) id<ITDatePickerControllerDelegate> delegate;

/**
 The default includes the Cancel button
 */
@property (nullable, copy, nonatomic) NSArray *leftItems;

/**
 The default includes the Done button
 */
@property (nullable, copy, nonatomic) NSArray *rightItems;

/**
 The maximum date defaults to December 2100
 */
@property (nullable, copy, nonatomic) NSDate *maximumDate;

/**
 You can set the default date or default year or defalut month
 The default select date is now
 */
@property (nullable, copy, nonatomic) NSDate *defaultDate;

/**
 The minimum default date is January 1900
 */
@property (nullable, copy, nonatomic) NSDate *minimumDate;

/**
 Whether to show "today", default is yes
 If today is displayed, the maximum date is now
 If you do not show today, the minimum date defaults to January 1900, the maximum date defaults to December 2100,
 */
@property (nonatomic, getter = isShowToday) BOOL showToday;

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
 Refresh the data
 */
- (void)refreshData;

@end

/***************** ITAnimation *****************/

@interface ITAnimation : NSObject
<UIViewControllerAnimatedTransitioning>

/**
 Whether it is presenting
 */
@property (nonatomic, getter=isPresenting) BOOL presenting;

/**
 Factory method, create transition animation

 @param isPresenting  Whether it is presenting
 @return transition animation object
 */
+ (nonnull instancetype)animationWithPresenting:(BOOL)isPresenting;

@end
