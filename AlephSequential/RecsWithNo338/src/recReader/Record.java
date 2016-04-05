package recReader;

import java.util.ArrayList;

public class Record {
	
	private final String id;
	private ArrayList<String> fields;
	
	public Record(String line) {
		this.id = this.idFromLine(line);
		this.fields = new ArrayList<>();
	}
	
	public String idFromLine(String line) {
		return line.substring(0, 9);
	}
	
	public String tagFromLine(String line) {
		return line.substring(10, 13);
	}
	
	public void addTag(String line) {
		this.fields.add(this.tagFromLine(line));
	}
	
	public boolean isSame(String line) {
		return this.id.equals(this.idFromLine(line));
	}
	
	public boolean isDeleted() {
		for (String line : fields) {
			if (line.equals("DEL")) {
				return true;
			}
		}
		
		return false;
	}
	
	public boolean has338() {
		for (String line : fields) {
			if (line.equals("338")) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isSupplement() {
		for (String line : fields) {
			if (line.equals("773")) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isErroneous() {
		return (! this.isSupplement() && ! this.has338() && ! this.isDeleted());
	}
	
	public String getId() {
		return this.id;
	}

}