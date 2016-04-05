package recReader;

import java.util.Scanner;
import java.io.*;

public class Reader {
	
	public static void main(String[] args) {

		try {
			Database tietokanta = new Database("/home/tuomo/Melinda-dumppi/recsWithNo338.txt");
			int recs = 0;
			File file = new File("/home/tuomo/Melinda-dumppi/dumppi.seq");
			Scanner input = new Scanner(file);
			
			Record current = new Record(input.nextLine());
			
			while (input.hasNextLine()) {
				String line = input.nextLine();
				if (line.length() <= 13) {
					continue;
				}
				if (! current.isSame(line)) {
					if (current.isErroneous()) {
						tietokanta.addRecord(current);
					}
					recs++;
					current = new Record(line);
					if (recs % 1000 == 0) {
						System.out.println("Recs read: " + recs);
					}
				}
				current.addTag(line);
				//System.out.println(line);
			}
			input.close();
			System.out.println("Read " + recs + " records.");
			System.out.println("" + tietokanta.recCount() + " dubious recs found.");
			tietokanta.writeReport();
			
		} catch (Exception e) {
			System.out.println("Error: " + e);
		}
	}
}