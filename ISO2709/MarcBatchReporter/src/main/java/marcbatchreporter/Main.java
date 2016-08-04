
package marcbatchreporter;

import marcbatchreporter.reporters.Selma;

/**
 *
 * @author Tuomo Virolainen <tuomo.virolainen@helsinki.fi>
 */

public class Main {
    
    public static void main(String[] args) throws Exception {
        String dir = "/home/tuomo/RDA_konversio/Selma";
        String inputfile = dir + "/parlexp.mrc";
        String outputfile = dir + "/parlimp.mrc";
        Selma selma = new Selma(inputfile, outputfile);
        selma.runChecks();
    }

}
