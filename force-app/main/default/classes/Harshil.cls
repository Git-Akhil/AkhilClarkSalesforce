public class Harshil {
    
    public Harshil(){
        
    }
    
    public Harshil(String methodvaluname){
        classvaluname = methodvaluname;
    }
    
    public Harshil(Integer methodNumber){
        
    }
    
    public String classvaluname;
    
    
    public static String AKHIL = 'AKHIL';
    
    public static String sayYou(String local){
        system.debug('Hi '+local);
        return 'Hi '+local;
    }
    public static void sayMe(){
        System.debug('----Me----');
    }
    
    public void call2(){
    }
    
    public String callInit(){
		return 'Hi '+classvaluname;
    }
}