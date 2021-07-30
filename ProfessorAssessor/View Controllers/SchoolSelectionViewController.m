#import "SchoolSelectionViewController.h"
#import "SchoolSelectionCell.h"
#import "Networker.h"

@interface SchoolSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<School *> *schools;
@property (nonatomic, strong) NSArray<School *> *filteredSchools;

@end

@implementation SchoolSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchSchools];
}

- (void)fetchSchools {
    [Networker
     fetchSchoolsWithCompletion:^(NSArray<School *> *_Nullable schools,
                                  NSError *_Nullable error) {
        if (schools) {
            self.schools = schools;
            self.filteredSchools = self.schools;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSchools.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolSelectionCell" forIndexPath:indexPath];

    School *school = self.filteredSchools[indexPath.row];
    [cell setSchool:school];

    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^
                                  BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id>
                                       *_Nullable bindings) {
            return [((School *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredSchools = [self.schools filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredSchools = self.schools;
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    School *school = self.filteredSchools[indexPath.row];

    [self.delegate didSelectSchool:school];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

@end
