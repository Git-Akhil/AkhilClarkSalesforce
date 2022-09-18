public class MyContactListController {
    public static list<Contact> getcontacts(id recordID){
        return [select Id, FirstName, LastName, Email, Phone From Contact Where AccountId = :recordId];
    }
}