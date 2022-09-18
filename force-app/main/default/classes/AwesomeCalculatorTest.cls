@istest
public class AwesomeCalculatorTest {
    @istest static void testcallout(){
        test.setMock(WebserviceMock.class, new CalculatorCalloutMock());
        double x = 1.0;
        double y = 2.0;
        double result = AwesomeCalculator.add(x,y);
        system.assertEquals(3.0, result);
    }
}