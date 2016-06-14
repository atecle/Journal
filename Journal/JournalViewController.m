//
//  ViewController.m
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "JournalViewController.h"
#import "EntryViewController.h"

static NSString *const CellIdentifier = @"Cell";

@interface JournalViewController () <UITableViewDataSource, UITableViewDelegate, EntryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) Journal *journal;

@end

@implementation JournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _journal = [[Journal alloc] init];
    Entry *entry = [[Entry alloc] initWithTitle:@"Title" photos:@[] text:@"Text" entryID:[self.journal.entries count]];
    [self.journal addEntry:entry];
    [self.tableView reloadData];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtnPressed:(id)sender
{
    EntryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:EntryViewControllerIdentifier];
    
    Entry *entry = [[Entry alloc] initWithTitle:NSLocalizedString(@"New Entry", nil) photos:@[] text:@"" entryID:0];
    vc.entry = entry;
    vc.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)dismissEntryViewController
{
    if (self.presentedViewController != nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.journal.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Entry *entry = [self.journal.entries objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:EntryViewControllerIdentifier];
    
    vc.delegate = self;
    vc.entry = [self.journal.entries objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - EntryViewControllerDelegate

- (void)entryViewController:(EntryViewController *)viewController didCreateEntry:(Entry *)entry
{
    NSInteger entryID = 1;
    
    for (Entry *entry in self.journal.entries)
    {
        entryID = MAX(entry.entryID, entryID + 1);
    }
    
    [entry updateEntryID:entryID];
    [self.journal addEntry:entry];
    [self.tableView reloadData];
    [self dismissEntryViewController];
}

- (void)entryViewController:(EntryViewController *)viewController didUpdateEntry:(Entry *)entry
{
    [self.journal updateEntry:entry];
    [self dismissEntryViewController];
}

- (void)entryViewControllerDidCancel:(EntryViewController *)viewController
{
    [self dismissEntryViewController];
}

@end
