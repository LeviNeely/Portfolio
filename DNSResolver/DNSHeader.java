import java.io.*;

public class DNSHeader {
    private short ID;
    private short flags1;
    private short flags2;
    private int QR;
    private int opCode;
    private int AA;
    private int TC;
    private int RD;
    private int RA;
    private int Z;
    private int AD;
    private int CD;
    private int RCODE;
    private short QDCOUNT;
    private short ANCOUNT;
    private short NSCOUNT;
    private short ARCOUNT;

    /**
     * Constructor
     */
    public DNSHeader() {
    }

    /**
     * Method to decode the entire header from a message
     * @param inputStream the stream used to stream the byte data
     * @return A fully parsed DNSHeader
     * @throws IOException in case the stream doesn't connect
     */
    public static DNSHeader decodeHeader(InputStream inputStream) throws IOException {
        DNSHeader header = new DNSHeader();
        DataInputStream dataInputStream = new DataInputStream(inputStream);
        header.ID = dataInputStream.readShort();
        //Read in the flags one byte at a time
        header.flags1 = dataInputStream.readByte();
        header.flags2 = dataInputStream.readByte();
        //Parse the individual bytes from the flags
        header.QR = (header.flags1 & 0b100000000) >>> 7;
        header.opCode = (header.flags1 & 0b01111000) >>> 3;
        header.AA = (header.flags1 & 0b00000100) >>> 2;
        header.TC = (header.flags1 & 0b000000010) >>> 1;
        header.RD = header.flags1 & 0b000000001;
        header.RA = (header.flags2 & 0b10000000) >>> 7;
        header.Z = (header.flags2 & 0b01000000) >>> 6;
        header.AD = (header.flags2 & 0b00100000) >>> 5;
        header.CD = (header.flags2 & 0b00010000) >>> 4;
        header.RCODE = header.flags2 & 0b00001111;
        header.QDCOUNT = dataInputStream.readShort();
        header.ANCOUNT = dataInputStream.readShort();
        header.NSCOUNT = dataInputStream.readShort();
        header.ARCOUNT = dataInputStream.readShort();
        return header;
    }

    /**
     * Named constructor to build a response header
     * @param request the request to which we are responding
     * @param response the DNSMessage to which we will send
     * @return the constructed DNSHeader
     */
    public static DNSHeader buildHeaderForResponse(DNSMessage request, DNSMessage response) {
        DNSHeader header = new DNSHeader();
        //ID stays the same so that it can recognize it
        header.ID = request.getHeader().getID();
        //Since this is a response, this needs to be set to a 1;
        header.QR = 1;
        //All of these will be the same as the request
        header.opCode = request.getHeader().getOpCode();
        header.AA = request.getHeader().getAA();
        header.TC = request.getHeader().getTC();
        header.RD = request.getHeader().getRD();
        header.RA = request.getHeader().getRA();
        header.Z = request.getHeader().getZ();
        header.AD = request.getHeader().getAD();
        header.CD = request.getHeader().getCD();
        //Since we can assume there won't be any errors in getting a response, setting this to 0
        header.RCODE = 0;
        //These will depend on the size of these arrayList member variables
        header.QDCOUNT = (short)response.getQuestions().size();
        header.ANCOUNT = (short)response.getAnswers().size();
        header.NSCOUNT = (short)response.getAuthority().size();
        header.ARCOUNT = (short)response.getAdditional().size();
        return header;
    }

    /**
     * Method to write the data into a byte array output stream for transmission
     * @param outputStream the byte array output stream to write to
     * @throws IOException
     */
    public void writeBytes(ByteArrayOutputStream outputStream) throws IOException {
        DataOutputStream dataOutputStream = new DataOutputStream(outputStream);
        dataOutputStream.writeShort(ID);
        short flag1 = (short)((QR << 7) | (opCode << 3) | (AA << 2) | (TC << 1) | (RD));
        dataOutputStream.writeByte(flag1);
        short flag2 = (short)((RA << 7) | (Z << 6) | (AD << 5) | (CD << 4) | (RCODE));
        dataOutputStream.writeByte(flag2);
        dataOutputStream.writeShort(QDCOUNT);
        dataOutputStream.writeShort(ANCOUNT);
        dataOutputStream.writeShort(NSCOUNT);
        dataOutputStream.writeShort(ARCOUNT);
    }

    public short getID() {
        return ID;
    }

    public int getQR() {
        return QR;
    }

    public int getOpCode() {
        return opCode;
    }

    public int getAA() {
        return AA;
    }

    public int getTC() {
        return TC;
    }

    public int getRD() {
        return RD;
    }

    public int getRA() {
        return RA;
    }

    public int getZ() {
        return Z;
    }

    public int getAD() {
        return AD;
    }

    public int getCD() {
        return CD;
    }

    public int getRCODE() {
        return RCODE;
    }

    public short getQDCOUNT() {
        return QDCOUNT;
    }
    public short getANCOUNT() {
        return ANCOUNT;
    }
    public short getNSCOUNT() {
        return NSCOUNT;
    }
    public short getARCOUNT() {
        return ARCOUNT;
    }
    @Override
    public String toString() {
        return "DNSHeader{" +
                "ID=" + ID +
                ", QR=" + QR +
                ", opCode=" + opCode +
                ", AA=" + AA +
                ", TC=" + TC +
                ", RD=" + RD +
                ", RA=" + RA +
                ", Z=" + Z +
                ", AD=" + AD +
                ", CD=" + CD +
                ", RCODE=" + RCODE +
                ", QDCOUNT=" + QDCOUNT +
                ", ANCOUNT=" + ANCOUNT +
                ", NSCOUNT=" + NSCOUNT +
                ", ARCOUNT=" + ARCOUNT +
                '}';
    }
}
