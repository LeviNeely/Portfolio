
import java.util.HashMap;

public class DNSCache {
    public HashMap<DNSQuestion, DNSRecord> localCache;

    /**
     * Constructor
     */
    public DNSCache() {
        localCache = new HashMap<>();
    }

    /**
     * A method to check if the cache contains the question being asked
     * @param question the question to be searched for
     * @return true if the cache contains the question
     */
    public boolean contains(DNSQuestion question) {
        //If it is contained and is not expired
        if (localCache.containsKey(question) && !localCache.get(question).isExpired()) {
            return true;
        }
        //If it is contained and is expired
        else if (localCache.containsKey(question) && localCache.get(question).isExpired()) {
            removeEntry(question);
            System.out.println("File not found");
            return false;
        }
        //If it is not contained
        System.out.println("File not found");
        return false;
    }

    /**
     * Method to add a question and record to the cache
     * @param question the key
     * @param record the value being stored with the key
     */
    public void addEntry(DNSQuestion question, DNSRecord record) {
        localCache.put(question, record);
    }

    /**
     * Method to remove a question key and all it's values
     * @param question the question to be removed
     */
    public void removeEntry(DNSQuestion question) {
        localCache.remove(question);
    }

    /**
     * Method used to return a value assigned to a specified key
     * @param question the key to be searched
     * @return the DNSRecord assigned to that key
     */
    public DNSRecord getRecord(DNSQuestion question) {
        return localCache.get(question);
    }
}
