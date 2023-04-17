import java.io.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

public class DNSRecord {
    private short TYPE;
    private short CLASS;
    private int TTL;
    private int RDLENGTH;
    private byte[] RDATA;
    private String IPAddress;
    private String domainName;
    private Calendar timeCreated;

    /**
     * Named constructor used to parse the Record from a DNSMessage
     * @param inputStream the stream of bytes used to get the data
     * @param message the message that is creating the record
     * @return a fully parsed DNSRecord
     * @throws IOException
     */
    public static DNSRecord decodeRecord(InputStream inputStream, DNSMessage message) throws IOException {
        DNSRecord record = new DNSRecord();
        //Recording the instance of creation for later expiration tracking
        record.timeCreated = Calendar.getInstance();
        DataInputStream dataInputStream = new DataInputStream(inputStream);
        byte firstByte = dataInputStream.readByte();
        //First two bits can either be 11 (3) or 00 depending on what it's function is
        if ((firstByte & 0xC0) == 0xC0) {
            byte secondByte = dataInputStream.readByte();
            int offSet = ((firstByte & 0x3F) << 8 | secondByte) & 0xFFFF;
            String [] pieces = message.readDomainName(offSet);
            record.domainName = message.joinDomainName(pieces);
        }
        record.TYPE = dataInputStream.readShort();
        record.CLASS = dataInputStream.readShort();
        record.TTL = dataInputStream.readInt();
        record.RDLENGTH = dataInputStream.readShort();
        if (record.RDLENGTH > 0) {
            record.RDATA = inputStream.readNBytes(record.RDLENGTH);

//        else {
//            record.RDATA = new byte[]{};
//        }
            //Building the IP address
            StringBuilder ip = new StringBuilder();
            for (int i = 0; i < record.RDATA.length; i++) {
                if (i != record.RDATA.length - 1) {
                    ip.append(record.RDATA[i]);
                    ip.append(".");
                } else {
                    ip.append(record.RDATA[i]);
                }
            }
            record.IPAddress = ip.toString();
        }
        return record;
    }

    /**
     * A method to write out the data stored in the DNSRecord into a byte array
     * @param outputStream the byte output stream to be written to
     * @param domainNameLocations a hashmap to access the offset used to compress the domain name
     * @throws IOException
     */
    public void writeBytes(ByteArrayOutputStream outputStream, HashMap<String, Integer> domainNameLocations) throws IOException {
        DataOutputStream dataOutputStream = new DataOutputStream(outputStream);
        if (domainName != null) {
            //Writing the offset
            dataOutputStream.writeShort((0b11000000) | (domainNameLocations.get(domainName)));
        }
        dataOutputStream.writeByte(0);
        dataOutputStream.writeShort(TYPE);
        dataOutputStream.writeShort(CLASS);
        dataOutputStream.writeInt(TTL);
        dataOutputStream.writeShort(RDLENGTH);
        if (RDLENGTH > 0) {
            dataOutputStream.write(RDATA);
        }
    }

    /**
     * A method to tell if the record has expired
     * @return true if it is expired, false if not
     */
    public boolean isExpired() {
        //Getting the current time
        Calendar currentTime = Calendar.getInstance();
        //Cloning the timeCreated field
        Calendar timeToCheck = (Calendar) timeCreated.clone();
        //Adding the TTL to know when the expiration date is
        timeToCheck.add(Calendar.SECOND, TTL);
        if (currentTime.after(timeToCheck)) {
            return true;
        }
        return false;
    }

    @Override
    public String toString() {
        return "DNSRecord{" +
                "TYPE=" + TYPE +
                ", CLASS=" + CLASS +
                ", TTL=" + TTL +
                ", RDLENGTH=" + RDLENGTH +
                ", IPAddress='" + IPAddress + '\'' +
                ", domainName='" + domainName + '\'' +
                '}';
    }
}
