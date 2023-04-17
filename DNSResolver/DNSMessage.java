import javax.xml.crypto.Data;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;

public class DNSMessage {
    private DNSHeader header;
    private ArrayList<DNSQuestion> questions;
    private ArrayList<DNSRecord> answers;
    private ArrayList<DNSRecord> authority;
    private ArrayList<DNSRecord> additional;
    private byte[] totalMessage;

    /**
     * Named constructor that decodes the message being parsed
     * @param bytes The byte array that contains the information
     * @return the parsed DNSMessage
     * @throws IOException
     */
    public static DNSMessage decodeMessage(byte[] bytes) throws IOException {
        DNSMessage message = new DNSMessage();
        message.questions = new ArrayList<>();
        message.answers = new ArrayList<>();
        message.authority = new ArrayList<>();
        message.additional = new ArrayList<>();
        message.totalMessage = bytes;
        ByteArrayInputStream allBytes = new ByteArrayInputStream(bytes);
        DataInputStream dataInputStream = new DataInputStream(allBytes);
        //Initializing the header
        message.header = DNSHeader.decodeHeader(dataInputStream);
        //Initializing each question displayed in the header
        if (message.header.getQDCOUNT() != 0) {
            for (int i = 0; i < message.header.getQDCOUNT(); i++) {
                DNSQuestion question = DNSQuestion.decodeQuestion(dataInputStream, message);
                message.questions.add(question);
            }
        }
        //Initializing each answer displayed in the header
        if (message.header.getANCOUNT() != 0) {
            for (int i = 0; i < message.header.getANCOUNT(); i++) {
                DNSRecord record = DNSRecord.decodeRecord(dataInputStream, message);
                message.answers.add(record);
            }
        }
        //Initializing each authority displayed in the header
        if (message.header.getNSCOUNT() != 0) {
            for (int i = 0; i < message.header.getNSCOUNT(); i++) {
                DNSRecord record = DNSRecord.decodeRecord(dataInputStream, message);
                message.authority.add(record);
            }
        }
        //Initializing each additional displayed in the header
        if (message.header.getARCOUNT() != 0) {
            for (int i = 0; i < message.header.getARCOUNT(); i++) {
                DNSRecord record = DNSRecord.decodeRecord(dataInputStream, message);
                message.additional.add(record);
            }
        }
        return message;
    }

    /**
     * A method to read a domain name from an input stream
     * @param inputStream the stream that is used to read in the domain name
     * @return a String[] containing the domain name pieces
     * @throws IOException
     */
    public String[] readDomainName(InputStream inputStream) throws IOException {
        DataInputStream dataInputStream = new DataInputStream(inputStream);
        //First byte tells the length of the string
        int length = dataInputStream.readByte();
        ArrayList<String> piecesList = new ArrayList<>();
        while (length != 0) {
            byte[] word = new byte[length];
            for (int i = 0; i < length; i++) {
                word[i] = dataInputStream.readByte();
            }
            piecesList.add(new String(word, StandardCharsets.UTF_8));
            //If the next byte is not zero, there are more strings, continue
            length = (dataInputStream.readByte());
        }
        String[] pieces = new String[piecesList.size()];
        for (int i = 0; i < piecesList.size(); i++) {
            pieces[i] = piecesList.get(i);
        }
        return pieces;
    }

    /**
     * Method to read the domain name starting from an initial byte
     * @param firstByte
     * @return
     * @throws IOException
     */
    public String[] readDomainName(int firstByte) throws IOException {
        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(totalMessage);
        byteArrayInputStream.skip(firstByte);
        return readDomainName(byteArrayInputStream);
    }

    /**
     * A named constructor to produce a new DNSMessage which will result in a new DNSMessage response
     * @param request the request we are responding to
     * @param allAnswers the arraylist of answers
     * @return a compiled DNSMessage response
     */
    public static DNSMessage buildResponse(DNSMessage request, ArrayList<DNSRecord> allAnswers) {
        DNSMessage response = new DNSMessage();
        response.header = request.getHeader();
        response.questions = request.getQuestions();
        response.answers = allAnswers;
        response.authority = request.getAuthority();
        response.additional = request.getAdditional();
        return response;
    }

    /**
     * A method to produce the byte array to be sent off to a different location
     * @return the byte[] needing to be sent
     * @throws IOException
     */
    public byte[] toBytes() throws IOException {
        HashMap<String, Integer> domainNameLocations = new HashMap<String, Integer>();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        header.writeBytes(byteArrayOutputStream);
        for (int i = 0; i < questions.size(); i++) {
            questions.get(i).writeBytes(byteArrayOutputStream, domainNameLocations);
        }
        for (int i = 0; i < answers.size(); i++) {
            answers.get(i).writeBytes(byteArrayOutputStream, domainNameLocations);
        }
        for (int i = 0; i < authority.size(); i++) {
            authority.get(i).writeBytes(byteArrayOutputStream, domainNameLocations);
        }
        for (int i = 0; i < additional.size(); i++) {
            additional.get(i).writeBytes(byteArrayOutputStream, domainNameLocations);
        }
        byte[] array = byteArrayOutputStream.toByteArray();
        return array;
    }

    //I decided to implement this functionality inside the DNSQuestion writeBytes method
//    public static void writeDomainName(ByteArrayOutputStream outputStream, HashMap<String, Integer> domainLocations, String[] domainPieces) {
//    }

    /**
     * Method to join up the pieces of a domain name with "."
     * @param pieces the pieces of the domain name
     * @return the string of the domain name (www.example.com)
     */
    public String joinDomainName(String[] pieces) {
        String QNAME = "";
        for (int i = 0; i < pieces.length; i++) {
            QNAME += pieces[i];
            if (i != pieces.length - 1) {
                QNAME += ".";
            }
        }
        return QNAME;
    }

    public ArrayList<DNSQuestion> getQuestions() {
        return questions;
    }

    public ArrayList<DNSRecord> getAnswers() {
        return answers;
    }

    public DNSHeader getHeader() {
        return header;
    }

    public ArrayList<DNSRecord> getAuthority() {
        return authority;
    }

    public ArrayList<DNSRecord> getAdditional() {
        return additional;
    }

    @Override
    public String toString() {
        return "DNSMessage{" +
                "header=" + header +
                ", questions=" + questions +
                ", answers=" + answers +
                ", authority=" + authority +
                ", additional=" + additional +
                '}';
    }
}
