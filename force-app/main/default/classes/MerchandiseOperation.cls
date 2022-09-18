public class MerchandiseOperation {
    public static Id invoice(string pname , integer psold , string pdesc ){
        Merchandise__c m = [select Price__c,Total_Inventory__c from Merchandise__c where name = :pname limit 1];
        system.assertNotEquals(null, m);
        system.debug('merchandise m -- '+m);
        Invoice_Statement__c in1 = new Invoice_Statement__c(Description__c = pdesc);
        system.debug('invoice statement -- '+in1);
        insert in1;
        Line_Item__c li1 = new Line_Item__c(Name = '1', Invoice_Statement__c = in1.id , Merchandise__c = m.id , Unit_Price__c = m.Price__c , Units_Sold__c = psold);
        system.debug('units sold -- '+li1.Units_Sold__c);
        system.debug('line item -- '+li1);
        
        system.debug('total inventory -- '+m.Total_Inventory__c);
        insert li1;
        m.Total_Inventory__c =psold - m.Total_Inventory__c ;
        update m;
        system.debug('total inventory -- '+m.Total_Inventory__c);
        return in1.id;
    }

}