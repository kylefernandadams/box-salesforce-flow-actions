public with sharing class BoxJsonParser {
    public class BoxRequest {
        @InvocableVariable(label='JSON String')
        public String jsonString;

        @InvocableVariable(label='JSON Path Expression')
        public String jsonFieldName;
    }

    public class BoxResult {
        @InvocableVariable(label='Json Value')
        public String jsonValue;

    }


    @InvocableMethod(label='Get JSON Value' category='Box' callout=true)
    public static List<BoxResult> getJsonValue(List<BoxRequest> boxRequestList) {
        List<BoxResult> boxResultList = new List<BoxResult>();
        for(BoxRequest boxRequest: boxRequestList) {
            BoxResult boxResult = new BoxResult();
            List<String> jsonPath = boxRequest.jsonFieldName.split('\\.');
            JSONParser parser = JSON.createParser(boxRequest.jsonString);
            Integer index = 0;
            parser.nextToken();
            while(parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    if(jsonPath[index] == parser.getText()) {
                        if(index == jsonPath.size()-1) {
                            parser.nextToken();
                            boxResult.jsonValue = String.valueOf(parser.getText());
                        }else if(parser.nextToken() == JSONToken.START_OBJECT) {
                            index++;
                        }
                    }
                }else if(parser.getCurrentToken() == JSONToken.START_OBJECT || parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    goToEndOfJsonObject(parser);
                }
            }
            boxResultList.add(boxResult);
        }
        return boxResultList;
    }

    public static JSONParser goToEndOfJsonObject(JSONParser parser) {
        if(parser != null && parser.getCurrentToken() == JSONToken.START_ARRAY) {
            if(parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while(parser.getCurrentToken() != JSONToken.END_ARRAY) {
                    parser.nextToken();
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY ||  parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        goToEndOfJsonObject(parser);
                    }
                }
            }else if(parser.getCurrentToken() == JSONToken.START_OBJECT) {
                while(parser.getCurrentToken() != JSONToken.END_OBJECT) {
                    parser.nextToken();
                    if(parser.getCurrentToken() == JSONToken.START_ARRAY ||  parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        goToEndOfJsonObject(parser);
                    }
                }
            }
        }
        return parser;
    }
}