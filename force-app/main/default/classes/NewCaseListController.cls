public class NewCaseListController {
    Public List<Case> getNewCases(){
        List<Case> GiveList =Database.query('select id,CaseNumber from Case Where Status = \'New\' ');
        return GiveList;
}
}