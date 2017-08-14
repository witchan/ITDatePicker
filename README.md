# ITDatePickerController

仿UIDatePicker, 只显示年和月，可以设置最大日期，最小日期和默认日期，可以显示"至今"

Imitation UIDatePicker, only show the year and month, you can set the maximum date, minimum date, and the current default date, can show so "today"

# Sample code

    ITDatePickerController *datePickerController = [[ITDatePickerController alloc] init];
    datePickerController.tag = 100;                     // Tag, which may be used in delegate methods
    datePickerController.delegate = self;               // Set the callback object
    datePickerController.showToday = NO;                // Whether to show "today", default is yes
    datePickerController.defaultDate = self.startDate;  // Default date
    datePickerController.maximumDate = self.endDate;    // maxinum date
    
    [self presentViewController:datePickerController animated:YES completion:nil];

##[源码地址](https://github.com/witchan/ITDatePickerController)

![MacDown Screenshot](https://raw.githubusercontent.com/witchan/Picture/master/ITDatePickerController.gif)
