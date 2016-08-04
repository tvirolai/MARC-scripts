
package marcbatchreporter.reporters;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import marcbatchreporter.checks.Check;
import org.marc4j.marc.Record;

/**
 *
 * @author Tuomo Virolainen <tuomo.virolainen@helsinki.fi>
 */
public class Selma extends Reporter {
    
    HashMap<String, Integer> stats020 = new HashMap<>();
    HashMap<String, Integer> stats338 = new HashMap<>();
    
    public Selma(String inputfile, String outputfile) throws Exception {
        super(inputfile, outputfile);
    }
    
    @Override
    public void runChecks() {
        try {
            String dir = "/home/tuomo/RDA_konversio/Selma/reports/";
            
            Writer report_isbnChanges = new Writer(dir + "report_isbnChanges.txt");
            Writer idList_isbnChanges = new Writer(dir + "idList_isbnChanges.txt");
            Writer idList_530 = new Writer(dir + "idList_530.txt");
            Writer idList_856 = new Writer(dir + "idList_856.txt");
            Writer report_multiple338 = new Writer(dir + "report_multiple338.txt");
            Writer idList_multiple338 = new Writer(dir + "idList_multiple338.txt");
            Writer records_multiple338 = new Writer(dir + "records_multiple338.txt");
            Writer records_530 = new Writer(dir + "records_530.txt");
            Writer records_856 = new Writer(dir + "records_856.txt");

            int recNo = 0;
            while (super.inputreader.hasNext()) {
                recNo++;
                Record inputrecord = super.inputreader.next();
                Record outputrecord = super.outputreader.next();
                Check checker = new Check(inputrecord, outputrecord);
                String id = outputrecord.getControlNumber();
                
                // Check if 020 has changed
                if (checker.hasChanged("020")) {
                    super.putToHashMap(this.stats020, checker.toString());
                    idList_isbnChanges.writeLineToFile(id);
                }
                
                // Check if output contains multiple carrier types
                
                if (checker.outputContainsMultiple("338")) {
                    super.putToHashMap(this.stats338, checker.getOutputFields("338"));
                    idList_multiple338.writeLineToFile(id);
                    records_multiple338.writeChanges(id, inputrecord.toString(), outputrecord.toString());
                }
                
                // Check if 530 contains phrase "internet-julkaisu"
                
                if (checker.outputFieldContainsPhrase("530", "ternet-julkaisu")) {
                    idList_530.writeLineToFile(id);
                    records_530.writeChanges(id, inputrecord.toString(), outputrecord.toString());
                }
                
                // Check if 856$z contains phrase "Linkki verkkoaineistoon"
                
                if (checker.outputFieldContainsPhrase("856", "inkki verkkoaineisto")) {
                    idList_856.writeLineToFile(id);
                    records_856.writeChanges(id, inputrecord.toString(), outputrecord.toString());
                }
            }
            
            report_isbnChanges.writeHashMapSortedByValue(stats020);
            report_multiple338.writeHashMapSortedByValue(stats338);
            
            report_isbnChanges.closeWriter();
            idList_isbnChanges.closeWriter();
            idList_530.closeWriter();
            idList_856.closeWriter();
            report_multiple338.closeWriter();
            idList_multiple338.closeWriter();
            records_multiple338.closeWriter();
            records_530.closeWriter();
            records_856.closeWriter();
            
            System.out.println("Done, read " + recNo + " records.");
            
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Selma.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(Selma.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
