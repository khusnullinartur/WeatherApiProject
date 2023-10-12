@IsTest
private class WeatherWidgetControllerTest {
    private static String NY_ZIP_CODE = '10001';
    private static String DUMMY_ZIP_CODE = 'q1q1q1q1';

    private static String RESPONSE_BODY_SUCCESS = 'SUCCESS';
    private static String RESPONSE_BODY_ERROR = '{"error":{"code":1006,"message":"No matching location found."}}';

    private static Integer STATUS_CODE_ERROR = 400;

    @TestSetup
    static void setup() {
        insert new Weather_API_Settings__c(Forecast_Num_of_Days__c = 5, Forecast_Path__c = '/forecast.json');
    }

    @IsTest
    static void getForecastPositiveTest() {
        Test.setMock(HttpCalloutMock.class, new TestCalloutMock(RESPONSE_BODY_SUCCESS, Constants.STATUS_CODE_SUCCESS));

        Test.startTest();
        String response = WeatherWidgetController.getForecast(NY_ZIP_CODE);
        Test.stopTest();

        Assert.areEqual(RESPONSE_BODY_SUCCESS, response);
    }

    @IsTest
    static void getForecastNegativeTest() {
        Test.setMock(HttpCalloutMock.class, new TestCalloutMock(RESPONSE_BODY_ERROR, STATUS_CODE_ERROR));

        String errorMessage = '';

        Test.startTest();
        try {
            WeatherWidgetController.getForecast(DUMMY_ZIP_CODE);
        } catch (Exception ex) {
            errorMessage = ex.getMessage();
        }
        Test.stopTest();

        Assert.areEqual('Script-thrown exception', errorMessage);
    }

    public class TestCalloutMock implements HttpCalloutMock {

        public String body;
        public Integer statusCode;

        public TestCalloutMock(String body, Integer statusCode) {
            this.body = body;
            this.statusCode = statusCode;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatusCode(statusCode);
            response.setBody(body);
            return response;
        }
    }
}