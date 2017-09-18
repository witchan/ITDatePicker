//
//  ViewController.m
//  ITDatePickerDemo
//
//  Created by Wit on 2017/8/10.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ViewController.h"
#import "ITDatePicker.h"
#import "ITContainerController.h"

@interface ViewController ()
<ITAlertBoxDelegate>

@property (strong, nonatomic) NSString *startDate;
@property (strong, nonatomic) NSString *endDate;

- (IBAction)startDateButtonOnClicked:(id)sender;

- (IBAction)endDateButtonOnClicked:(id)sender;

@end

@implementation ViewController

#pragma mark - IBActions

- (IBAction)startDateButtonOnClicked:(id)sender {
    
    ITDatePicker *datePicker = [[ITDatePicker alloc] init];
    datePicker.tag = 100;
    datePicker.delegate = self;
    datePicker.showToday = NO;
    datePicker.defaultDate = self.startDate;
    datePicker.maximumDate = self.endDate;
    datePicker.showOutsideDate = YES;
    
    ITContainerController *controller = [[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)endDateButtonOnClicked:(id)sender {
    ITDatePicker *datePicker = [[ITDatePicker alloc] init];
    datePicker.tag = 200;
    datePicker.delegate = self;
    datePicker.showToday = YES;
    datePicker.defaultDate = self.endDate;
    datePicker.minimumDate = self.startDate;
    datePicker.showOutsideDate = YES;
    
    ITContainerController *controller = [[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ITAlertBoxDelegate

- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(NSString *)dateString {
    NSInteger tag = alertBox.tag;
    UIButton *button = [self.view viewWithTag:tag];
    [button setTitle:dateString forState:UIControlStateNormal];
    if (tag == 100) {
        self.startDate = dateString;
    } else {
        self.endDate = dateString;
    }
    
}

@end
