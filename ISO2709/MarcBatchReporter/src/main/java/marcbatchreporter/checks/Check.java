
package marcbatchreporter.checks;

import org.marc4j.marc.Record;
import java.util.List;

/**
 *
 * @author Tuomo Virolainen <tuomo.virolainen@helsinki.fi>
 */
public class Check {
    
    public boolean faulty;
    private String input;
    private String output;
    private final Record inputrecord;
    private final Record outputrecord;
    
    public Check(Record inputrecord, Record outputrecord) {
        this.inputrecord = inputrecord;
        this.outputrecord = outputrecord;
        this.faulty = false;
        this.input = "";
        this.output = "";
    }
        
    public String toString() {
        return this.input + "\t" + this.output;
    }
    
    public boolean hasChanged(String field) {
        List inputfields = this.inputrecord.getVariableFields(field);
        List outputfields = this.outputrecord.getVariableFields(field);
        this.input = listToString(inputfields);
        this.output = listToString(outputfields);
        return !this.input.equals(this.output);
    }
    
    public boolean outputContainsMultiple(String field) {
        List outputfields = this.outputrecord.getVariableFields(field);
        return outputfields.size() > 1;
    }
    
    public String getOutputFields(String field) {
        List outputfields = this.outputrecord.getVariableFields(field);
        return listToString(outputfields);
    }
    
    public boolean outputFieldContainsPhrase(String field, String phrase) {
        List outputfields = this.outputrecord.getVariableFields(field);
        return this.listToString(outputfields).contains(phrase);
    }
    
    public String listToString(List list) {
        String string = "";
        for (Object x : list) {
            string += x.toString();
        }
        return string;
    }

}
