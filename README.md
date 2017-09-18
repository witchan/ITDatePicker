# ITDatePickerController

仿UIDatePicker, 只显示年和月，可以设置最大日期，最小日期和默认日期，可以显示"至今"

Imitation UIDatePicker, only show the year and month, you can set the maximum date, minimum date, and the current default date, can show so "today"

# Sample code

 				
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
    
##[源码地址](https://github.com/witchan/ITDatePickerController)

![MacDown Screenshot](https://raw.githubusercontent.com/witchan/Picture/master/ITDatePickerController.gif)
