#import "ProfessorSearchViewController.h"
#import "ProfessorViewController.h"
#import "ProfessorCell.h"

@interface ProfessorSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray<Professor *> *filteredProfessors;

@end

@implementation ProfessorSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfessorCell" bundle:nil] forCellReuseIdentifier:@"ProfessorCell"];

    [self.navigationItem setHidesBackButton:YES];

    self.filteredProfessors = self.professors;
    [self.tableView reloadData];

    [self.searchBar becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredProfessors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfessorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfessorCell" forIndexPath:indexPath];

    Professor *professor = self.filteredProfessors[indexPath.row];
    [cell setProfessor:professor];
    [cell configureBackground];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.delegate didSelectProfessor:weakSelf.filteredProfessors[indexPath.row]];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate
                                  predicateWithBlock:^
                                  BOOL(id _Nullable evaluatedObject,
                                       NSDictionary<NSString *,id>
                                       *_Nullable bindings) {
            return [((Professor *)evaluatedObject).name containsString:searchText];
        }];
        self.filteredProfessors = [self.professors filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredProfessors = self.professors;
    }
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
