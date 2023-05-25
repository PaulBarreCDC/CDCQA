public class FunctionUtil {
    public static String join(List<String> toJoin, String delimiter) {
        Integer lim = toJoin.size();
        Integer count = 0;
        String result = '';
        for(String str : toJoin) {
            count++;
            if(count != lim) {
                result += str + ',';
            } else {
                result += str;
            }
        }
        return result;
    }
    public static String join(Set<String> toJoin, String delimiter) {
        return join(new List<String>(toJoin), delimiter);
    }
    public static Map<String,Object> unwrapSObject(Map<String,Object> sObjFieldMap,String fieldPrefix) {
        Map<String,Object> sObjMap = new Map<String,Object>();
        if(sObjFieldMap != null && sObjFieldMap.size() > 0) {
            for(String fieldName : sObjFieldMap.keySet()) {
                String key = String.isBlank(fieldPrefix) ? fieldName : fieldPrefix + '.' + fieldName;
                Object value = sObjFieldMap.get(fieldName);
                if(value instanceof sObject) {
                    sObjMap.putAll(
                        unwrapSObject(
                            ((sObject)value).getPopulatedFieldsAsMap(),
                            key
                        )
                    );
                } else if(value instanceof Map<String,Object>) {
                    sObjMap.putAll(
                        unwrapSObject(
                            (Map<String,Object>)value,
                            key
                        )
                    );
                } else {
                    sObjMap.put(
                        key,
                        value
                    );
                }
            }
        }
        return sObjMap;
    }
}