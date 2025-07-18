public class EXERCISE1 {
    
    public static Map<String, Integer> countNumberOfOccurrences(List<String> inputList) {
        
        Map<String, Integer> resultMap = new Map<String, Integer>();
        
        for (String s : inputList) {
            if (resultMap.containsKey(s)) {
                resultMap.put(s, resultMap.get(s)++);
            } else {
                resultMap.put(s, 1);
            }
        }
        
        return resultMap;
    }
}



// List<String> testList = new List<String>{
//     'Perla', 'Maria',
//     'Perla', 'Maria',
//     'Perla', 'Maria'
// };
// Map<String,Integer> testResultMap = Exercise1.countNumberOfOccurrences(testList);
// System.debug('Result map: ' + testResultMap);

