
package marcbatchreporter.reporters;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.marc4j.MarcReader;
import org.marc4j.MarcStreamReader;

/**
 *
 * @author Tuomo Virolainen <tuomo.virolainen@helsinki.fi>
 */
public abstract class Reporter {
    
    public final MarcReader inputreader;
    public final MarcReader outputreader;
    
    public Reporter(String inputfile, String outputfile) throws Exception {
        InputStream input = new FileInputStream(inputfile);
        InputStream output = new FileInputStream(outputfile);
        this.inputreader = new MarcStreamReader(input);
        this.outputreader = new MarcStreamReader(output);
    }
    
    /**
     *
     */
    public abstract void runChecks();
    
    public void putToHashMap(HashMap<String, Integer> hp, String data) {
        if (!hp.containsKey(data)) {
            hp.put(data, 1);
        } else {
            hp.put(data, hp.get(data) + 1);
        }
    }
    
}
