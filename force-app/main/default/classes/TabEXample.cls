public class TabEXample {
    public string selectedTab{get;set;}
    public List<Account> acc{get;set;}
    public List<Contact> Con{get;set;}
    public List<Contact> Conid{get;set;}
    public pagereference method1(){
        selectedTab = 'One';
        acc = [select name from Account];
        return null;
    }
    public pagereference method2(){
        selectedTab = 'Two';
        Conid = [select id from Contact];
        return null;
    }
    public pagereference method3(){
        selectedTab = 'Three';
        Con = [select name from Contact];
        return null;
    }
}