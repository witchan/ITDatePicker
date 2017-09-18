//
//  ITPickerView.m
//  ITAlertBox
//
//  Created by Wit on 2017/9/16.
//  Copyright © 2017年 Wit. All rights reserved.
//

#import "ITPickerView.h"
#import <objc/runtime.h>

static NSInteger kMaxCount = 1000;

@interface ITPickerView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

@property (strong, nonatomic) id<UIPickerViewDelegate> lastDelegate;
@property (strong, nonatomic) id<UIPickerViewDataSource> lastDataSource;

@property (strong, nonatomic) NSMutableDictionary *allRowsCount;

@end

@implementation ITPickerView

#pragma mark - Init

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSNumber *component in self.allRowsCount.allKeys) {
            [self defaultSelectRow:0 inComponent:[component integerValue] animated:NO];
        }
    });
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.lastDataSource numberOfComponentsInPickerView:pickerView];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rowsCount = [self.lastDataSource pickerView:pickerView numberOfRowsInComponent:component];
    [self.allRowsCount setObject:@(rowsCount) forKey:@(component)];
    return kMaxCount;
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView
                      titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component {
    NSInteger rowsCount = [self.allRowsCount[@(component)] integerValue];
    NSInteger index = row % rowsCount;
    return [self.lastDelegate pickerView:pickerView titleForRow:index forComponent:component];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if (row <50 || row > 950) {
        [self defaultSelectRow:row inComponent:component animated:NO];
    }
    
    NSInteger rowsCount = [self.allRowsCount[@(component)] integerValue];
    NSInteger index = row % rowsCount;
    [self.lastDelegate pickerView:pickerView didSelectRow:index inComponent:component];
}

#pragma mark - Private

- (void)defaultSelectRow:(NSInteger)row
             inComponent:(NSInteger)component animated:(BOOL)animated{
    
    if (self.allRowsCount.allKeys.count == 0) {
        [super selectRow:row inComponent:component animated:animated];
        return;
    }
    
    NSInteger rowsCount = [self.allRowsCount[@(component)] integerValue];
    NSInteger selectRow = (kMaxCount/2)/rowsCount*rowsCount + row;

    [super selectRow:selectRow inComponent:component animated:animated];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
    [self defaultSelectRow:row inComponent:component animated:animated];
}

#pragma mark - Custom Accessors

- (NSMutableDictionary *)allRowsCount {
    if (!_allRowsCount) {
        _allRowsCount = [NSMutableDictionary dictionary];
    }
    return _allRowsCount;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    [super setDelegate:self];
    _lastDelegate = delegate;
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    [super setDataSource:self];
    _lastDataSource = dataSource;
}

@end
