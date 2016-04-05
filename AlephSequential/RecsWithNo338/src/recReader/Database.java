package recReader;

import java.io.*;
import java.util.ArrayList;

public class Database {
	
	private ArrayList<String> no338Ids;
	private final String outputFile;
	
	public Database(String outputfile) {
		this.no338Ids = new ArrayList<>();
		this.outputFile = outputfile;
	}
	
	public void addRecord(Record record) {
		this.no338Ids.add(record.getId());
	}
	
	public void printRecs() {
		for (String id: no338Ids) {
			System.out.println(id);
		}
	}
	
	public int recCount() {
		return this.no338Ids.size();
	}
	
	public void writeReport() {
		try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(this.outputFile), "utf-8"))) {
			writer.write("The file contains " + this.recCount() + " records with no 338 (discarding supplements):\n\n");
			for (String id : no338Ids) {
				writer.write(id + "\n");
			}
		} catch (Exception e) {
			System.out.println("Write error.");
		}
	}
}
