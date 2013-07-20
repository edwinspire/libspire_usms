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
using edwinspire.PDU;
using edwinspire.pgSQL;
using Postgres;



namespace edwinspire.uSMS{

/*
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
*/

public class PostgreSQLConnection:PostgreSqldb{

public void GetParamCnx(){
this.ParamCnx = TablePostgres.LastRowEnabled().Parameters;
}

}


public class TableSIM:PostgresuSMS{

public string fun_view_sim_idname_xml(bool fieldtextasbase64 = true){
string Retorno = "";
string[] ValuesArray = {fieldtextasbase64.to_string()};
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_sim_idname_xml($1::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;
}

public string fun_view_sim_xml(bool fieldtextasbase64 = true){
string Retorno = "";
string[] ValuesArray = {fieldtextasbase64.to_string()};
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_sim_xml($1::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;
}

public string fun_sim_table_edit_xml(int idsim, int idprovider, bool enable, bool enable_sendsms, string phone, bool smsout_request_reports, int smsout_retryonfail, int smsout_max_length, bool smsout_enabled_other_providers, int on_incommingcall, int dtmf_tone, int dtmf_tone_time, string note, bool fieldtextasbase64 = true){
string Retorno = "";

string[] ValuesArray = {idsim.to_string(), 
idprovider.to_string(), 
enable.to_string(), 
enable_sendsms.to_string(), 
phone, 
smsout_request_reports.to_string(), 
smsout_retryonfail.to_string(), 
smsout_max_length.to_string(), 
smsout_enabled_other_providers.to_string(), 
on_incommingcall.to_string(), 
dtmf_tone.to_string(), 
dtmf_tone_time.to_string(),
 note, 
fieldtextasbase64.to_string()};

var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_sim_table_edit_xml($1::integer, $2::integer, $3::boolean, $4::boolean, $5::text, $6::boolean, $7::integer, $8::integer, $9::boolean, $10::integer, $11::integer, $12::integer, $13::text, $14::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
}else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;

}

public string fun_sim_table_edit_xml_from_hashmap(HashMap<string, string> Form){

int idsim = 0;
int idprovider = 0;
bool enable = false;
bool enable_sendsms = false;
string phone = "";
bool smsout_request_reports = false;
int smsout_retryonfail = 0;
int smsout_max_length = 0;
//int smsout_max_lifetime = 0;
bool smsout_enabled_other_providers = false;
//int idmodem = 0;
int on_incommingcall = 0;
int dtmf_tone = (int)DTMF.Sharp;
int dtmf_tone_time = 0;
string note = "";

if(Form.has_key("idsim")){
idsim = int.parse(Form["idsim"]);
}

if(Form.has_key("idprovider")){
idprovider = int.parse(Form["idprovider"]);
}

if(Form.has_key("enable")){
enable = bool.parse(Form["enable"]);
}

if(Form.has_key("enable_sendsms")){
enable_sendsms = bool.parse(Form["enable_sendsms"]);
}

if(Form.has_key("phone")){
phone = Form["phone"];
}

if(Form.has_key("smsout_request_reports")){
smsout_request_reports = bool.parse(Form["smsout_request_reports"]);
}

if(Form.has_key("smsout_retryonfail")){
smsout_retryonfail = int.parse(Form["smsout_retryonfail"]);
}

if(Form.has_key("smsout_max_length")){
smsout_max_length = int.parse(Form["smsout_max_length"]);
}

if(Form.has_key("smsout_enabled_other_providers")){
smsout_enabled_other_providers = bool.parse(Form["smsout_enabled_other_providers"]);
}

if(Form.has_key("on_incommingcall")){
on_incommingcall = int.parse(Form["on_incommingcall"]);
}

if(Form.has_key("dtmf_tone")){
dtmf_tone = int.parse(Form["dtmf_tone"]);
}

if(Form.has_key("dtmf_tone_time")){
dtmf_tone_time = int.parse(Form["dtmf_tone_time"]);
}

if(Form.has_key("note")){
note = Form["note"];
}

return fun_sim_table_edit_xml(idsim, idprovider, enable, enable_sendsms, phone, smsout_request_reports, smsout_retryonfail, smsout_max_length, smsout_enabled_other_providers, on_incommingcall, dtmf_tone, dtmf_tone_time, note);
}



}



public class PostgresuSMS:PostgreSQLConnection{
public PostgresuSMS(){
}


public int fun_get_idsim(string phone){

string[] valuessms = {phone};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_get_idsim($1::text) as retorno;",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["retorno"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}

//fun_portmodem_update(inidport integer, inport text, incimi text, inimei text, inmanufacturer text, inmodel text, inrevision text)

public bool fun_portmodem_update(int inidport, string inport, string incimi, string inimei, string inmanufacturer, string inmodel, string inrevision){

string[] valuessms = {inidport.to_string(), inport, incimi, inimei, inmanufacturer, inmodel, inrevision};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_portmodem_update($1::integer, $2::text, $3::text, $4::text, $5::text, $6::text, $7::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_portmodem_update"].as_int();
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

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_currentportsproviders_insertupdate($1::integer, $2::text, $3::text, $4::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_currentportsproviders_insertupdate"].as_int();
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

public string fun_provider_delete_selection_xml(string idproviders, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {"{"+idproviders+"}", fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal(ref Conexion, "SELECT * FROM fun_provider_delete_selection_xml($1::int[], $2::boolean) AS return", valuesin);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
}else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
return RetornoX;
}


public int IdProviderFromCIMI(string cimi){

string[] valuesin = {cimi};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT idprovider FROM provider WHERE cimi LIKE $1::text AND enable = true;", valuesin);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
foreach(var fila in filas.entries){
if(fila.key == "idprovider"){
Retorno = fila.value.as_int();
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
// fun_incomingcalls_insert_online(inidport integer, inOnIncomingCall integer, inphone text, innote text)
public class TableCallIn:PostgresuSMS{


public TableCallIn(){

}

public int fun_incomingcalls_insert_online(int inidport, OnIncomingCall inOnIncomingCall, string inphone, string innote = ""){

string[] valuessms = {inidport.to_string(), ((int)inOnIncomingCall).to_string(), inphone, innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_incomingcalls_insert_online($1::integer, $2::integer, $3::text, $4::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_incomingcalls_insert_online"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}



return Retorno;
}

}


public class TableCity:PostgreSQLConnection{


public string fun_location_city_remove_selected_xml(string ids, bool fieldtextasbase64 = true){

string Retorno = "";

string[] ValuesArray = {"{"+ids+"}", fieldtextasbase64.to_string()};
//GLib.print("Llega hasta aqui 3 \n");
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_city_remove_selected_xml($1::integer[], $2::boolean) AS return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}
return Retorno;
}

public string fun_location_city_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

string RetornoX = "";
int id = 0;
int idstate = 0;
string name = "";
string code = "";
string ts = "1990-01-01";

if(data.has_key("idstate")){
idstate = int.parse(data["idstate"]);
}

if(data.has_key("idcity")){
id = int.parse(data["idcity"]);
}


if(data.has_key("name")){
name = data["name"];
}

if(data.has_key("code")){
code = data["code"];
}

if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {idstate.to_string(), id.to_string(), name, code, ts, fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_city_edit_xml($1::integer, $2::integer, $3::text, $4::text, $5::timestamp without time zone, $6::boolean) AS return", valuesin);

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

public string fun_view_city_by_idstate_xml(int idcountry, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {idcountry.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_city_by_idstate_xml($1::integer, $2::boolean) AS return", valuesin);

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

}


public class TableState:PostgreSQLConnection{


public string fun_location_state_remove_selected_xml(string ids, bool fieldtextasbase64 = true){
string Retorno = "";
string[] ValuesArray = {"{"+ids+"}", fieldtextasbase64.to_string()};
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_state_remove_selected_xml($1::integer[], $2::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;
}

public string fun_location_state_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){
string RetornoX = "";
int id = 0;
int idcountry = 0;
string name = "";
string code = "";
string ts = "1990-01-01";
if(data.has_key("idstate")){
id = int.parse(data["idstate"]);
}
if(data.has_key("idcountry")){
idcountry = int.parse(data["idcountry"]);
}
if(data.has_key("name")){
name = data["name"];
}
if(data.has_key("code")){
code = data["code"];
}
if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcountry.to_string(), id.to_string(), name, code, ts, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_state_edit_xml($1::integer, $2::integer, $3::text, $4::text, $5::timestamp without time zone, $6::boolean) AS return", valuesin);
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

public string fun_view_state_by_idcountry_xml(int idcountry, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcountry.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_state_by_idcountry_xml($1::integer, $2::boolean) AS return", valuesin);
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
}

public class TableSector:PostgreSQLConnection{

public string fun_location_sector_remove_selected_xml(string ids, bool fieldtextasbase64 = true){
string Retorno = "";
string[] ValuesArray = {"{"+ids+"}", fieldtextasbase64.to_string()};
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_sector_remove_selected_xml($1::integer[], $2::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;
}

public string fun_location_sector_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){
string RetornoX = "";
int id = 0;
int idcity = 0;
string name = "";
string ts = "1990-01-01";
if(data.has_key("idsector")){
id = int.parse(data["idsector"]);
}
if(data.has_key("idcity")){
idcity = int.parse(data["idcity"]);
}
if(data.has_key("name")){
name = data["name"];
}
if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcity.to_string(), id.to_string(), name, ts, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_sector_edit_xml($1::integer, $2::integer, $3::text, $4::timestamp without time zone, $5::boolean) AS return", valuesin);
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

public string fun_view_sector_by_idcity_xml(int idcity, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcity.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_sector_by_idcity_xml($1::integer, $2::boolean) AS return", valuesin);
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
}



public class TableSubSector:PostgreSQLConnection{

public string fun_location_subsector_remove_selected_xml(string ids, bool fieldtextasbase64 = true){
string Retorno = "";
string[] ValuesArray = {"{"+ids+"}", fieldtextasbase64.to_string()};
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_subsector_remove_selected_xml($1::integer[], $2::boolean) AS return;",  ValuesArray);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}
} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}
return Retorno;
}

public string fun_location_subsector_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){
string RetornoX = "";
int id = 0;
int idsector = 0;
string name = "";
string ts = "1990-01-01";
if(data.has_key("idsubsector")){
id = int.parse(data["idsubsector"]);
}
if(data.has_key("idsector")){
idsector = int.parse(data["idsector"]);
}
if(data.has_key("name")){
name = data["name"];
}
if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idsector.to_string(), id.to_string(), name, ts, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_subsector_edit_xml($1::integer, $2::integer, $3::text, $4::timestamp without time zone, $5::boolean) AS return", valuesin);
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

public string fun_view_subsector_by_idsector_xml(int idsector, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idsector.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_subsector_by_idsector_xml($1::integer, $2::boolean) AS return", valuesin);
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
}


public class LocationLevel:PostgreSQLConnection{

public string fun_location_level_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

string RetornoX = "";
int idpk = 0;
int level = 0;
int idfk = 0;
string name = "";
string code = "";
string ts = "1990-01-01";

if(data.has_key("level")){
level = int.parse(data["level"]);
}
if(data.has_key("idpk")){
idpk = int.parse(data["idpk"]);
}
if(data.has_key("idfk")){
idfk = int.parse(data["idfk"]);
}
if(data.has_key("name")){
name = data["name"];
}
if(data.has_key("code")){
code = data["code"];
}
if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {level.to_string(), idpk.to_string(), idfk.to_string(), name, code, ts, fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_level_edit_xml($1::integer, $2::integer, $3::integer, $4::text, $5::text, $6::timestamp without time zone, $7::boolean) AS return", valuesin);

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

public string fun_view_location_level_xml(HashMap<string, string> data, bool fieldtextasbase64 = true){

int idfk = 0;
int level = 0;

if(data.has_key("idfk")){
idfk = int.parse(data["idfk"]);
}

if(data.has_key("level")){
level = int.parse(data["level"]);
}


string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {level.to_string(), idfk.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_location_level_xml($1::integer, $2::integer, $3::boolean) AS return", valuesin);

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


public string fun_location_level_remove_selected_xml(int level, string ids, bool fieldtextasbase64 = true){

string Retorno = "";

string[] ValuesArray = {level.to_string(), "{"+ids+"}", fieldtextasbase64.to_string()};
//GLib.print("Llega hasta aqui 3 \n");
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_level_remove_selected_xml($1::integer, $2::integer[], $3::boolean) AS return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}
return Retorno;
}

public string fun_view_locations_ids_from_idlocation_xml(int idlocation){

string Retorno = "";

string[] ValuesArray = {idlocation.to_string()};
//GLib.print("Llega hasta aqui 3 \n");
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_locations_ids_from_idlocation_xml($1::integer) AS return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}
return Retorno;
}



}



public class TableLocationLevel1:PostgreSQLConnection{


public string fun_location_level1_remove_selected_xml(string ids, bool fieldtextasbase64 = true){

string Retorno = "";

string[] ValuesArray = {"{"+ids+"}", fieldtextasbase64.to_string()};
//GLib.print("Llega hasta aqui 3 \n");
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_level1_remove_selected_xml($1::integer[], $2::boolean) AS return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}
return Retorno;
}

public string fun_location_level1_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

string RetornoX = "";
int id = 0;
string name = "";
string code = "";
string ts = "1990-01-01";

if(data.has_key("idl1")){
id = int.parse(data["idl1"]);
}

if(data.has_key("name")){
name = data["name"];
}

if(data.has_key("code")){
code = data["code"];
}

if(data.has_key("ts")){
ts = data["ts"];
}

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {id.to_string(), name, code, ts, fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_location_level1_edit_xml($1::integer, $2::text, $3::text, $4::timestamp without time zone, $5::boolean) AS return", valuesin);

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

public string fun_view_location_level1_xml(bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_location_level1_xml($1::boolean) AS return", valuesin);

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

}


public class TableIncomingCalls:PostgreSQLConnection{


public TableIncomingCalls(){


}

//fun_view_incomingcalls_xml(datestart timestamp without time zone, dateend timestamp without time zone, fieldtextasbase64 boolean)
public string fun_view_incomingcalls_xml(string datestart, string dateend, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {datestart.to_string(), dateend.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_incomingcalls_xml($1::timestamp without time zone, $2::timestamp without time zone, $3::boolean) AS return", valuesin);

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


}


public class TableContacts:PostgreSQLConnection{


public TableContacts(){

}

public string  fun_contact_address_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){ 

int idcontact = 0;

if(data.has_key("idcontact")){
idcontact = int.parse(data["idcontact"]);
}
AddressRowData RowData = AddressTable.rowdata_from_hashmap(data);

return fun_contact_address_edit_xml(idcontact, RowData.idlocation, RowData.geox, RowData.geoy, RowData.f1, RowData.f2, RowData.f3, RowData.f4, RowData.f5, RowData.f6, RowData.f7, RowData.f8, RowData.f9, RowData.f10, RowData.ts, fieldtextasbase64);
}

public string  fun_contact_address_edit_xml(int idcontact, int inidlocation, double ingeox, double ingeoy, string f1, string f2, string f3, string f4, string f5, string f6, string f7, string f8, string f9, string f10, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcontact.to_string(), inidlocation.to_string(), ingeox.to_string(), ingeoy.to_string(), f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, ints, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM  fun_contact_address_edit_xml($1::integer, $2::integer, $3::double precision, $4::double precision, $5::text, $6::text,  $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::text, $14::text, $15::timestamp without time zone, $16::boolean) AS return;", valuesin);
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

public string fun_contacts_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){
int inidcontact = 0;
bool inenable = false;
string intitle = "";
string infirstname = "";
string inlastname = "";
int ingender = 0;
string inbirthday = "1990-01-01";
int intypeofid = 0;
string inidentification = "";
string inweb = "";
string inemail1 = "";
string inemail2 = "";
int inidaddress = 0;
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
inidaddress = int.parse(data["idaddress"]);
}

if(data.has_key("note")){
innote = data["note"];
}


return fun_contacts_edit_xml(inidcontact, inenable, intitle, infirstname, inlastname, ingender, inbirthday, intypeofid, inidentification, inweb, inemail1, inemail2, inidaddress, innote, fieldtextasbase64);
}

//fun_contacts_table_xml(inidcontact integer, inenable boolean, intitle text, infirstname text, inlastname text, ingender integer, inbirthday date, intypeofid integer, inidentification text, inweb text, inemail1 text, inemail2 text, inidaddress text, innote text)
 
public string fun_contacts_edit_xml(int inidcontact, bool inenable, string intitle, string infirstname, string inlastname, int ingender, string inbirthday, int intypeofid, string inidentification, string inweb, string inemail1, string inemail2, int inidaddress, string innote, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {inidcontact.to_string(), inenable.to_string(), intitle, infirstname, inlastname, ingender.to_string(), inbirthday, intypeofid.to_string(), inidentification, inweb, inemail1, inemail2, inidaddress.to_string(), innote, fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_contacts_edit_xml($1::integer, $2::boolean, $3::text, $4::text, $5::text, $6::integer, $7::date, $8::integer, $9::text, $10::text, $11::text, $12::text, $13::integer, $14::text, $15::boolean) AS return;", valuesin);

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
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_contacts_byidcontact_xml($1::integer, $2::boolean) AS return;", valuesin);
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

public string NameAndId_All_Xml(bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_contacts_to_list_xml($1::boolean) AS return;", valuesin);

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

public string NameAndId_Search_Xml(string text, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {text, fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_contacts_to_list_search_xml($1::text, $2::boolean) AS return;", valuesin);

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

public HashMap<int, string> NameAndId_All(){

string[] valuesin = {"lastname"};
HashMap<int, string> RetornoX = new HashMap<int, string>();
RetornoX[0] = "Ninguno seleccionado";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT idcontact, enable, lastname, firstname FROM contacts ORDER BY $1;", valuesin);

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



public class TableSMSIn:PostgreSQLConnection{

public TableSMSIn(){

}

// fun_view_smsout_table_filter(timestamp without time zone, timestamp without time zone, integer, boolean);
public string fun_view_smsin_table_filter_xml(string start, string end, int rows, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {start, end, rows.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_smsin_table_filter_xml($1::timestamp without time zone, $2::timestamp without time zone, $3::integer,  $4::boolean) AS return", valuesin);

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


public int fun_smsin_insert(int inidport, SMS_Status instatus, Datetime indatesms, string inphone, string inmsj, string innote = ""){

string[] valuessms = {inidport.to_string(), ((int)instatus).to_string(), indatesms.to_string(), inphone, inmsj, innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_smsin_insert($1::integer, $2::integer, $3::timestamp without time zone, $4::text, $5::text, $6::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsin_insert"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}



return Retorno;
}

}

public class TableOutgoing:PostgresuSMS{

private struct FieldsSend{
int idowner;
int idphone;
DateTime date;
string phone;
string msg;
int priority;
int idprovider;
int idsim;
int idsmstype;
bool report;
bool enablemsgclass;
edwinspire.PDU.DCS_MESSAGE_CLASS msgclass;
string note;
bool fieldtextasbase64;
}


public TableOutgoing(){
}


public HashMap<string, PgField> ToSend(int IdSIM){

var Retorno = new HashMap<string, PgField>();
string[] valuesin = {IdSIM.to_string()};

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_outgoing_tosend($1::integer);", valuesin);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
Retorno = reg;
// El break es para tomar solo 1 registro
break;
}

} else {
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}

public int log(int idsmsout, int idsim, SMSOutStatus status, int parts, int part){

var Retorno = 0;
string[] valuesin = {idsmsout.to_string(), idsim.to_string(), ((int)status).to_string(), parts.to_string(), part.to_string()};

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_outgoing_log_insert($1::integer, $2::integer, $3::integer, $4::integer, $5::integer) as retorno;", valuesin);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
Retorno = reg["retorno"].as_int();
// El break es para tomar solo 1 registro
break;
}

} else {
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}

public string fun_view_outgoing_view_filter_xml(string start, string end, int rows, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {start, end, rows.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_outgoing_view_filter_xml($1::timestamp without time zone, $2::timestamp without time zone, $3::integer,  $4::boolean) AS return", valuesin);

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

public int fun_outgoing_new(int idowner, int inidphone, string inphone, string inmsg,  DateTime indatetosend = new DateTime.now_local(),  int inpriority = 5, int inidprovider = 0, int inidsim = 0, int inidsmstype = 0, bool inreport = false, bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = ""){

string[] valuessms = {inidprovider.to_string(), inidsim.to_string(), inidsmstype.to_string(), inidphone.to_string(), inphone, inmsg, indatetosend.to_string(), inpriority.to_string(), inreport.to_string(), inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), idowner.to_string(), innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_outgoing_new($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::text, $7::timestamp without time zone, $8::integer, $9::boolean, $10::boolean, $11::integer, $12::integer, $13::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_insert"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}

public string fun_outgoing_new_xml_from_hashmap(HashMap<string, string> Data){

FieldsSend Campos = FieldsSendFromHashMap(Data);

return fun_outgoing_new_xml(Campos.idowner, Campos.idphone, Campos.phone, Campos.msg, Campos.date, Campos.priority , Campos.idprovider, Campos.idsim, Campos.idsmstype, Campos.report, Campos.enablemsgclass , Campos.msgclass, Campos.note, Campos.fieldtextasbase64);
}

public string fun_outgoing_new_xml(int idowner, int inidphone, string inphone, string inmsg,  DateTime indatetosend = new DateTime.now_local(),  int inpriority = 5, int inidprovider = 0, int inidsim = 0, int inidsmstype = 0, bool inreport = false, bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = "", bool fieldtextasbase64 = true){

string[] valuessms = {inidprovider.to_string(), inidsim.to_string(), inidsmstype.to_string(), inidphone.to_string(), inphone, inmsg, indatetosend.to_string(), inpriority.to_string(), inreport.to_string(), inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), idowner.to_string(), innote, fieldtextasbase64.to_string()};
string Retorno = "<table></table>";
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_outgoing_new_xml($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::text, $7::timestamp without time zone, $8::integer, $9::boolean, $10::boolean, $11::integer, $12::integer, $13::text, $14::boolean) as return;",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}


public int fun_outgoing_new_now(int idowner, int inidphone, string inphone, string inmsg, int inpriority = 5, int inidprovider = 0, int inidsim = 0, int inidsmstype = 0, bool inreport = false, bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = ""){

string[] valuessms = {inidprovider.to_string(), inidsim.to_string(), inidsmstype.to_string(), inidphone.to_string(), inphone, inmsg,  inpriority.to_string(), inreport.to_string(), inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), idowner.to_string(), innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_outgoing_new_now($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::text, $7::integer, $8::boolean, $9::boolean, $10::integer, $11::integer, $12::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_insert"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}

private FieldsSend FieldsSendFromHashMap(HashMap<string, string> Data){

FieldsSend Retorno = FieldsSend();

Retorno.idowner = 0;
Retorno.idphone = 0;
Retorno.phone = "";
Retorno.date = new DateTime.now_local();
Retorno.msg = "";
Retorno.priority = 5;
Retorno.idprovider = 0;
Retorno.idsim = 0;
Retorno.idsmstype = 0;
Retorno.report = false;
Retorno.enablemsgclass = false;
Retorno.msgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC;
Retorno.note = "";
Retorno.fieldtextasbase64 = true;

if(Data.has_key("idowner")){
Retorno.idowner = int.parse(Data["idowner"]);
}

if(Data.has_key("idphone")){
Retorno.idphone = int.parse(Data["idphone"]);
}

if(Data.has_key("phone")){
Retorno.phone = Data["phone"];
}

if(Data.has_key("date")){
TimeVal t = TimeVal();
if(t.from_iso8601(Data["date"])){
Retorno.date = new DateTime.from_timeval_local(t);
}
}


if(Data.has_key("message")){
Retorno.msg = Data["message"];
}

if(Data.has_key("priority")){
Retorno.priority = int.parse(Data["priority"]);
}

if(Data.has_key("idprovider")){
Retorno.idprovider = int.parse(Data["idprovider"]);
}

if(Data.has_key("idsim")){
Retorno.idsim = int.parse(Data["idsim"]);
}

if(Data.has_key("report")){
Retorno.report = bool.parse(Data["report"]);
}

if(Data.has_key("enablemsgclass")){
Retorno.enablemsgclass = bool.parse(Data["enablemsgclass"]);
}


if(Data.has_key("msgclass")){
Retorno.msgclass = (edwinspire.PDU.DCS_MESSAGE_CLASS)int.parse(Data["msgclass"]);
}

if(Data.has_key("note")){
Retorno.note = Data["note"];
}

if(Data.has_key("fieldtextasbase64")){
Retorno.fieldtextasbase64 = bool.parse(Data["fieldtextasbase64"]);
}


return Retorno;
}



public string fun_outgoing_new_now_xml_from_hashmap(HashMap<string, string> Data){

FieldsSend Campos = FieldsSendFromHashMap(Data);

return fun_outgoing_new_now_xml(Campos.idowner, Campos.idphone, Campos.phone, Campos.msg, Campos.priority , Campos.idprovider, Campos.idsim, Campos.idsmstype, Campos.report, Campos.enablemsgclass , Campos.msgclass, Campos.note, Campos.fieldtextasbase64);
}


public string fun_outgoing_new_now_xml(int idowner, int inidphone, string inphone, string inmsg, int inpriority = 5, int inidprovider = 0, int inidsim = 0, int inidsmstype = 0, bool inreport = false, bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = "", bool fieldtextasbase64 = true){

string[] valuessms = {inidprovider.to_string(), inidsim.to_string(), inidsmstype.to_string(), inidphone.to_string(), inphone, inmsg,  inpriority.to_string(), inreport.to_string(), inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), idowner.to_string(), innote, fieldtextasbase64.to_string()};
string Retorno = "<table></table>";
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_outgoing_new_now_xml($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::text, $7::integer, $8::boolean, $9::boolean, $10::integer, $11::integer, $12::text, $13:.boolean) as return;",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}



}




/*

public class TableSMSOutxxx:PostgresuSMS{


public TableSMSOutxxx(){

}

// fun_smsout_to_send(inidprovider integer DEFAULT 0)
public SMSOutRow ToSend(int IdProvider){

string[] valuesin = {IdProvider.to_string()};
SMSOutRow Retorno = new SMSOutRow();
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT idsmsout, phone, message, messageclass, enablemessageclass, report, maxslices FROM fun_smsout_to_send($1::integer);", valuesin);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var reg in this.Result_FieldName(ref Resultado)){
Retorno.Index = reg["idsmsout"].as_uint();
Retorno.Phone = reg["phone"].Value;
Retorno.Text = reg["message"].Value;
Retorno.MessageClass = (edwinspire.PDU.DCS_MESSAGE_CLASS)reg["messageclass"].as_int();
Retorno.enableMessageClass = reg["enablemessageclass"].as_bool();
Retorno.StatusReport = reg["report"].as_bool();
Retorno.MaxSlices = reg["maxslices"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}
// fun_view_smsout_table_filter(timestamp without time zone, timestamp without time zone, integer, boolean);
public string fun_view_smsout_table_filter_xml(string start, string end, int rows, bool fieldtextasbase64 = true){

string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

string[] valuesin = {start, end, rows.to_string(), fieldtextasbase64.to_string()};

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_smsout_table_filter_xml($1::timestamp without time zone, $2::timestamp without time zone, $3::integer,  $4::boolean) AS return", valuesin);

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

//fun_smsout_insert(inidprovider integer, inidsmstype integer, inidphone integer, inpriority integer, inphone text, inretryonfail boolean, indatetosend timestamp without time zone, inmessage text, innote text)

public int fun_smsout_insert(int inidphone, string inphone, string inmessage, int inidprovider = 0, int inidsmstype = 0, int inpriority = 5,  DateTime indatetosend = new DateTime.now_local(), bool inenablemsgclass = false, edwinspire.PDU.DCS_MESSAGE_CLASS inmsgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, string innote = ""){

string[] valuessms = {inidprovider.to_string(), inidsmstype.to_string(), inidphone.to_string(), inpriority.to_string(), inphone, indatetosend.to_string(), inmessage, inenablemsgclass.to_string(), ((int)inmsgclass).to_string(), innote};
int Retorno = -1;
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_smsout_insert($1::integer, $2::integer, $3::integer, $4::integer, $5::text, $6::timestamp without time zone, $7::text, $8::boolean, $9::integer, $10::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_insert"].as_int();
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

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT fun_smsout_updatestatus($1::integer, $2::integer, $3::integer, $4::integer, $5::integer, $6::text);",  valuessms);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["fun_smsout_updatestatus"].as_int();
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}


return Retorno;
}


}

*/

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


public class ProviderTable:PostgreSQLConnection{

public string fun_provider_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

int inidprovider = 0;
bool inenable = false;
//string incimi = "";
string inname = "";
string innote = "";
string ints = "1990-01-01";

if(data.has_key("idprovider")){
inidprovider = int.parse(data["idprovider"]);
}

if(data.has_key("enable")){
inenable = bool.parse(data["enable"]);
}


if(data.has_key("name")){
inname = data["name"];
}

if(data.has_key("note")){
innote = data["note"];
}

if(data.has_key("ts")){
ints = data["ts"];
}

return fun_provider_edit_xml(inidprovider, inenable, inname, innote, ints, fieldtextasbase64);
}

//fun_provider_edit(IN inidprovider integer, IN inenable boolean, IN incimi text, IN inname text, IN innote text, IN ints timestamp without time zone, IN fieldtextasbase64 boolean, OUT outreturn integer, OUT outpgmsg text)
public string fun_provider_edit_xml(int inidprovider, bool inenable,  string inname, string innote, string ints, bool fieldtextasbase64 = true){

string Retorno = "";

string[] ValuesArray = {inidprovider.to_string(), inenable.to_string(), inname, innote, ints, fieldtextasbase64.to_string()};

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_provider_edit_xml($1::integer, $2::boolean, $3::text, $4::text, $5::timestamp without time zone, $6::boolean) as return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}



public string fun_view_provider_table_xml(bool fieldtextasbase64 = true){

string Retorno = "";

string[] ValuesArray = {fieldtextasbase64.to_string()};

var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_provider_table_xml($1::boolean) as return;",  ValuesArray);

    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {

foreach(var filas in this.Result_FieldName(ref Resultado)){
Retorno = filas["return"].Value;
}

} else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }

}

return Retorno;
}

public string idname_Xml(bool fieldtextasbase64 = true){
string RetornoX = "";

var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_providers_idname_xml($1::boolean) AS return", valuesin);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
}else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}

return RetornoX;
}


}







public struct AddressRowData{
int idaddress;
int idlocation;
double geox;
double geoy;
string f1;
string f2; 
string f3;
string f4;
string f5;
string f6; 
string f7;
string f8;
string f9;
string f10;
string ts;
public AddressRowData.default(){
this.idaddress = 0;
this.idlocation = 0;
this.geox = 0;
this.geoy = 0;
this.f1 = "";
this.f2 = ""; 
this.f3 = "";
this.f4 = "";
this.f5 = "";
this.f6 = ""; 
this.f7 = "";
this.f8 = "";
this.f9 = "";
this.f10 = "";
this.ts = "1990-01-01";
}
}


public class AddressTable:PostgreSQLConnection{

//fun_address_edit_xml(inidaddress integer, inidlocation text, ingeox real, ingeoy real, inmstreet text, insstreet text, inother text, innote text, ints timestamp without time zone, fieldtextasbase64 boolean)

public static AddressRowData rowdata_from_hashmap(HashMap<string, string> data){

AddressRowData DataRow = AddressRowData.default();

if(data.has_key("idaddress")){
DataRow.idaddress = int.parse(data["idaddress"]);
}

if(data.has_key("idlocation")){
DataRow.idlocation = int.parse(data["idlocation"]);
}

if(data.has_key("geox")){
DataRow.geox = double.parse(data["geox"]);
}

if(data.has_key("geoy")){
DataRow.geoy = double.parse(data["geoy"]);
}


if(data.has_key("f1")){
DataRow.f1 = data["f1"];
}

if(data.has_key("f2")){
DataRow.f2 = data["f2"];
}

if(data.has_key("f3")){
DataRow.f3 = data["f3"];
}

if(data.has_key("f4")){
DataRow.f4 = data["f4"];
}

if(data.has_key("f5")){
DataRow.f5 = data["f5"];
}

if(data.has_key("f6")){
DataRow.f6 = data["f6"];
}

if(data.has_key("f7")){
DataRow.f7 = data["f7"];
}

if(data.has_key("f8")){
DataRow.f8 = data["f8"];
}

if(data.has_key("f9")){
DataRow.f9 = data["f9"];
}

if(data.has_key("f10")){
DataRow.f10 = data["f10"];
}


if(data.has_key("ts")){
DataRow.ts = data["ts"];
}

return DataRow;
}


public string fun_address_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){ 



/*
int inidaddress = 0;
string inidlocation = "";
double ingeox = 0;
double ingeoy = 0;
string f1 = "";
string f2 = ""; 
string f3 = "";
string f4 = "";
string f5 = "";
string f6 = ""; 
string f7 = "";
string f8 = "";
string f9 = "";
string f10 = "";

string ints = "1990-01-01";

if(data.has_key("idaddress")){
inidaddress = int.parse(data["idaddress"]);
}

if(data.has_key("idlocation")){
inidlocation = data["idlocation"];
}

if(data.has_key("geox")){
ingeox = double.parse(data["geox"]);
}

if(data.has_key("geoy")){
ingeoy = double.parse(data["geoy"]);
}


if(data.has_key("f1")){
f1 = data["f1"];
}

if(data.has_key("f2")){
f2 = data["f2"];
}

if(data.has_key("f3")){
f3 = data["f3"];
}

if(data.has_key("f4")){
f4 = data["f4"];
}

if(data.has_key("f5")){
f5 = data["f5"];
}

if(data.has_key("f6")){
f6 = data["f6"];
}

if(data.has_key("f7")){
f7 = data["f7"];
}

if(data.has_key("f8")){
f8 = data["f8"];
}

if(data.has_key("f9")){
f9 = data["f9"];
}

if(data.has_key("f10")){
f10 = data["f10"];
}


if(data.has_key("ts")){
ints = data["ts"];
}

*/

AddressRowData RowData = AddressTable.rowdata_from_hashmap(data);

return fun_address_edit_xml(RowData.idaddress, RowData.idlocation, RowData.geox, RowData.geoy, RowData.f1, RowData.f2, RowData.f3, RowData.f4, RowData.f5, RowData.f6, RowData.f7, RowData.f8, RowData.f9, RowData.f10, RowData.ts, fieldtextasbase64);
}


public string fun_address_edit_xml(int inidaddress, int inidlocation, double ingeox, double ingeoy, string f1, string f2, string f3, string f4, string f5, string f6, string f7, string f8, string f9, string f10, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {inidaddress.to_string(), inidlocation.to_string(), ingeox.to_string(), ingeoy.to_string(), f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, ints, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_address_edit_xml($1::integer, $2::integer, $3::double precision, $4::double precision, $5::text, $6::text,  $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::text, $14::text, $15::timestamp without time zone, $16::boolean) AS return;", valuesin);
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

public string fun_view_address_byid_xml(int idaddress, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idaddress.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_address_byid_xml($1::integer, $2::boolean) AS return;", valuesin);
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

}


public class PhoneTable:PostgreSQLConnection{

public string fun_view_contacts_phones_with_search_xml(string contact_phone_search, string exclude_idphones, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {contact_phone_search, "{"+exclude_idphones+"}", fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal(ref Conexion, "SELECT * FROM fun_view_contacts_phones_with_search_xml($1::text, $2::int[], $3::boolean) AS return", valuesin);
    if (Resultado.get_status () == ExecStatus.TUPLES_OK) {
foreach(var reg in this.Result_FieldName(ref Resultado)){
RetornoX = reg["return"].Value;
}
}else{
	        stderr.printf ("FETCH ALL failed: %s", Conexion.get_error_message ());
    }
}else{
	        stderr.printf ("Conexion failed: %s", Conexion.get_error_message ());
}
return RetornoX;
}


/*
public string fun_phone_address_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){ 

int idphone = 0;
string inidlocation = "";
double ingeox = 0;
double ingeoy = 0;
string inmstreet = "";
string insstreet = ""; 
string inother = "";
string innote = "";
string ints = "1990-01-01";

if(data.has_key("idphone")){
idphone = int.parse(data["idphone"]);
}

if(data.has_key("idlocation")){
inidlocation = data["idlocation"];
}

if(data.has_key("geox")){
ingeox = double.parse(data["geox"]);
}

if(data.has_key("geoy")){
ingeoy = double.parse(data["geoy"]);
}


if(data.has_key("main_street")){
inmstreet = data["main_street"];
}

if(data.has_key("secundary_street")){
insstreet = data["secundary_street"];
}

if(data.has_key("other")){
inother = data["other"];
}

if(data.has_key("note")){
innote = data["note"];
}

if(data.has_key("ts")){
ints = data["ts"];
}

return fun_phones_address_edit_xml(idphone, inidlocation, ingeox, ingeoy, inmstreet, insstreet, inother, innote, ints, fieldtextasbase64);
}


public string fun_phones_address_edit_xml(int idphone, string inidlocation, double ingeox, double ingeoy, string inmstreet, string insstreet,  string inother, string innote, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
//GLib.print("idphone = %s\n", idphone.to_string());
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idphone.to_string(), inidlocation, ingeox.to_string(), ingeoy.to_string(), inmstreet, insstreet, inother, innote, ints, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_phones_address_edit_xml($1::integer, $2::text, $3::double precision, $4::double precision, $5::text, $6::text,  $7::text, $8::text, $9::timestamp without time zone, $10::boolean) AS return;", valuesin);
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
*/




public string  fun_phones_address_edit_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){ 

int idphone = 0;

if(data.has_key("idphone")){
idphone = int.parse(data["idphone"]);
}

AddressRowData RowData = AddressTable.rowdata_from_hashmap(data);

return fun_contact_phones_edit_xml(idphone, RowData.idlocation, RowData.geox, RowData.geoy, RowData.f1, RowData.f2, RowData.f3, RowData.f4, RowData.f5, RowData.f6, RowData.f7, RowData.f8, RowData.f9, RowData.f10, RowData.ts, fieldtextasbase64);
}

public string  fun_contact_phones_edit_xml(int idphone, int inidlocation, double ingeox, double ingeoy, string f1, string f2, string f3, string f4, string f5, string f6, string f7, string f8, string f9, string f10, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idphone.to_string(), inidlocation.to_string(), ingeox.to_string(), ingeoy.to_string(), f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, ints, fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM  fun_phones_address_edit_xml($1::integer, $2::integer, $3::double precision, $4::double precision, $5::text, $6::text,  $7::text, $8::text, $9::text, $10::text, $11::text, $12::text, $13::text, $14::text, $15::timestamp without time zone, $16::boolean) AS return;", valuesin);
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
*/

// fun_phones_table_xml(inidphone integer, inidcontact integer, inenable boolean, inphone text, intypephone integer, inidprovider integer, ingeox real, ingeoy real, inphone_ext text, inidaddress text, inaddress text, inubiphone integer, innote text, ts timestamp without time zone)
 
public string fun_phones_table_xml_from_hashmap(HashMap<string, string> data, bool fieldtextasbase64 = true){

int inidphone = 0;
int inidcontact = 0;
bool inenable = false;
string inphone = "";
int intypephone = 0;
int inidprovider = 0;
string inphone_ext = "";
int inidaddress = 0;
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

if(data.has_key("phone_ext")){
inphone_ext = data["phone_ext"];
}

if(data.has_key("idaddress")){
inidaddress = int.parse(data["idaddress"]);
}


if(data.has_key("ubiphone")){
inubiphone = int.parse(data["ubiphone"]);
}

if(data.has_key("note")){
innote = data["note"];
}

if(data.has_key("ts")){
if(data["ts"].length > 8){
ints = data["ts"];
}
}

return fun_phones_table_xml(inidphone, inidcontact, inenable, inphone, intypephone, inidprovider, inphone_ext, inidaddress, inubiphone, innote, ints, fieldtextasbase64);
}

public string fun_phones_table_xml(int inidphone, int inidcontact, bool inenable, string inphone, int intypephone, int inidprovider, string inphone_ext, int inidaddress, int inubiphone, string innote, string ints, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {inidphone.to_string(), inidcontact.to_string(), inenable.to_string(), inphone, intypephone.to_string(), inidprovider.to_string(), inphone_ext, inidaddress.to_string(), inubiphone.to_string(), innote, ints,  fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_phones_table_xml($1::integer, $2::integer, $3::boolean, $4::text, $5::integer, $6::integer, $7::text, $8::integer, $9::integer, $10::text, $11::timestamp without time zone, $12::boolean) AS return;", valuesin);
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

public string byId_Xml(int idphone, bool fieldtextasbase64 = true){
string RetornoX = "";
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idphone.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_phones_byid_xml($1::integer, $2::boolean) AS return", valuesin);
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
public string byIdContactXml(int idcontact){
var Rows = XmlDatas.Node("contacts");
foreach(var r in this.byIdContact(idcontact)){
Rows->add_child(PhoneTableRowNodeXml(r).Row());
}
return XmlDatas.XmlDocToString(Rows);
}
*/

public string byIdContact_Xml(int idcontact, bool fieldtextasbase64 = true){
string RetornoX = "<table></table>";
if(idcontact > 0){
var  Conexion = Postgres.connect_db (this.ConnString());
if(Conexion.get_status () == ConnectionStatus.OK){
string[] valuesin = {idcontact.to_string(), fieldtextasbase64.to_string()};
var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM fun_view_phones_byidcontact_simplified_xml($1::integer, $2::boolean) AS return", valuesin);
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
return RetornoX;
}

public PhoneTableRow[] byIdContact(int idcontact){

string[] valuesin = {idcontact.to_string()};
PhoneTableRow[] Retorno = new PhoneTableRow[0];
var  Conexion = Postgres.connect_db (this.ConnString());

if(Conexion.get_status () == ConnectionStatus.OK){

var Resultado = this.exec_params_minimal (ref Conexion, "SELECT * FROM phones WHERE idcontact = $1;", valuesin);

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
