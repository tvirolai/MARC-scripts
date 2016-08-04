
package marcbatchreporter.reporters;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Tuomo Virolainen <tuomo.virolainen@helsinki.fi>
 */
public class Writer {
    
    private final BufferedWriter writer;
    
    public Writer(String filename) throws FileNotFoundException {
        File fout = new File(filename);
        FileOutputStream fos = new FileOutputStream(fout);
        this.writer = new BufferedWriter(new OutputStreamWriter(fos));
    }
    
    public void writeToFile(String data) throws IOException {
        this.writer.write(data);
    }
    
    public void writeLineToFile(String data) throws IOException {
        this.writer.write(data + "\n");
    }
    
    public void closeWriter() throws IOException {
        this.writer.close();
    }
    
    public void writeChanges(String id, String input, String output) throws IOException {
        this.writeLineToFile("RECORD ID: " + id + "\n");
        this.writeLineToFile("INPUT:\n");
        this.writeLineToFile(input);
        this.writeLineToFile("\n");
        this.writeLineToFile("OUTPUT:\n");
        this.writeLineToFile(output);
        this.writeLineToFile("==============================");
    }
    
    public void writeHashMapSortedByValue(HashMap input) throws IOException {
        Map<String, Integer> sortedInput = sortByComparator(input);
        int i = 0;
        for (String x : sortedInput.keySet()) {
            i++;
            writeLineToFile("" + i + ".\t" + x + "\t" + input.get(x));
        }
    }
    
    private static Map<String, Integer> sortByComparator(Map<String, Integer> unsortMap) {

        // Convert Map to List
        List<Map.Entry<String, Integer>> list;
        list = new LinkedList<>(unsortMap.entrySet());

        // Sort list with comparator, to compare the Map values
        Collections.sort(list, (Map.Entry<String, Integer> o1, 
                Map.Entry<String, Integer> o2) -> {
            return (o2.getValue())
                    .compareTo(o1.getValue());
        });

        // Convert sorted map back to a Map
        Map<String, Integer> sortedMap = new LinkedHashMap<>();
        
        list.stream().forEach((entry) -> {
            sortedMap.put(entry.getKey(), entry.getValue());
        });
        
        return sortedMap;
    }

}
