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
    datePickerController.tag = 100;
    datePickerController.delegate = self;
    datePickerController.showToday = NO;
    datePickerController.defaultDate = self.startDate;
    datePickerController.maximumDate = self.endDate;
    
    [self presentViewController:datePickerController animated:YES completion:nil];
}

- (IBAction)endDateButtonOnClicked:(id)sender {
    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 200;
    datePickerController.delegate = self;
    datePickerController.showToday = YES;
    datePickerController.defaultDate = self.endDate;
    datePickerController.minimumDate = self.startDate;
    
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
