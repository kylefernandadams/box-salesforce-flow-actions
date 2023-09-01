public with sharing class BoxRequestAction {
    public class BoxRequest {
        @InvocableVariable(label='Box Endpoint')
        public String boxEndpoint;

        @InvocableVariable(label='HTTP Method')
        public String httpMethod;

        @InvocableVariable(label='Content Type Header')
        public String contentTypeHeader;

        @InvocableVariable(label='Request Body')
        public String requestBody;
    }

    public class BoxResult {
        @InvocableVariable(label='HTTP Status Code')
        public Integer httpStatusCode;

        @InvocableVariable(label='HTTP Status')
        public String httpStatus;

        @InvocableVariable(label='HTTP Response Body')
        public String httpResponseBody;
    }


    @InvocableMethod(label='Send Request' category='Box' callout=true)
    public static List<BoxResult> sendRequest(List<BoxRequest> boxRequestList) {

        List<BoxResult> boxResultList = new List<BoxResult>();
        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = new BoxResult();

            String boxEndpoint = boxRequest.boxEndpoint;
            
            box.Toolkit boxToolkit = new box.Toolkit();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setMethod(boxRequest.httpMethod);
            httpRequest.setEndpoint(boxRequest.boxEndpoint);
            httpRequest.setBody(boxRequest.requestBody);
            httpRequest.setHeader('Content-Type', boxRequest.contentTypeHeader);

            HttpResponse httpResponse = boxToolkit.sendRequest(httpRequest);
            String responseBody = httpResponse.getBody();
            System.debug('Found response: ' + responseBody);

            boxResult.httpStatusCode = httpResponse.getStatusCode();
            boxResult.httpStatus = httpResponse.getStatus();
            boxResult.httpResponseBody = responseBody;

            boxResultList.add(boxResult);
        }
        return boxResultList;
    }
}