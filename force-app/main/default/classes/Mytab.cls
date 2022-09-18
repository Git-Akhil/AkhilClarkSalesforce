public class Mytab {
    public id positionID{get;set;}
    public list<Job_Application__c> jobappName{get;set;}
    public Mytab(ApexPages.StandardController controller){
        positionID = ApexPages.currentpage().getparameters().get('id');
        system.debug('----- positionID -----'+positionID);
        jobappName = [select name from Job_Application__c where Position__c =: positionID];
        system.debug('----- jobappName -----'+jobappName);
         system.debug('----- jobappName -----'+jobappName.size());
    }
    public Component.Apex.tabpanel getmyTabsJOB(){
        system.debug('----- positionID -----'+positionID);
        component.Apex.TabPanel MyTabPanel = new component.Apex.TabPanel();
        for(Job_Application__c jobObj :jobappName ){
            component.Apex.Tab ChildTab = new component.Apex.Tab();
            ChildTab.label = 'Tab--' + string.valueOf(jobObj.Name);
            MyTabPanel.ChildComponents.add(ChildTab);
        }
        return MyTabPanel;
    }
    public Component.Apex.pageBlock getMysection(){
        component.Apex.pageBlock MyBlock = new component.Apex.pageBlock();
        for(Job_Application__c jobObj :jobappName){
            component.Apex.pageBlockSection Mysection = new component.Apex.pageBlockSection();
            Mysection.Title = jobObj.name;
            
            MyBlock.Childcomponents.add(Mysection);
        }
        return MyBlock;
    }
}