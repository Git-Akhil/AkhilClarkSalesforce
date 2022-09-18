public class PositionStaticRecWithCandiExtension {
    Public Integer count{get;set;}
    
    public PositionStaticRecWithCandiExtension(ApexPages.StandardController controller) {
        count = 5;
        
    }
    public Component.Apex.pageBlockSection getPageBlockSectionWithTitle(){
        Component.Apex.pageBlockSection pageblocktitle = new Component.Apex.pageBlockSection();
        pageblocktitle.title = ' Mytitle';
         
        return pageblocktitle;
    }
    
}