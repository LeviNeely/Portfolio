import java.io.IOException;
import java.net.InetAddress;

public class Main {
    public static void main(String[] args) throws IOException {
        int port = 8053;
        InetAddress localAddress = InetAddress.getByName("127.0.0.1");
        DNSServer server = new DNSServer(port, localAddress);
    }
}