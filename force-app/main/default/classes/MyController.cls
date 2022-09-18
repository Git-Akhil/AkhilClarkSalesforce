public class MyController {
    
    public id SelectedAccount{ get; set; }
    public list<Contact> ContactsInformation { get; set; }
    
    public void accountclicked(){
        ContactsInformation = [select Firstname , Lastname from Contact where AccountID = :SelectedAccount];
    }
    
    public list<account> getMyaccounts() {
        return [select id,name , AccountNumber from Account order by lastModifiedDate desc Limit 10];
    }


}