//
//  MTTableViewController.m
//  MobileTotoro
//
//  Created by 徐杨 on 15/11/30.
//  Copyright © 2015年 xuyang. All rights reserved.
//

#import "MTTableViewController.h"

// Macro
#import "MTMacro.h"

// Cell
#import "MTSummaryTableViewCell.h"
#import "MTChartTableViewCell.h"

// Model
#import "MTPerformanceManager.h"

/*
 *  Sections
 */
typedef NS_ENUM(NSUInteger, eMTTableViewSection) {
    eMTTableViewSectionSummary = 0,
    eMTTableViewSectionChart,
    eMTTableViewSectionCount,
};

/*
 *  Rows of Chart Section
 */
typedef NS_ENUM(NSUInteger, eMTTableViewChartRow) {
    eMTTableViewChartRowCPU = 0,
    eMTTableViewChartRowMEM,
    eMTTableViewChartRowCount,
};

@interface MTTableViewController ()

@property (nonatomic) BOOL firstCPUFlag;
@property (nonatomic) BOOL firstMEMFlag;

@end

@implementation MTTableViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _firstCPUFlag = YES;
        _firstMEMFlag = YES;
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView属性
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundView.backgroundColor = kMTBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // 设置navigation属性
    [self.navigationItem setTitle:@"MobileTotoro"];
    
    // 添加一键清除按钮
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"一键清除"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clearAction)];
    self.navigationItem.rightBarButtonItem = clearItem;
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTableView:)
                                                 name:@"UpdateChartView"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateChartView" object:nil];
}

#pragma mark - Tableview DateSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return eMTTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nuoOfRow = 0;
    
    switch (section) {
        case eMTTableViewSectionSummary: {
            nuoOfRow = 1;
        }
            break;
        case eMTTableViewSectionChart: {
            nuoOfRow = eMTTableViewChartRowCount;
        }
            break;
    }
    
    return nuoOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForCell = 0.0;
    
    switch (indexPath.section) {
        case eMTTableViewSectionSummary: {
            heightForCell = kMTSummaryCellHeight;
        }
            break;
        case eMTTableViewSectionChart: {
            heightForCell = kMTChartCellHeight;
        }
            break;
    }
    
    return heightForCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case eMTTableViewSectionSummary: {
            static NSString *cellIdentifier = @"SummaryCell";
            MTSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[MTSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell updateSummaryCell];
            return cell;
        }
            break;
        case eMTTableViewSectionChart: {
            switch (indexPath.row) {
                case eMTTableViewChartRowCPU: {
                    static NSString *cellIdentifier = @"CPUChartCell";
                    MTChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[MTChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:eMTViewTypeCPU];
                    }
                    [cell updateChartCellWithFlag:_firstCPUFlag];
                    if (_firstCPUFlag) {
                        _firstCPUFlag = NO;
                    }
                    return cell;
                }
                    break;
                case eMTTableViewChartRowMEM: {
                    static NSString *cellIdentifier = @"MEMChartCell";
                    MTChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (!cell) {
                        cell = [[MTChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier type:eMTViewTypeMEM];
                    }
                    [cell updateChartCellWithFlag:_firstMEMFlag];
                    if (_firstMEMFlag) {
                        _firstMEMFlag = NO;
                    }
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightForHeader = 0.0;
    
    return heightForHeader;
}

- (void)updateTableView:(NSNotification *)notification{
    [self.tableView reloadData];
}

- (void)clearAction {
    [[MTPerformanceManager sharedInstance] clear];
}

@end
