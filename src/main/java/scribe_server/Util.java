/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package scribe_server;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TThreadPoolServer;
import org.apache.thrift.transport.TFramedTransport;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TTransportException;
import scribe.thrift.Scribe;
/**
 *
 * @author smackware
 */
public class Util {

    public static void serveWithHandler(String host, int port, Scribe.Iface handler) throws TTransportException {
        System.out.println("Setting up...");
        scribe.thrift.Scribe.Processor processor = new scribe.thrift.Scribe.Processor(handler);
        TServerTransport transport = new TServerSocket(port);
        TThreadPoolServer.Args serverArgs = new TThreadPoolServer.Args(transport);
        serverArgs.processor(processor);
        serverArgs.transportFactory(new TFramedTransport.Factory());
        serverArgs.protocolFactory(new TBinaryProtocol.Factory(true, true));
        TServer server = new TThreadPoolServer(serverArgs);
        System.out.println("Serving...");
        server.serve();

    }
}
