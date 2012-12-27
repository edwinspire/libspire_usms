//New file source
using GLib;
using Gee;
using edwinspire.Ports;
using edwinspire.GSM.MODEM;
using Xml;
using edwinspire.uHttp;

namespace edwinspire.uSMS{

public class uSMSServer:GLib.Object{

private uHttpServer S = new uHttpServer ();

private ArrayList<Device> Dispositivos = new ArrayList<Device>();
private  HashSet<string> PuertosUnicos = new HashSet<string>();

public uSMSServer(){

S.Index = "usms.html";

print("Start uSMSd Version: %s\n", edwinspire.uSMS.VERSION);
print("Licence: LGPL\n");
print("Contact: edwinspire@gmail.com\n");

S.Port = 8080;
S.VirtualUrl["getsmsouttable"] = "/getsmsouttable";
S.VirtualUrl["getpostgresconf"] = "/getpostgresconf";
S.VirtualUrl["postpostgresconf"] = "/postpostgresconf";
S.VirtualUrl["gettableserialport"] = "/gettableserialport";
S.VirtualUrl["posttableserialport"] = "/posttableserialport";
S.VirtualUrl["usmsgetcontactsvaluesselectbox"] = "/usmsgetcontactsvaluesselectbox";  

foreach(var U in VirtualUrls().entries){
S.VirtualUrl[U.key] = U.value;  
}

S.RequestVirtualUrl.connect(RequestVirtualPageHandler);

}

public static HashMap<string, string> VirtualUrls(){
var Retorno = new HashMap<string, string>();
Retorno["getsmsouttable"] = "/getsmsouttable";
Retorno["getpostgresconf"] = "/getpostgresconf";
Retorno["postpostgresconf"] = "/postpostgresconf";
Retorno["gettableserialport"] = "/gettableserialport";
Retorno["posttableserialport"] = "/posttableserialport";
Retorno["usmsgetcontactsvaluesselectbox"] = "/usmsgetcontactsvaluesselectbox";  
return Retorno;
}

public static uHttp.Response ResponseToVirtualRequest( Request request){
   uHttp.Response response = new uHttp.Response();
      response.Header.Status = StatusCode.OK;
   response.Data =  "".data;

switch(request.Path){
case  "/getpostgresconf":
response = ResponseGetPostgresConf(request);
break;
case "/postpostgresconf":
response = ResponseUpdatePostgresConf(request);
break;
case "/getsmsouttable":
response = ResponseSMSOutTable(request);
break;
case "/gettableserialport":
response = ResponseSerialPortTable(request);
break;
case "/posttableserialport":
response = ResponseUpdateTableSerialPort(request);
break;
case "/usmsgetcontactsvaluesselectbox":
response = ResponseContactsNamesToSelectBox(request);
break;

default:
      response.Header.Status = StatusCode.NOT_FOUND;
break;
}
return response;
}


public void RequestVirtualPageHandler(uHttpServer server, Request request, DataOutputStream dos){
    server.serve_response( ResponseToVirtualRequest(request), dos );
}


// Recibe los datos y los actualiza en la base de datos.
private static uHttp.Response ResponseUpdateTableSerialPort(Request request){
uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/plain";


if(TableSerialPort.InsertUpdateFromWeb(request.Form)>0){
    Retorno.Header.Status = StatusCode.OK;
}else{
    Retorno.Header.Status = StatusCode.NOT_FOUND;
}

    Retorno.Data =  "".data;

return Retorno;
}


private static uHttp.Response ResponseContactsNamesToSelectBox(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/plain";
    Retorno.Header.Status = StatusCode.OK;

TableContacts Tabla = new TableContacts();
Tabla.GetParamCnx();

    Retorno.Data =  Tabla.NameAndId_All_Xml().data;
//print(Tabla.NameAndId_All_Xml());

return Retorno;
}

// Recibe los datos y los actualiza en la base de datos.
private static uHttp.Response ResponseSerialPortTable(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

    Retorno.Data =  TableSerialPort.AllXml().data;

print("Envia los datos a la web xml\n%s\n", TableSerialPort.AllXml());

return Retorno;
}

// Envia la tabla
private static uHttp.Response ResponseSMSOutTable(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

var Tablasmsout = new TableSMSOut();
Tablasmsout.GetParamCnx();

    Retorno.Data =  Tablasmsout.AllXml().data;

print("Envia los datos a la web xml\n%s\n", Tablasmsout.AllXml());

return Retorno;
}

// Recibe los datos y los actualiza en la base de datos.
private static uHttp.Response ResponseUpdatePostgresConf(Request request){
uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/plain";


if(TablePostgres.UpdateFromWeb(request.Form)>0){
    Retorno.Header.Status = StatusCode.OK;
}else{
    Retorno.Header.Status = StatusCode.NOT_MODIFIED;
}

    Retorno.Data =  "".data;

return Retorno;
}



// Solicita los datos de conexion a postgres
private static uHttp.Response ResponseGetPostgresConf(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

//var Datos = new TablePostgres();

    Retorno.Data =  TablePostgres.LastRowEnabledXML().data;

print("Envia los datos a la web xml\n%s\n", TablePostgres.LastRowEnabledXML());

return Retorno;
}

// Usar unicamente cuando se inicia el servidor o cuando se lo reinicia.
private void ResetAndLoadDevices(){
print("Loading devices...\n");

foreach(var u in TableSerialPort.Enables()){

if(!PuertosUnicos.contains(u.Port)){
PuertosUnicos.add(u.Port);
stdout.printf ("Usar Modem en %s\n", u.Port);
Device de = new Device();
de.SetPort(u);
//de.Ctrl = ProcessCtrl.Run;
Dispositivos.add(de);
}

}

}
// Inicia y corre el servidor asincronicamente
public void Run(){
ResetAndLoadDevices();
print("Connect: http://localhost:%s\n", S.Port.to_string());
    S.run();
}




}

/*
public class HttpClientCom:GLib.Object{

public string host = "localhost";
public uint16 Port = 8080;
private string Path = "/pathusmsdcomm";

public HttpClientCom(){

}

public string RequestCtrlProcessStatus(){
var Nodo = XmlFunctions.Node("Request");
Nodo->new_prop("Process", "status");
//Xml.Node* rowxml = new Xml.Node(null, "Process");


return SendToServer(XmlFunctions.XmlDocToString(Nodo));
}

public string SendToServer(string xmlRequest){
string Retorno = "";

    try {
        // Resolve hostname to IP address
        var resolver = Resolver.get_default ();
        var addresses = resolver.lookup_by_name (host, null);
        var address = addresses.nth_data (0);
        print (@"Resolved> $host to $address\n");

        // Connect
        var client = new SocketClient ();
        var conn = client.connect (new InetSocketAddress (address, Port));
        print (@"Connected to $host\n");
//        print ("xml length = %i\n", );
int xmllengthdata = xmlRequest.data.length;

        // Send HTTP GET request
        var message = @"GET $Path HTTP/1.1\r\nHost: $host\r\nContent-Length: $xmllengthdata\r\n\r\n";

        conn.output_stream.write (message.data);
        conn.output_stream.write (xmlRequest.data);
        print ("Wrote request\n");

        // Receive response
        var response = new DataInputStream (conn.input_stream);

    string firstblock ="";
 size_t size = 0;

var DatosRecibidos = new StringBuilder();

int maxline = 1000;
while(maxline>0){
firstblock = response.read_line( out size );
if(firstblock != null){
DatosRecibidos.append_printf("%s\n", firstblock);
}
if(firstblock=="\r" || firstblock == null){
break;
}
maxline--;
}
Retorno = DatosRecibidos.str;
//print("Recibido = %s\n", DatosRecibidos.str);
 //       var status_line = response.read_line (null).strip ();
//        print ("Received status line: %s\n", status_line);

    } catch (GLib.Error e) {
        stderr.printf ("%s\n", e.message);
    }

return Retorno;
}




}
*/
}
