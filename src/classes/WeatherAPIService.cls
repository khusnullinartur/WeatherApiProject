public with sharing class WeatherAPIService {

    private static final String AIR_QUALITY = 'No';
    private static final String ALERT_DATA = 'No';

    public static String sendRequestToWeatherAPI(String zipCode) {
        Weather_API_Settings__c weatherApiSettings = Weather_API_Settings__c.getInstance();

        String payload = getPayload(zipCode, weatherApiSettings.Forecast_Num_of_Days__c);

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Weather_API' + weatherApiSettings.Forecast_Path__c + payload);
        req.setMethod(Constants.HTTP_Request_METHOD_GET);

        Http http = new Http();
        HttpResponse response = http.send(req);

        if(response.getStatusCode() == Constants.STATUS_CODE_SUCCESS) {
            return response.getBody();
        } else {
            ErrorWrapper errorWrapper = (ErrorWrapper) JSON.deserialize(response.getBody(), ErrorWrapper.class);
            throw new CalloutException(errorWrapper.error.message);
        }
    }

    private static String getPayload(String zipCode, Decimal numOfDays) {
        return '?q=' + zipCode +
                '&days=' + Integer.valueOf(numOfDays) +
                '&aqi=' + AIR_QUALITY +
                '&alerts=' + ALERT_DATA;
    }

    public class ErrorWrapper {
        @AuraEnabled
        public ErrorDetailsWrapper error;
    }

    public class ErrorDetailsWrapper {
        @AuraEnabled
        public String message;
    }

    public class CalloutException extends Exception {}
}