@isTest
public class FunctionUtilTest {
    static testmethod void testFunctions() {
        List<String> stuffList = new List<String>{'1','2','3'};
        Set<String> stuffSet = new Set<String>{'1','2','3'};
        String delimiter = ',';
        System.assertEquals(FunctionUtil.join(stuffList,delimiter), '1,2,3');
        System.assertEquals(FunctionUtil.join(stuffSet,delimiter), '1,2,3');
    }
    static testmethod void testUnwrap() {
        Map<String,Object> baseMap = new Map<String,Object>{
            'a' => (Object)1,
            'b' => (Object)2
        };
        Map<String,Object> subMap1 = new Map<String,Object>{
            'd' => (Object)3
        };
        Map<String,Object> subMap2 = new Map<String,Object>{
            'f' => (Object)4
        };
        subMap1.put('e',subMap2);
        baseMap.put('c',subMap1);
        Map<String,Object> unwrapMap = FunctionUtil.unwrapSObject(baseMap,null);
        List<String> keyList = new List<String>{'a','b','c.d','c.e.f'};
        System.debug(unwrapMap);
        System.assertEquals(keyList,new List<String>(unwrapMap.keySet()));
    }
}