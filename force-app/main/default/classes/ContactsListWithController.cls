public class ContactsListWithController {
    Private string SortOrder = 'LastName';
    Public List<Contact> getcontacts(){
        List<Contact> result= Database.Query('Select ID,FirstName,LastName,Title,Email from Contact Order By '+ SortOrder + ' ASC Limit 10 ');
      return result;
    }
    public void setByFirstName(){
        This.SortOrder = 'FirstName';
    }
    Public void SetByLastName(){
        This.SortOrder = 'LastName';
    }
    
}