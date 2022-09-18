public class examplecontroller {
    integer Count = 0;
    public PageReference incrementCounter() {
        count++;
        return null;
    }

    public integer getCount() {
        return count;
    }

}