//
//  EntryViewController.m
//  Journal
//
//  Created by Adam on 1/4/16.
//  Copyright © 2016 atecle. All rights reserved.
//

#import "EntryViewController.h"

NSString *const EntryViewControllerIdentifier = @"EntryViewController";

static NSInteger Margin = 20;

@interface EntryViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UITextView *entryTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;

@property (strong, nonatomic) Entry *editingEntry;
@property (nonatomic) BOOL drawerExpanded;

@end

@implementation EntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleTextView.delegate = self;
    self.entryTextView.delegate = self;
    self.drawerExpanded = false;
    
    [self updateUserInterface];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancelButtonPressed
{
    [self.delegate entryViewControllerDidCancel:self];
}

- (void) setEntry:(Entry *)entry
{
    self.editingEntry = entry;
    
    _entry = entry;
}

- (void)setEditingEntry:(Entry *)editingEntry
{
    _editingEntry = [editingEntry copy];
    [self updateUserInterface];
}

- (void)updateTitleTextView
{
    self.titleTextView.text = self.editingEntry.title;
    self.title = self.editingEntry.title;
}

- (void)updateEntryTextView
{
    self.entryTextView.text = self.editingEntry.text;
    NSInteger characterCount = [TwitterEncoder characterCountForTextLength:self.editingEntry.text.length numberOfPhotos:[self.editingEntry.photos count]];
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld", (long)characterCount];
}

- (void)updateUserInterface
{
    [self updateTitleTextView];
    [self updateEntryTextView];
    [self updateShowMoreButton];
}

- (void) doneButtonPressed
{
    if (self.editingEntry.entryID == 0)
    {
        [self.delegate entryViewController:self didCreateEntry:self.editingEntry];
    }
    else
    {
        [self.delegate entryViewController:self didUpdateEntry:self.editingEntry];
    }
}

- (IBAction)showMoreButtonPressed:(id)sender
{
    if (!self.drawerExpanded)
    {
        [self.showMoreBtn setTitle:NSLocalizedString(@"Hide Photos", nil) forState:UIControlStateNormal];
        [self populateDrawer];
    }
    else
    {
        [self animatePhotoDrawerExpansionToHeight:0];
        [self.showMoreBtn setTitle:NSLocalizedString(@"Show More", nil) forState:UIControlStateNormal];
    }
    
    self.drawerExpanded = !self.drawerExpanded;
}

- (void)populateDrawer
{
    for (UIImage *image in self.editingEntry.photos)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.containerView addSubview:imageView];
        
        [self addConstraintsToImageView:imageView];
        [self animatePhotoDrawerExpansionToHeight:[self scaledImageHeightforImageView:imageView]];
    }
}

- (void)animatePhotoDrawerExpansionToHeight:(NSInteger)height
{
    [UIView animateWithDuration:.3 animations:^{
        self.containerViewHeight.constant = height;
        [self.view layoutIfNeeded];
    }];
}

- (void)addConstraintsToImageView:(UIImageView *)imageView
{
    CGFloat newImageHeight = [self scaledImageHeightforImageView:imageView];
    
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.containerView attribute:NSLayoutAttributeLeft multiplier:1 constant:Margin];
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeRight multiplier:1 constant:Margin];
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:newImageHeight];
    
    [self.containerView addConstraint:leftMargin];
    [self.containerView addConstraint:rightMargin];
    [self.containerView addConstraint:topMargin];
    [self.containerView addConstraint:heightConstraint];
    [self.view layoutIfNeeded];
}

- (CGFloat)scaledImageHeightforImageView:(UIImageView *)imageView
{
    CGFloat screenWidth = CGRectGetWidth(self.view.frame) - (Margin * 2);
    CGFloat imageHeight = imageView.image.size.height;
    CGFloat imageWidth = imageView.image.size.width;
    CGFloat newImageHeight = (imageHeight * screenWidth)/imageWidth;
    
    return newImageHeight;
}

- (void)updateShowMoreButton
{
    if ([self.editingEntry.photos count] == 0)
    {
        self.showMoreBtn.enabled = NO;
        [self.showMoreBtn setTitle:NSLocalizedString(@"No Photos", nil) forState:UIControlStateNormal];
        [self.showMoreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        self.showMoreBtn.enabled = YES;
        [self.showMoreBtn setTitle:NSLocalizedString(@"Show More", nil) forState:UIControlStateNormal];
        [self.showMoreBtn setTitleColor:nil forState:UIControlStateNormal];
    }
}

- (IBAction)addPhotoButtonPressed:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView
{
    if (textView == self.titleTextView)
    {
        Entry *tempEditingEntry = [self.editingEntry copy];
        [tempEditingEntry updateTitle:self.titleTextView.text];
        self.editingEntry = tempEditingEntry;
    }
    else
    {
        Entry *tempEditingEntry = [self.editingEntry copy];
        [tempEditingEntry updateText:self.entryTextView.text];
        [self setEditingEntry:tempEditingEntry];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    Entry *tempEditingEntry = [self.editingEntry copy];
    NSMutableArray *temp = [tempEditingEntry.photos mutableCopy];
    [temp addObject:chosenImage];
    [tempEditingEntry updatePhotos:[temp copy]];
    self.editingEntry = tempEditingEntry;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
