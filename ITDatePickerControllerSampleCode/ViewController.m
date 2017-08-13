//
//  ViewController.m
//  ITDatePickerControllerSampleCode
//
//  Created by Wit on 2017/8/10.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ViewController.h"
#import "ITDatePickerController.h"

@interface ViewController ()
<ITDatePickerControllerDelegate>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

- (IBAction)startDateButtonOnClicked:(id)sender;

- (IBAction)endDateButtonOnClicked:(id)sender;

@end

@implementation ViewController

#pragma mark - IBActions

- (IBAction)startDateButtonOnClicked:(id)sender {
    
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 100;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = NO;                // Whether to show "today", default is yes
    datePickerController.defaultDate = self.startDate;  // Default date
    datePickerController.maximumDate = self.endDate;    // maxinum date
    
    [self presentViewController:datePickerController animated:YES completion:nil];
}

- (IBAction)endDateButtonOnClicked:(id)sender {
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 200;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = YES;               // Whether to show "today", default is yes
    datePickerController.defaultDate = self.endDate;    // Default date
    datePickerController.minimumDate = self.startDate;  // Minimum date
    
    [self presentViewController:datePickerController animated:YES completion:nil];
}

#pragma mark - ITDatePickerControllerDelegate

- (void)datePickerController:(ITDatePickerController *)datePickerController didSelectedDate:(NSDate *)date dateString:(NSString *)dateString {
    
    NSInteger tag = datePickerController.tag;
    UIButton *button = [self.view viewWithTag:tag];
    [button setTitle:dateString forState:UIControlStateNormal];
    if (datePickerController.tag == 100) {
        self.startDate = date;
    } else {
        self.endDate = date;
    }
}

@end
