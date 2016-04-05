package recReader;

import java.io.*;
import java.util.ArrayList;

public class Database {
	
	private ArrayList<Record> tietueet;
	private final String outputFile;
	
	public Database(String outputfile) {
		this.tietueet = new ArrayList<>();
		this.outputFile = outputfile;
	}
	
	public void addRecord(Record record) {
		this.tietueet.add(record);
	}
	
	public void printRecs() {
		for (Record x: tietueet) {
			System.out.println(x.getId());
		}
	}
	
	public int recCount() {
		return this.tietueet.size();
	}
	
	public void writeReport() {
		try (Writer writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(this.outputFile), "utf-8"))) {
			writer.write("The file contains " + this.recCount() + " records with no 338 (discarding supplements):\n\n");
			for (Record x : tietueet) {
				writer.write(x.getId() + "\n");
			}
		} catch (Exception e) {
			System.out.println("Write error.");
		}
	}
}
