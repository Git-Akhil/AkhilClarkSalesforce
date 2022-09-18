Public Class MyExtension{
    private Final Account acct;
    public MyExtension(Apexpages.standardController Controller){
        this.acct = (account)Controller.getRecord();
    }
    public String getTitle() {
        return 'Account: ' + acct.name + ' (' + acct.id + ')';
    }
}