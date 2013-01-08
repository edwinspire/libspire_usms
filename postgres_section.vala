//New file source

using GLib;
using Gee;
//using edwinspire.Ports;
using edwinspire.GSM.MODEM;
using edwinspire.PDU;
using edwinspire.pgSQL;
using Postgres;



namespace edwinspire.uSMS{

public class SQLFunReturn:GLib.Object{
public int Return = 0;
public string Msg = "";

public SQLFunReturn(int r = 0, string message = ""){
this.Return = r;
this.Msg = message;
}

public string Xml(){
XmlRow Retorno = new XmlRow();
Retorno.Name = "SQLFunReturn";
Retorno.addFieldInt("return", this.Return);
Retorno.addFieldString("msg", this.Msg, true);
return XmlDatas.XmlDocToString(Retorno.Row());
}

} 

public class PostgreSQLConnection:PostgreSqldb{

public void GetParamCnx(){
this.ParamCnx = TablePostgres.LastRowEnabled().Parameters;
}

}


public class PostgresuSMS:PostgreSqldb{
public PostgresuSMS(){
}
public void GetParamCnx(){
this.ParamCnx = TablePostgres.LastRowEnabled().Parameters;
}


//fun_portmodem_update(inidport integer, inport text, incimi text, inimei text, inmanufacturer text, inmodel text, inrevision text)

public bool fun_portmodem_update(int inidport, string inport, string incimi, string inimei, string inmanufacturer, string inmodel, string inrevision){

string[] valuessms = {inidport.to_string(), inport, incimi, inimei, inmanufacturer, inmodel, inrevision};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_portmodem_update($1::integer, $2::text, $3::text, $4::text, $5::text, $6::text, $7::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_portmodem_update"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return true;
}

public int fun_currentportsproviders_insertupdate(int inidport, string inport, string incimi, string inimei){

string[] valuessms = {inidport.to_string(), inport, incimi, inimei};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_currentportsproviders_insertupdate($1::integer, $2::text, $3::text, $4::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_currentportsproviders_insertupdate"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}

}



public class TableProvider:PostgresuSMS{


public TableProvider(){

}


public int IdProviderFromCIMI(string cimi){

string[] valuesin = {cimi};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

//var Resultado = Conexion.exec("""SELECT fun_insert_smsout(1, 1, 0, '989988711', '2009-12-23 12:12', 'inmessage text', 'innote text');""");

var Resultado = Conexion.exec_params ("""SELECT idprovider FROM provider WHERE cimi LIKE $1::text AND enable = true;""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {



foreach(var filas in this.Result_FieldName(ref Resultado)){
foreach(var fila in filas.entries){
//GLib.print("%s => %s\n", fila.key, fila.value);
if(fila.key == "idprovider"){
Retorno = fila.value.as_int();
//GLib.print("CIMI POSTGRES = %s\n", Retorno.to_string());
break;
}
}
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}
if(Retorno<1){
GLib.print("No se obtuvo el idprovider desde la base de datos para el valor CIMI = %s. Asegurese que haya sido creado.\n", cimi);
}
return Retorno;
}


}

public class SMSOutRow:Submit{

public edwinspire.PDU.DCS_MESSAGE_CLASS MessageClass{get; set; default = edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC;}
public bool enableMessageClass{get; set; default = false;}
public bool StatusReport{get; set; default = false;}
public int MaxSlices{get; set; default = 1;}

public GLib.DateTime  dateload {get; set; default = new GLib.DateTime.now_local();} 
public int  idprovider {get; set; default = 0;} 
public int  idsmstype {get; set; default = 0;} 
public int  idphone {get; set; default = 0;} 
public string  phone {get; set; default = "";} 
public GLib.DateTime  datetosend {set; get; default = new GLib.DateTime.now_local();} 
public GLib.DateTime  dateprocess {set; get; default = new GLib.DateTime.now_local();} 
public int process {get; set; default = 0;} 
public string   note {get; set; default = "";} 
public int  priority {get; set; default = 0;} 
public int  attempts {get; set; default = 0;} 
public int   idprovidersent  {get; set; default = 0;}
public int  slices {get; set; default = 0;}
public int  slicessent {get; set; default = 0;}
public int  messageclass {get; set; default = 0;}
public int  idport {get; set; default = 0;}
public int  flag1 {get; set; default = 0;}
public int  flag2 {get; set; default = 0;}
public int  flag3 {get; set; default = 0;}
public int  flag4 {get; set; default = 0;}
public int  flag5 {get; set; default = 0;}
public int  retryonfail {get; set; default = 0;}
public int  maxtimelive {get; set; default = 0;}
 

}
// fun_incomingcalls_insert_online(inidport integer, incallaction integer, inphone text, innote text)
public class TableCallIn:PostgresuSMS{


public TableCallIn(){

}

public int fun_incomingcalls_insert_online(int inidport, CallAction incallaction, string inphone, string innote = ""){

string[] valuessms = {inidport.to_string(), ((int)incallaction).to_string(), inphone, innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_incomingcalls_insert_online($1::integer, $2::integer, $3::text, $4::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_incomingcalls_insert_online"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}



return Retorno;
}

}



public class TableContacts:PostgreSQLConnection{


public TableContacts(){

}

public string fun_contacts_table_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){
int inidcontact = -1;
bool inenable = false;
string intitle = "";
string infirstname = "";
string inlastname = "";
int ingender = 0;
string inbirthday = "";
int intypeofid = 0;
string inidentification = "";
string inweb = "";
string inemail1 = "";
string inemail2 = "";
string inidaddress = "";
string innote = "";

if(data.has_key("idcontact")){
inidcontact = int.parse(data["idcontact"]);
}

if(data.has_key("enable")){
inenable = bool.parse(data["enable"]);
}

if(data.has_key("title")){
intitle = data["title"];
}

if(data.has_key("firstname")){
infirstname = data["firstname"];
}

if(data.has_key("lastname")){
inlastname = data["lastname"];
}

if(data.has_key("gender")){
ingender = int.parse(data["gender"]);
}

if(data.has_key("birthday")){
inbirthday = data["birthday"];
}

if(data.has_key("typeofid")){
intypeofid = int.parse(data["typeofid"]);
}

if(data.has_key("identification")){
inidentification = data["identification"];
}

if(data.has_key("web")){
inweb = data["web"];
}

if(data.has_key("email1")){
inemail1 = data["email1"];
}

if(data.has_key("email2")){
inemail2 = data["email2"];
}

if(data.has_key("idaddress")){
inidaddress = data["idaddress"];
}

if(data.has_key("note")){
innote = data["note"];
}


return fun_contacts_table_xml(inidcontact, inenable, intitle, infirstname, inlastname, ingender, inbirthday, intypeofid, inidentification, inweb, inemail1, inemail2, inidaddress, innote, fieldtextasbase64);
}

//fun_contacts_table_xml(inidcontact integer, inenable boolean, intitle text, infirstname text, inlastname text, ingender integer, inbirthday date, intypeofid integer, inidentification text, inweb text, inemail1 text, inemail2 text, inidaddress text, innote text)
 
public string fun_contacts_table_xml(int inidcontact, bool inenable, string intitle, string infirstname, string inlastname, int ingender, string inbirthday, int intypeofid, string inidentification, string inweb, string inemail1, string inemail2, string inidaddress, string innote, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {inidcontact.to_string(), inenable.to_string(), intitle, infirstname, inlastname, ingender.to_string(), inbirthday, intypeofid.to_string(), inidentification, inweb, inemail1, inemail2, inidaddress, innote, fieldtextasbase64.to_string()};

var Resultado = Conexion.exec_params ("""SELECT * FROM fun_contacts_table_xml($1::integer, $2::boolean, $3::text, $4::text, $5::text, $6::integer, $7::date, $8::integer, $9::text, $10::text, $11::text, $12::text, $13::text, $14::text, $15::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
return RetornoX;
}

public string byId_Xml(int idcontact, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcontact.to_string(), fieldtextasbase64.to_string()};
var Resultado = Conexion.exec_params ("""SELECT * FROM fun_view_contacts_byidcontact_xml($1::integer, $2::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
GLib.print(RetornoX);
return RetornoX;
}

public string NameAndId_All_Xml(bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {fieldtextasbase64.to_string()};

var Resultado = Conexion.exec_params ("""SELECT * FROM fun_view_contacts_to_list_xml($1::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
return RetornoX;
}

/*
public string NameAndId_All_Xml(){

var Rows = XmlDatas.Node("contacts");

foreach(var r in NameAndId_All().entries){
XmlRow Fila = new XmlRow();
Fila.Name = "row";
Fila.addFieldInt("idcontact", r.key);
Fila.addFieldString("name", r.value, true);
Rows->add_child(Fila.Row());
}
return XmlDatas.XmlDocToString(Rows);
}
*/


public HashMap<int, string> NameAndId_All(){

string[] valuesin = {"lastname"};
HashMap<int, string> RetornoX = new HashMap<int, string>();
RetornoX[0] = "Ninguno seleccionado";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("SELECT idcontact, enable, lastname, firstname FROM contacts ORDER BY $1;", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

var Nombre = new StringBuilder();

foreach(var reg in this.Result_FieldName(ref Resultado)){
Nombre.truncate();
Nombre.append_printf("%s %s", reg["lastname"].Value, reg["firstname"].Value);

RetornoX[reg["idcontact"].as_int()] = Nombre.str;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}

return RetornoX;
}




}



//fun_smsin_insert(inidport integer, instatus integer, indatesms timestamp without time zone, inphone text, inmsj text, innote text)

public class TableSMSIn:PostgresuSMS{


public TableSMSIn(){

}

public int fun_smsin_insert(int inidport, SMS_Status instatus, Datetime indatesms, string inphone, string inmsj, string innote = ""){

string[] valuessms = {inidport.to_string(), ((int)instatus).to_string(), indatesms.to_string(), inphone, inmsj, innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_smsin_insert($1::integer, $2::integer, $3::timestamp without time zone, $4::text, $5::text, $6::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsin_insert"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}



return Retorno;
}

}

public class TableSMSOut:PostgresuSMS{


public TableSMSOut(){

}

// fun_smsout_to_send(inidprovider integer DEFAULT 0)
public SMSOutRow ToSend(int IdProvider){

string[] valuesin = {IdProvider.to_string()};
SMSOutRow Retorno = new SMSOutRow();
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

//var Resultado = Conexion.exec("""SELECT fun_insert_smsout(1, 1, 0, '989988711', '2009-12-23 12:12', 'inmessage text', 'innote text');""");

var Resultado = Conexion.exec_params ("""SELECT idsmsout, phone, message, messageclass, enablemessageclass, report, maxslices FROM fun_smsout_to_send($1::integer);""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
Retorno.Index = reg["idsmsout"].as_uint();
Retorno.Phone = reg["phone"].Value;
Retorno.Text = reg["message"].Value;
Retorno.MessageClass = (edwinspire.PDU.DCS_MESSAGE_CLASS)reg["messageclass"].as_int();
Retorno.enableMessageClass = reg["enablemessageclass"].as_bool();
Retorno.StatusReport = reg["report"].as_bool();
Retorno.MaxSlices = reg["maxslices"].as_int();
GLib.print("Mensage[%s] >>>> %s\n", Retorno.Index.to_string(), Retorno.Text);
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}


public string AllXml(GLib.DateTime start = new GLib.DateTime.now_local(), GLib.DateTime end = new GLib.DateTime.now_local(), int maxrow = 100){

var DatosRows = this.All(start, end, maxrow);
var SMSData = XmlDatas.Node("smsout");
//SMSData.Name = "smsout";

foreach(var Datos in DatosRows){

XmlRow Fila = new XmlRow();
Fila.Name = "row";
Fila.addFieldUint("idsmsout", Datos.Index);
Fila.addFieldString("phone", Datos.Phone, true);
Fila.addFieldString("message", Datos.Text, true);
Fila.addFieldInt("messageclass", (int)Datos.MessageClass);
Fila.addFieldBool("enablemessageclass", Datos.enableMessageClass);
Fila.addFieldBool("report", Datos.StatusReport);
Fila.addFieldInt("maxslices", Datos.MaxSlices);
Fila.addFieldInt("idprovider", Datos.idprovider);
Fila.addFieldInt("idsmstype", Datos.idsmstype);

//Retorno.idphone = int.parse(reg["idphone"]);
Fila.addFieldInt("idphone", Datos.idphone);

//Retorno.datetosend {set; get; default = new GLib.DateTime.now_local();} 
//Retorno.dateprocess {set; get; default = new GLib.DateTime.now_local();} 

//Retorno.process = int.parse(reg["process"]);
Fila.addFieldInt("process", Datos.process);

//Retorno.note = reg["note"];
Fila.addFieldString("note", Datos.note, true);

//Retorno.priority = int.parse(reg["priority"]);
Fila.addFieldInt("priority", Datos.priority);

//Retorno.attempts = int.parse(reg["attempts"]);
Fila.addFieldInt("attempts", Datos.attempts);

//Retorno.idprovidersent  = int.parse(reg["idprovidersent"]);
Fila.addFieldInt("idprovidersent", Datos.idprovidersent);

//Retorno.slices = int.parse(reg["slices"]);
Fila.addFieldInt("slices", Datos.slices);

//Retorno.slicessent = int.parse(reg["slicessent"]);
Fila.addFieldInt("slicessent", Datos.slicessent);

//Retorno.messageclass = int.parse(reg["messageclass"]);
Fila.addFieldInt("messageclass", Datos.messageclass);

//Retorno.idport = int.parse(reg["idport"]);
Fila.addFieldInt("idport", Datos.idport);

//Retorno.flag1 = int.parse(reg["flag1"]);
Fila.addFieldInt("flag1", Datos.flag1);

//Retorno.flag2 = int.parse(reg["flag2"]);
Fila.addFieldInt("flag2", Datos.flag2);

//Retorno.flag3 = int.parse(reg["flag3"]);
Fila.addFieldInt("flag3", Datos.flag3);

//Retorno.flag4 = int.parse(reg["flag4"]);
Fila.addFieldInt("flag4", Datos.flag4);

//Retorno.flag5 = int.parse(reg["flag5"]);
Fila.addFieldInt("flag5", Datos.flag5);

//Retorno.retryonfail = int.parse(reg["retryonfail"]);
Fila.addFieldInt("retryonfail", Datos.retryonfail);

//Retorno.maxtimelive = int.parse(reg["maxtimelive"]);
Fila.addFieldInt("maxtimelive", Datos.maxtimelive);
SMSData->add_child(Fila.Row());
}

return XmlDatas.XmlDocToString(SMSData);
}

// fun_smsout_to_send(inidprovider integer DEFAULT 0)
public ArrayList<SMSOutRow> All(GLib.DateTime start =  new GLib.DateTime.now_local(), GLib.DateTime end = new GLib.DateTime.now_local(), int maxrow = 100){

string[] valuesin = {maxrow.to_string()};
ArrayList<SMSOutRow> RetornoX = new ArrayList<SMSOutRow>();
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("SELECT * FROM smsout WHERE idsmsout > 0 ORDER BY idsmsout DESC LIMIT $1;", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
//GLib.print("idsmsout %s\n", reg["idsmsout"]);

SMSOutRow Retorno = new SMSOutRow();
Retorno.Index = reg["idsmsout"].as_uint();
Retorno.Phone = reg["phone"].Value;
Retorno.Text = reg["message"].Value;
Retorno.MessageClass = (edwinspire.PDU.DCS_MESSAGE_CLASS)reg["messageclass"].as_int();
Retorno.enableMessageClass = reg["enablemessageclass"].as_bool();
Retorno.StatusReport = reg["report"].as_bool();
Retorno.MaxSlices = reg["maxslices"].as_int();

//Retorno.dateload {get; set; default = new GLib.DateTime.now_local();} 
Retorno.idprovider = reg["idprovider"].as_int();
Retorno.idsmstype = reg["idsmstype"].as_int();
Retorno.idphone = reg["idphone"].as_int();
//Retorno.datetosend {set; get; default = new GLib.DateTime.now_local();} 
//Retorno.dateprocess {set; get; default = new GLib.DateTime.now_local();} 
Retorno.process = reg["process"].as_int();
Retorno.note = reg["note"].Value;
Retorno.priority = reg["priority"].as_int();
Retorno.attempts = reg["attempts"].as_int();
Retorno.idprovidersent  = reg["idprovidersent"].as_int();
Retorno.slices = reg["slices"].as_int();
Retorno.slicessent = reg["slicessent"].as_int();
Retorno.messageclass = reg["messageclass"].as_int();
Retorno.idport = reg["idport"].as_int();
Retorno.flag1 = reg["flag1"].as_int();
Retorno.flag2 = reg["flag2"].as_int();
Retorno.flag3 = reg["flag3"].as_int();
Retorno.flag4 = reg["flag4"].as_int();
Retorno.flag5 = reg["flag5"].as_int();
Retorno.retryonfail = reg["retryonfail"].as_int();
Retorno.maxtimelive = reg["maxtimelive"].as_int();

RetornoX.add(Retorno);
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}

return RetornoX;
}

//fun_smsout_insert(inidprovider integer, inidsmstype integer, inidphone integer, inpriority integer, inphone text, inretryonfail boolean, indatetosend timestamp without time zone, inmessage text, innote text)

public int fun_smsout_insert(int inidphone, string inphone, string inmessage, int inidprovider = 0, int inidsmstype = 0, int inpriority = 5,  DateTime indatetosend = new DateTime.now_local(), bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = ""){

string[] valuessms = {inidprovider.to_string(), inidsmstype.to_string(), inidphone.to_string(), inpriority.to_string(), inphone, indatetosend.to_string(), inmessage, inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_smsout_insert($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::timestamp without time zone, $7::text, $8::boolean, $9::integer, $10::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_insert"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}


// fun_smsout_updatestatus(inidsmsout integer, inprocess integer, inidprovidersent integer, innote text)
public int fun_smsout_updatestatus(int inidsmsout, ProcessSMSOut inprocess, int inidprovidersent, int inslices, int inslicessent, string innote = ""){

string[] valuessms = {inidsmsout.to_string(), ((int)inprocess).to_string(), inidprovidersent.to_string(), inslices.to_string(), inslicessent.to_string(), innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT fun_smsout_updatestatus($1::integer, $2::integer, $3::integer, $4::integer, $5::integer, $6::text);""",  valuessms.length, null, valuessms, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_updatestatus"].as_int();
/*
foreach(var tu in filas.entries){
GLib.print("%s => %s\n", tu.key, tu.value);
}
*/
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}


}

public struct PhoneTableRow{
public int IdPhone;
public int IdContact;
public bool Enable;
public string Phone;
public int Type;
public int IdProvider;
public string Note;
public double GeoX;
public double GeoY;
public string IdAddress;
public string PhoneExt;
public int UbiPhone;
public string Address;
public string TimeStamp;

public PhoneTableRow(){
this.IdPhone = 0;
this.IdContact = 0;
this.Enable = false;
this.Phone = "";
this.Type = 0;
this.IdProvider = 0;
this.Note = "";
this.GeoX = 0;
this.GeoY = 0;
this.IdAddress = "";
this.PhoneExt = "";
this.UbiPhone = 0;
this.Address = "";
this.TimeStamp = "";
}

}



public class PhoneTable:PostgreSQLConnection{

public static XmlRow PhoneTableRowNodeXml(PhoneTableRow row){

XmlRow Fila = new XmlRow();
Fila.Name = "row";
Fila.addFieldInt("idphone", row.IdPhone);
Fila.addFieldInt("idcontact", row.IdContact);
Fila.addFieldBool("enable", row.Enable);
Fila.addFieldString("phone", row.Phone, true);
Fila.addFieldInt("type", row.Type);
Fila.addFieldDouble("geox", row.GeoX);
Fila.addFieldDouble("geoy", row.GeoY);
Fila.addFieldString("idaddress", row.IdAddress);
Fila.addFieldInt("idprovider", row.IdProvider);
Fila.addFieldString("phone_ext", row.PhoneExt, true);
Fila.addFieldInt("ubiphone", row.UbiPhone);
Fila.addFieldString("address", row.Address, true);
Fila.addFieldString("note", row.Note, true);
Fila.addFieldString("ts", row.TimeStamp, true);

return Fila;
}

// fun_phones_table_xml(inidphone integer, inidcontact integer, inenable boolean, inphone text, intypephone integer, inidprovider integer, ingeox real, ingeoy real, inphone_ext text, inidaddress text, inaddress text, inubiphone integer, innote text, ts timestamp without time zone)
 
public string fun_phones_table_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

int inidphone = 0;
int inidcontact = 0;
bool inenable = false;
string inphone = "";
int intypephone = 0;
int inidprovider = 0;
double ingeox = 0;
double ingeoy = 0;
string inphone_ext = "";
string inidaddress = "";
string inaddress = "";
int inubiphone = 0;
string innote = "";
string ints = "1990-01-01";

if(data.has_key("idcontact")){
inidcontact = int.parse(data["idcontact"]);
}

if(data.has_key("idphone")){
inidphone = int.parse(data["idphone"]);
}

if(data.has_key("enable")){
inenable = bool.parse(data["enable"]);
}

if(data.has_key("phone")){
inphone = data["phone"];
}

if(data.has_key("typephone")){
intypephone = int.parse(data["typephone"]);
}

if(data.has_key("idprovider")){
inidprovider = int.parse(data["idprovider"]);
}

if(data.has_key("geox")){
ingeox = double.parse(data["geox"]);
}

if(data.has_key("geoy")){
ingeoy = double.parse(data["geoy"]);
}

if(data.has_key("phone_ext")){
inphone_ext = data["phone_ext"];
}

if(data.has_key("idaddress")){
inidaddress = data["idaddress"];
}

if(data.has_key("ubiphone")){
inubiphone = int.parse(data["ubiphone"]);
}

if(data.has_key("note")){
innote = data["note"];
}

if(data.has_key("ts")){
ints = data["ts"];
}

return fun_phones_table_xml(inidphone, inidcontact, inenable, inphone, intypephone, inidprovider, ingeox, ingeoy, inphone_ext, inidaddress, inaddress, inubiphone, innote, ints, fieldtextasbase64);
}

public string fun_phones_table_xml(int inidphone, int inidcontact, bool inenable, string inphone, int intypephone, int inidprovider, double ingeox, double ingeoy, string inphone_ext, string inidaddress, string inaddress, int inubiphone, string innote, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {inidphone.to_string(), inidcontact.to_string(), inenable.to_string(), inphone, intypephone.to_string(), inidprovider.to_string(), ingeox.to_string(), ingeoy.to_string(), inphone_ext, inidaddress, inaddress, inubiphone.to_string(), innote, ints,  fieldtextasbase64.to_string()};
var Resultado = Conexion.exec_params ("""SELECT * FROM fun_phones_table_xml($1::integer, $2::integer, $3::boolean, $4::text, $5::integer, $6::integer, $7::real, $8::real, $9::text, $10::text, $11::text, $12::integer, $13::text, $14::timestamp without time zone, $15::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
//GLib.print(RetornoX);
return RetornoX;
}

public string byId_Xml(int idphone, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idphone.to_string(), fieldtextasbase64.to_string()};
var Resultado = Conexion.exec_params ("""SELECT * FROM fun_view_phones_byid_xml($1::integer, $2::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
//GLib.print(RetornoX);
return RetornoX;
}

/*
public PhoneTableRow byId(int idphone){

string[] valuesin = {idphone.to_string()};
PhoneTableRow Retorno = PhoneTableRow();
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT * FROM phones WHERE idphone = $1;""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){

Retorno.IdPhone = reg["idphone"].as_int();
Retorno.IdContact = reg["idcontact"].as_int();
Retorno.Enable = reg["enable"].as_bool();
Retorno.Phone = reg["phone"].Value;
Retorno.Type = reg["typephone"].as_int();
Retorno.IdProvider = reg["idprovider"].as_int();
Retorno.Note = reg["note"].Value;
Retorno.GeoX = reg["geox"].as_double();
Retorno.GeoY = reg["geoy"].as_double();
Retorno.IdAddress = reg["idaddress"].Value;
Retorno.PhoneExt = reg["phone_ext"].Value;
Retorno.UbiPhone = reg["ubiphone"].as_int();
Retorno.Address = reg["address"].Value;
Retorno.TimeStamp = reg["ts"].Value;

}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}

return Retorno;
}
*/

public string byIdContactXml(int idcontact){
var Rows = XmlDatas.Node("contacts");
foreach(var r in this.byIdContact(idcontact)){
Rows->add_child(PhoneTableRowNodeXml(r).Row());
}
return XmlDatas.XmlDocToString(Rows);
}

public string byIdContact_Xml(int idcontact, bool fieldtextasbase64 = true){
string RetornoX = "<table></table>";
if(idcontact > 0){
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcontact.to_string(), fieldtextasbase64.to_string()};
var Resultado = Conexion.exec_params ("""SELECT * FROM fun_view_phones_byidcontact_simplified_xml($1::integer, $2::boolean) AS return""", valuesin.length, null, valuesin, null, null, 0);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
}
GLib.print(RetornoX);
return RetornoX;
}

public PhoneTableRow[] byIdContact(int idcontact){

string[] valuesin = {idcontact.to_string()};
PhoneTableRow[] Retorno = new PhoneTableRow[0];
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = Conexion.exec_params ("""SELECT * FROM phones WHERE idcontact = $1;""", valuesin.length, null, valuesin, null, null, 0);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

var Registros = this.Result_FieldName(ref Resultado);
Retorno = new PhoneTableRow[Registros.length];
int i = 0;
foreach(var reg in Registros){
PhoneTableRow Registro = PhoneTableRow();
Registro.IdPhone = reg["idphone"].as_int();
Registro.IdContact = reg["idcontact"].as_int();
Registro.Enable = reg["enable"].as_bool();
Registro.Phone = reg["phone"].Value;
Registro.Type = reg["typephone"].as_int();
Registro.IdProvider = reg["idprovider"].as_int();
Registro.Note = reg["note"].Value;
Registro.GeoX = reg["geox"].as_double();
Registro.GeoY = reg["geoy"].as_double();
Registro.IdAddress = reg["idaddress"].Value;
Registro.PhoneExt = reg["phone_ext"].Value;
Registro.UbiPhone = reg["ubiphone"].as_int();
Registro.Address = reg["address"].Value;
Registro.TimeStamp = reg["ts"].Value;
Retorno[i] = Registro;
i++;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}

return Retorno;
}


}



}
