//
//
//  Author:
//       Edwin De La Cruz <admin@edwinspire.com>
//
//  Copyright (c) 2013 edwinspire
//  Web Site http://edwinspire.com
//
//  Quito - Ecuador
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

using GLib;
using Gee;
using edwinspire.Ports;
using edwinspire.GSM.MODEM;
//using Xml;


namespace edwinspire.uSMS{

/*

public class XmlDatas:GLib.Object{

public bool FieldTextToBase64 = false;

public XmlDatas(){

}

public static Xml.Doc* XmlDocBuild(Xml.Node* rootNode){
 Xml.Doc* DocMaster = new Xml.Doc();
//DocMaster->encoding = "UTF-8";
DocMaster->set_root_element(rootNode);
return DocMaster;
}

public static Xml.Node* Node(string Name = "nodeName"){
Xml.Node* root = new Xml.Node(null, Name);
return root;
}

public static string StringToBase64(string textstring){
return Base64.encode(textstring.data);
}

public static string XmlDocToString(Xml.Node* rootNode){
string Retorno;
Xml.Doc* D = XmlDocBuild(rootNode);
D->dump_memory(out Retorno);
//print("Response XML: %s\n", Retorno);
if(Retorno == null){
Retorno = "";
}
delete D;
return Retorno;
}


}

public class XmlRow:XmlDatas{

private HashMap<string, string> Datos = new HashMap<string, string>();
public string Name = "row";

public XmlRow(){

}

public void clear(){
Datos.clear();
}

public void addFieldString(string name, string value, bool asBase64 = false){

if(asBase64){
Datos[name] = StringToBase64(value);
}else{
Datos[name] = value;
}
}

public Xml.Node* Row(){

var RowNodo = XmlDatas.Node(this.Name);
foreach(var D in Datos.entries){
RowNodo->new_prop(D.key, D.value);
}
return RowNodo;
}

public void addFieldInt(string name, int value){
addFieldString(name, value.to_string());
}

public void addFieldDouble(string name, double value){
addFieldString(name, value.to_string());
}

public void addFieldBool(string name, bool value){
addFieldString(name, value.to_string());
}

public void addFieldUint(string name, uint value){
addFieldString(name, value.to_string());
}
public void addFieldInt64(string name, int64 value){
addFieldString(name, value.to_string());
}

}



*/


// Almacena los datos de un puerto serial desde o hacia la db
public class SerialPortConf: edwinspire.Ports.Configure {

public int Id{set; get; default = 0;}
public string Note{set; get; default = "";}
public ArrayList<LogLevelFlags> LogLevel{set; get; default = new ArrayList<LogLevelFlags>();}

public SerialPortConf(){
LogLevel.add(LogLevelFlags.LEVEL_ERROR);
LogLevel.add(LogLevelFlags.LEVEL_CRITICAL);
}

public SerialPortConf.with_args(int id, bool enable, string port, int baudrate, int databits, Ports.Parity parity, Ports.StopBits stopbits, Ports.HandShaking HS, string note = "", ArrayList<LogLevelFlags> llevel){
this.Id = id;
this.Enable = enable;
this.Port = port;
this.BaudRate = baudrate;
this.DataBits = databits;
this.HandShake = HS;
this.Parityp = parity;
this.StopBitsp = stopbits;
this.Note = note;
this.LogLevel = llevel;
}

}



}
