import java.io.IOException;
import java.net.*;
import java.util.ArrayList;

public class DNSServer {
    DatagramSocket receivingSocket;
    DNSMessage request;
    DNSMessage response;
    DNSMessage sendToGoogle;
    DNSMessage receiveFromGoogle;
    DNSCache cache;
    InetAddress googleAddress = InetAddress.getByName("8.8.8.8");

    /**
     * Constructor that does all the heavy lifting
     * @param port The port where the server is listening
     * @param localAddress For this, it will always be 127.0.0.1
     * @throws IOException In case the stream isn't working inside the method
     */
    public DNSServer(int port, InetAddress localAddress) throws IOException {
        cache = new DNSCache();
        receivingSocket = new DatagramSocket(port);
        //Listen forever
        while (true) {
            //The byte[] that will contain the client's request
            byte[] incomingInfo = new byte[512];
            DatagramPacket packet = new DatagramPacket(incomingInfo, incomingInfo.length, localAddress, port);
            //Receive the request
            receivingSocket.receive(packet);
            InetAddress clientAddress =  packet.getAddress();
            int clientPort = packet.getPort();
            //Create the DNSMessage for the request
            request = DNSMessage.decodeMessage(incomingInfo);
            //For each question, check the cache for answers
            for (DNSQuestion question:request.getQuestions()) {
                //If the cache does contain the question...
                if (cache.contains(question)) {
                    //Provide the answers
                    ArrayList<DNSRecord> answers = new ArrayList<>();
                    answers.add(cache.getRecord(question));
                    response = DNSMessage.buildResponse(request, answers);
                    //The byte[] that will contain the response to the client
                    byte[] toClient = response.toBytes();
                    DatagramPacket offToClient = new DatagramPacket(toClient, toClient.length, clientAddress, clientPort);
                    //Send the response
                    receivingSocket.send(offToClient);
                }
                else{
                    DatagramPacket sendOffToGoogle = new DatagramPacket(incomingInfo, incomingInfo.length, googleAddress, 53);
                    //Send the request to Google
                    receivingSocket.send(sendOffToGoogle);
                    //The byte[] to store Google's response
                    byte[] googleInfo = new byte[512];
                    DatagramPacket googlePacket = new DatagramPacket(googleInfo, googleInfo.length);
                    receivingSocket.receive(googlePacket);
                    DatagramPacket offToClient = new DatagramPacket(googleInfo, googleInfo.length, clientAddress, clientPort);
                    //Send the response
                    receivingSocket.send(offToClient);
                    //Receive Google's response
                    receiveFromGoogle = DNSMessage.decodeMessage(googleInfo);
                    //Add answers to the cache
                    for (int i = 0; i < receiveFromGoogle.getQuestions().size(); i++) {
                        cache.addEntry(receiveFromGoogle.getQuestions().get(i), receiveFromGoogle.getAnswers().get(i));
                    }
                }
            }
        }
    }
}
