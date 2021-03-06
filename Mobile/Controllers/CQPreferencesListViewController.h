#import "CQTableViewController.h"

@class AVAudioPlayer;
@class CQPreferencesListEditViewController;
@class CQPreferencesListViewController;

typedef void (^CQPreferencesListBlock)(CQPreferencesListViewController *preferencesListViewController);

typedef enum {
	CQPreferencesListTypeNone,
	CQPreferencesListTypeAudio,
	CQPreferencesListTypeFont,
	CQPreferencesListTypeImage
} CQPreferencesListType;

@interface CQPreferencesListViewController : CQTableViewController {
	@protected
	NSMutableArray *_items;
	UIImage *_itemImage;
	NSString *_addItemLabelText;
	NSString *_noItemsLabelText;
	NSString *_editViewTitle;
	NSString *_editPlaceholder;
	NSUInteger _editingIndex;
	NSInteger _selectedItemIndex;
	CQPreferencesListEditViewController *_editingViewController;
	id _customEditingViewController;
	id _target;
	SEL _action;
	CQPreferencesListBlock _preferencesListBlock;
	BOOL _pendingChanges;
	BOOL _allowEditing;

	CQPreferencesListType _listType;

	AVAudioPlayer *_audioPlayer;
}
@property (nonatomic) BOOL allowEditing;
@property (nonatomic) NSInteger selectedItemIndex;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, retain) UIImage *itemImage;
@property (nonatomic, copy) NSString *addItemLabelText;
@property (nonatomic, copy) NSString *noItemsLabelText;
@property (nonatomic, copy) NSString *editViewTitle;
@property (nonatomic, copy) NSString *editPlaceholder;
@property (nonatomic, retain) id customEditingViewController;

@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;
@property (nonatomic, copy) CQPreferencesListBlock preferencesListBlock;

@property (nonatomic) CQPreferencesListType listType;
@end
