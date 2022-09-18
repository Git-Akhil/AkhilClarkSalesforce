public class AwesomeCalculator {
    public static double add(double x,double y){
        calculatorServices.CalculatorImplPort calculator = new calculatorServices.CalculatorImplPort();
        return calculator.doAdd(x, y);
    }
}