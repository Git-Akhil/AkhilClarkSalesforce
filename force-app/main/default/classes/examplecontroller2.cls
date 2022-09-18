public class examplecontroller2 {
    public List<Data> getData() {
        system.debug('----- inside get data -----');
       List<Data> data = new List<Data>();
        System.debug('----- data list -----'+data);
       data.add(new Data('Jan', 30, 90, 55));

       data.add(new Data('Feb', 44, 15, 65));

       data.add(new Data('Mar', 25, 32, 75));

       data.add(new Data('Apr', 74, 28, 85));

       data.add(new Data('May', 65, 51, 95));

       data.add(new Data('Jun', 33, 45, 99));

       data.add(new Data('Jul', 10, 82, 60));

       data.add(new Data('Aug', 87, 73, 45));

       data.add(new Data('Sep', 34, 65, 55));

       data.add(new Data('Oct', 78, 66, 56));

       data.add(new Data('Nov', 80, 67, 53));

       data.add(new Data('Dec', 17, 70, 70));
        system.debug('----- inside class data list of data ----'+data);
       return data;

   }
    
   // Wrapper class

   public class Data {

       public String name { get; set; }

       public Integer data1 { get; set; }

       public Integer data2 { get; set; }

       public Integer data3 { get; set; }
       

       public Data(String name, Integer data1, Integer data2, Integer data3) {

           this.name = name;

           this.data1 = data1;

           this.data2 = data2;

           this.data3 = data3;

       }

   }
}