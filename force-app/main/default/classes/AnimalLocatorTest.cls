@istest
private class AnimalLocatorTest {
    @istest static void animallocatormock1(){
        test.setMock(Httpcalloutmock.class, new animallocatormock());
        string result = AnimalLocator.getAnimalNameById(3);
        //string ExpectedResult = 'trailhead';
        //system.assertEquals(ExpectedResult, result);
    }
}