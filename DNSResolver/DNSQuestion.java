import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

public class DNSQuestion {
    private String QNAME;
    private short QTYPE;
    private short QCLASS;

    /**
     * Named constructor that decodes the question inside the client request
     * @param inputStream the stream used to read in the bytes of information
     * @param request the request that the question is a part of
     * @return the parsed DNSQuestion
     * @throws IOException
     */
    public static DNSQuestion decodeQuestion(InputStream inputStream, DNSMessage request) throws IOException {
        DNSQuestion question = new DNSQuestion();
        DataInputStream dataInputStream = new DataInputStream(inputStream);
        //Getting the domain name
        String [] pieces = request.readDomainName(inputStream);
        question.QNAME = request.joinDomainName(pieces);
        question.QTYPE = dataInputStream.readShort();
        question.QCLASS = dataInputStream.readShort();
        return question;
    }

    /**
     * Method to write the data from the DNSQuestion to a byte array output stream
     * @param outputStream the stream to write the data out to
     * @param domainNameLocations the hashmap storing the domain name and offset data
     * @throws IOException
     */
    public void writeBytes(ByteArrayOutputStream outputStream, HashMap<String, Integer> domainNameLocations) throws IOException {
        DataOutputStream dataOutputStream = new DataOutputStream(outputStream);
        //Since the offset should start at the next byte to be written out, we simply return the size of the current array
        int offSet = outputStream.size();
        domainNameLocations.put(QNAME, offSet);
        //Using the breakup method to return the pieces of the domain name
        String[] domainPieces = breakUp(QNAME);
        for (int i = 0; i < domainPieces.length; i++) {
            dataOutputStream.writeByte(domainPieces[i].length());
            dataOutputStream.write(domainPieces[i].getBytes());
        }
        //A zero tells the parser that the domain name is done, so we have to make sure it's written out
        dataOutputStream.writeByte(0);
        dataOutputStream.writeShort(QTYPE);
        dataOutputStream.writeShort(QCLASS);
    }

    /**
     * Simple helper method to break up a domain name
     * @param domain the string to be broken up
     * @return a string array with the pieces of the domain name
     */
    public String[] breakUp(String domain) {
        String[] pieces = domain.split("[.]");
        return pieces;
    }
    @Override
    public String toString() {
        return "DNSQuestion{" +
                "QNAME='" + QNAME + '\'' +
                ", QTYPE=" + QTYPE +
                ", QCLASS=" + QCLASS +
                '}';
    }

    @Override
    public int hashCode() {
        return Objects.hash(QNAME, QTYPE, QCLASS);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || this.getClass() != obj.getClass()) {
            return false;
        }

        DNSQuestion that = (DNSQuestion) obj;
        return this.QNAME.equals(that.QNAME) && this.QTYPE == that.QTYPE && this.QCLASS == that.QCLASS;
    }
}
