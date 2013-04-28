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

//S.Index = "usms.html";

print("Start uSMSd Version: %s\n", edwinspire.uSMS.VERSION);
print("Licence: LGPL\n");
print("Contact: edwinspire@gmail.com\n");

//S.Port = 8080;

foreach(var U in VirtualUrls().entries){
S.VirtualUrl[U.key] = U.value;  
}

S.RequestVirtualUrl.connect(RequestVirtualPageHandler);

}

public static HashMap<string, string> VirtualUrls(){
var Retorno = new HashMap<string, string>();
Retorno["usms_smsoutviewtablefilter"] = "/usms_smsoutviewtablefilter";
Retorno["usms_smsinviewtablefilter"] = "/usms_smsinviewtablefilter";
Retorno["getpostgresconf"] = "/getpostgresconf";
Retorno["postpostgresconf"] = "/postpostgresconf";
Retorno["gettableserialport"] = "/gettableserialport";
Retorno["posttableserialport"] = "/posttableserialport";
Retorno["usms_getcontactslistidcontactname_xml"] = "/usms_getcontactslistidcontactname_xml";  
Retorno["getcontactbyid_xml.usms"] = "/getcontactbyid_xml.usms";
Retorno["contacts_table_edit.usms"] = "/contacts_table_edit.usms";
Retorno["usms_simplifiedviewofphonesbyidcontact_xml"] = "/usms_simplifiedviewofphonesbyidcontact_xml";
Retorno["usms_getphonebyid_xml"] = "/usms_getphonebyid_xml";
Retorno["usms_phonetable_xml"] = "/usms_phonetable_xml";
Retorno["usms_provider_listidname_xml"] = "/usms_provider_listidname_xml";
Retorno["usms_gettableincomingcalls_xml"] = "/usms_gettableincomingcalls_xml";
Retorno["usms_viewprovidertable_xml"] = "/usms_viewprovidertable_xml";
Retorno["providereditxml.usms"] = "/providereditxml.usms";
Retorno["fun_view_address_byid_xml.usms"] = "/fun_view_address_byid_xml.usms";
Retorno["fun_address_edit_xml.usms"] = "/fun_address_edit_xml.usms";
Retorno["fun_contact_address_edit_xml.usms"] = "/fun_contact_address_edit_xml.usms";
Retorno["fun_phones_address_edit_xml.usms"] = "/fun_phones_address_edit_xml.usms";
Retorno["fun_view_location_level_xml.usms"] = "/fun_view_location_level_xml.usms";
Retorno["fun_location_level_edit_xml_from_hashmap.usms"] = "/fun_location_level_edit_xml_from_hashmap.usms";
Retorno["fun_location_level_remove_selected_xml.usms"] = "/fun_location_level_remove_selected_xml.usms";

Retorno["fun_view_state_by_level1_xml.usms"] = "/fun_view_state_by_level1_xml.usms";
Retorno["fun_location_state_edit_xml_from_hashmap.usms"] = "/fun_location_state_edit_xml_from_hashmap.usms";
Retorno["fun_location_state_remove_selected_xml.usms"] = "/fun_location_state_remove_selected_xml.usms";

Retorno["fun_view_city_by_idstate_xml.usms"] = "/fun_view_city_by_idstate_xml.usms";
Retorno["fun_location_city_edit_xml_from_hashmap.usms"] = "/fun_location_city_edit_xml_from_hashmap.usms";
Retorno["fun_location_city_remove_selected_xml.usms"] = "/fun_location_city_remove_selected_xml.usms";

Retorno["fun_view_sector_by_idcity_xml.usms"] = "/fun_view_sector_by_idcity_xml.usms";
Retorno["fun_location_sector_edit_xml_from_hashmap.usms"] = "/fun_location_sector_edit_xml_from_hashmap.usms";
Retorno["fun_location_sector_remove_selected_xml.usms"] = "/fun_location_sector_remove_selected_xml.usms";

Retorno["fun_view_subsector_by_idsector_xml.usms"] = "/fun_view_subsector_by_idsector_xml.usms";
Retorno["fun_location_subsector_edit_xml_from_hashmap.usms"] = "/fun_location_subsector_edit_xml_from_hashmap.usms";
Retorno["fun_location_subsector_remove_selected_xml.usms"] = "/fun_location_subsector_remove_selected_xml.usms";
Retorno["fun_view_locations_ids_from_idlocation_xml.usms"] = "/fun_view_locations_ids_from_idlocation_xml.usms";

//Retorno["xxxxxxxxxxxxxxxxx.usms"] = "/xxxxxxxxxxxxxxxx.usms";


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
case "/usms_smsoutviewtablefilter":
response = ResponseSMSOutViewTableFilter(request);
break;
case "/gettableserialport":
response = ResponseSerialPortTable(request);
break;
case "/posttableserialport":
response = ResponseUpdateTableSerialPort(request);
break;
case "/usms_getcontactslistidcontactname_xml":
response = ResponseContactsListNameAndId(request);
break;
case "/getcontactbyid_xml.usms":
response = ResponseContactById(request);
break;
case "/contacts_table_edit.usms":
response = ResponseFunctionContactEditTable(request);
break;
case "/usms_simplifiedviewofphonesbyidcontact_xml":
response = ResponseSimplifiedViewOfPhonesByIdContact(request);
break;
case "/usms_getphonebyid_xml":
response = ResponsePhoneById(request);
break;
case "/usms_phonetable_xml":
response = ResponsePhoneTable(request);
break;
case "/usms_provider_listidname_xml":
response = ResponseProviderListIdNameXml(request);
break;

case "/usms_gettableincomingcalls_xml":
response = ResponseGridIncomingCallsXml(request);
break;

case "/usms_viewprovidertable_xml":
response = ResponseViewProviderTableXml(request);
break;

case "/usms_smsinviewtablefilter":
response = ResponseSMSInViewTableFilter(request);
break;

case "/providereditxml.usms":
response = ResponseProviderEditXml(request);
break;

case "/fun_view_address_byid_xml.usms":
response = response_fun_view_address_byid_xml(request);
break;

case "/fun_address_edit_xml.usms":
response = response_fun_address_edit_xml(request);
break;

case "/fun_contact_address_edit_xml.usms":
response = response_fun_contact_address_edit_xml(request);
break;
case "/fun_phones_address_edit_xml.usms":
response = response_fun_phones_address_edit_xml(request);
break;

case "/fun_view_location_level_xml.usms":
response = response_fun_view_location_level_xml(request);
break;

case "/fun_location_level_edit_xml_from_hashmap.usms":
response = response_fun_location_level_edit_xml_from_hashmap(request);
break;

case "/fun_location_level_remove_selected_xml.usms":
response = response_fun_location_level_remove_selected_xml(request);
break;

case "/fun_view_state_by_level1_xml.usms":
response = response_fun_view_state_by_idl1_xml(request);
break;

case "/fun_location_state_edit_xml_from_hashmap.usms":
response = response_fun_location_state_edit_xml_from_hashmap(request);
break;

case "/fun_location_state_remove_selected_xml.usms":
response = response_fun_location_state_remove_selected_xml(request);
break;

//------------------
case "/fun_view_city_by_idstate_xml.usms":
response = response_fun_view_city_by_idstate_xml(request);
break;
case "/fun_location_city_edit_xml_from_hashmap.usms":
response = response_fun_location_city_edit_xml_from_hashmap(request);
break;
case "/fun_location_city_remove_selected_xml.usms":
response = response_fun_location_city_remove_selected_xml(request);
break;

//------------------
case "/fun_view_sector_by_idcity_xml.usms":
response = response_fun_view_sector_by_idcity_xml(request);
break;
case "/fun_location_sector_edit_xml_from_hashmap.usms":
response = response_fun_location_sector_edit_xml_from_hashmap(request);
break;
case "/fun_location_sector_remove_selected_xml.usms":
response = response_fun_location_sector_remove_selected_xml(request);
break;

//------------------
case "/fun_view_subsector_by_idsector_xml.usms":
response = response_fun_view_subsector_by_idsector_xml(request);
break;
case "/fun_location_subsector_edit_xml_from_hashmap.usms":
response = response_fun_location_subsector_edit_xml_from_hashmap(request);
break;
case "/fun_location_subsector_remove_selected_xml.usms":
response = response_fun_location_subsector_remove_selected_xml(request);
break;
case "/fun_view_locations_ids_from_idlocation_xml.usms":
response = response_fun_view_locations_ids_from_idlocation_xml(request);
break;

/*
case "/xxxxxxxxxxxxxxxxxxxxxx.usms":
response = xxxxxxxxxxxxxxxxxxxxxxx(request);
break;
*/

default:
      response.Header.Status = StatusCode.NOT_FOUND;
break;
}
return response;
}


//------------------------------------
private static uHttp.Response response_fun_view_locations_ids_from_idlocation_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
LocationLevel Tabla = new LocationLevel();
Tabla.GetParamCnx();
int id = 0;
if(request.Query.has_key("idlocation")){
id = int.parse(request.Query["idlocation"]);
}

    Retorno.Data =  Tabla.fun_view_locations_ids_from_idlocation_xml(id).data;
return Retorno;
}

//----------------------------------------------------------------------------------------------
private static uHttp.Response response_fun_location_subsector_remove_selected_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSubSector Tabla = new TableSubSector();
Tabla.GetParamCnx();
string ids = "";
if(request.Form.has_key("ids")){
ids = request.Form["ids"];
}

    Retorno.Data =  Tabla.fun_location_subsector_remove_selected_xml(ids, true).data;
return Retorno;
}

private static uHttp.Response response_fun_location_subsector_edit_xml_from_hashmap(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSubSector Tabla = new TableSubSector();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_location_subsector_edit_xml_from_hashmap(request.Form).data;
return Retorno;
}

private static uHttp.Response response_fun_view_subsector_by_idsector_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSubSector Tabla = new TableSubSector();
Tabla.GetParamCnx();

int id = 0;

if(request.Query.has_key("idsector")){
id = int.parse(request.Query["idsector"]);
}

    Retorno.Data =  Tabla.fun_view_subsector_by_idsector_xml(id, true).data;
return Retorno;
}


//----------------------------------------------------------------------------------------------
private static uHttp.Response response_fun_location_sector_remove_selected_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSector Tabla = new TableSector();
Tabla.GetParamCnx();
string ids = "";
if(request.Form.has_key("ids")){
ids = request.Form["ids"];
}

    Retorno.Data =  Tabla.fun_location_sector_remove_selected_xml(ids, true).data;
return Retorno;
}

private static uHttp.Response response_fun_location_sector_edit_xml_from_hashmap(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSector Tabla = new TableSector();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_location_sector_edit_xml_from_hashmap(request.Form).data;
return Retorno;
}

private static uHttp.Response response_fun_view_sector_by_idcity_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableSector Tabla = new TableSector();
Tabla.GetParamCnx();

int id = 0;

if(request.Query.has_key("idcity")){
id = int.parse(request.Query["idcity"]);
}

    Retorno.Data =  Tabla.fun_view_sector_by_idcity_xml(id, true).data;
return Retorno;
}


//---------------------------------------------------------
private static uHttp.Response response_fun_location_city_remove_selected_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableCity Tabla = new TableCity();
Tabla.GetParamCnx();
string ids = "";
if(request.Form.has_key("ids")){
ids = request.Form["ids"];
}

    Retorno.Data =  Tabla.fun_location_city_remove_selected_xml(ids, true).data;
return Retorno;
}

private static uHttp.Response response_fun_location_city_edit_xml_from_hashmap(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableCity Tabla = new TableCity();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_location_city_edit_xml_from_hashmap(request.Form).data;
return Retorno;
}

private static uHttp.Response response_fun_view_city_by_idstate_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableCity Tabla = new TableCity();
Tabla.GetParamCnx();

int idstate = 0;

if(request.Query.has_key("idstate")){
idstate = int.parse(request.Query["idstate"]);
}

    Retorno.Data =  Tabla.fun_view_city_by_idstate_xml(idstate, true).data;
return Retorno;
}

//-------------------------
private static uHttp.Response response_fun_location_state_remove_selected_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableState Tabla = new TableState();
Tabla.GetParamCnx();
string ids = "";
if(request.Form.has_key("ids")){
ids = request.Form["ids"];
}

    Retorno.Data =  Tabla.fun_location_state_remove_selected_xml(ids, true).data;
return Retorno;
}

private static uHttp.Response response_fun_location_state_edit_xml_from_hashmap(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableState Tabla = new TableState();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_location_state_edit_xml_from_hashmap(request.Form).data;
return Retorno;
}

private static uHttp.Response response_fun_view_state_by_idl1_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableState Tabla = new TableState();
Tabla.GetParamCnx();

int idl1 = 0;

if(request.Query.has_key("idl1")){
idl1 = int.parse(request.Query["idl1"]);
}

    Retorno.Data =  Tabla.fun_view_state_by_idcountry_xml(idl1, true).data;
return Retorno;
}


//------------------------------------
private static uHttp.Response response_fun_location_level_remove_selected_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
LocationLevel Tabla = new LocationLevel();
Tabla.GetParamCnx();
string ids = "";
int level = 0;
if(request.Form.has_key("ids")){
ids = request.Form["ids"];
}
if(request.Form.has_key("level")){
level = int.parse(request.Form["level"]);
}


    Retorno.Data =  Tabla.fun_location_level_remove_selected_xml(level, ids, true).data;
return Retorno;
}

private static uHttp.Response response_fun_location_level_edit_xml_from_hashmap(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
LocationLevel Tabla = new LocationLevel();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_location_level_edit_xml_from_hashmap(request.Form).data;
return Retorno;
}

private static uHttp.Response response_fun_view_location_level_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
LocationLevel Tabla = new LocationLevel();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_view_location_level_xml(request.Query, true).data;
return Retorno;
}


private static uHttp.Response response_fun_contact_address_edit_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
TableContacts Tabla = new TableContacts();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_contact_address_edit_xml_from_hashmap(request.Form, true).data;
return Retorno;
}

private static uHttp.Response response_fun_phones_address_edit_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
PhoneTable Tabla = new PhoneTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_phones_address_edit_xml_from_hashmap(request.Form, true).data;
return Retorno;
}


private static uHttp.Response response_fun_address_edit_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;
AddressTable Tabla = new AddressTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_address_edit_xml_from_hashmap(request.Form, true).data;
return Retorno;
}

private static uHttp.Response response_fun_view_address_byid_xml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

AddressTable Tabla = new AddressTable();
Tabla.GetParamCnx();
int idaddress = 0;
if(request.Query.has_key("idaddress")){
idaddress = int.parse(request.Query["idaddress"]);
}

    Retorno.Data =  Tabla.fun_view_address_byid_xml(idaddress, true).data;

return Retorno;
}

private static uHttp.Response ResponseProviderEditXml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

ProviderTable Tabla = new ProviderTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_provider_edit_xml_from_hashmap(request.Form, true).data;

return Retorno;
}

private static uHttp.Response ResponseSMSInViewTableFilter(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

string start = "2000-01-01";
string end = "2100-01-01";
int rows = 0;

if(request.Query.has_key("fstart")){
start = request.Query["fstart"];
}

if(request.Query.has_key("fend")){
end = request.Query["fend"];
}

if(request.Query.has_key("nrows")){
rows = int.parse(request.Query["nrows"]);
}

var Tabla = new TableSMSIn();
Tabla.GetParamCnx();

    Retorno.Data =  Tabla.fun_view_smsin_table_filter_xml(start, end, rows).data;

return Retorno;
}

public void RequestVirtualPageHandler(uHttpServer server, Request request, DataOutputStream dos){
    server.serve_response( ResponseToVirtualRequest(request), dos );
}

private static uHttp.Response ResponseViewProviderTableXml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

ProviderTable Tabla = new ProviderTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_view_provider_table_xml(true).data;

return Retorno;
}

private static uHttp.Response ResponseGridIncomingCallsXml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

string start = "1990-01-01";
string end = "1990-01-01";

if(request.Query.has_key("datestart")){
start = request.Query["datestart"];
}

if(request.Query.has_key("dateend")){
end = request.Query["dateend"];
}


TableIncomingCalls Tabla = new TableIncomingCalls();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_view_incomingcalls_xml(start, end, true).data;

return Retorno;
}

private static uHttp.Response ResponseProviderListIdNameXml(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

ProviderTable Tabla = new ProviderTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.idname_Xml(true).data;

return Retorno;
}

private static uHttp.Response ResponsePhoneTable(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

PhoneTable Tabla = new PhoneTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_phones_table_xml_from_hashmap(request.Form, true).data;

return Retorno;
}


private static uHttp.Response ResponsePhoneById(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

int id = 0;

if(request.Query.has_key("idphone")){
id = int.parse(request.Query["idphone"]);
}

PhoneTable Tabla = new PhoneTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.byId_Xml(id, true).data;

return Retorno;
}

private static uHttp.Response ResponseSimplifiedViewOfPhonesByIdContact(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

int id = 0;

if(request.Query.has_key("idcontact")){
id = int.parse(request.Query["idcontact"]);
}

PhoneTable Tabla = new PhoneTable();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.byIdContact_Xml(id).data;

return Retorno;
}

private static uHttp.Response ResponseFunctionContactEditTable(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;


TableContacts Tabla = new TableContacts();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.fun_contacts_edit_xml_from_hashmap(request.Form).data;

return Retorno;
}

private static uHttp.Response ResponseContactById(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

int id = 0;

if(request.Query.has_key("idcontact")){
id = int.parse(request.Query["idcontact"]);
}

TableContacts Tabla = new TableContacts();
Tabla.GetParamCnx();
    Retorno.Data =  Tabla.byId_Xml(id, true).data;

return Retorno;
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


private static uHttp.Response ResponseContactsListNameAndId(Request request){

uHttp.Response Retorno = new uHttp.Response();
  Retorno.Header.ContentType = "text/xml";
    Retorno.Header.Status = StatusCode.OK;

TableContacts Tabla = new TableContacts();
Tabla.GetParamCnx();

    Retorno.Data =  Tabla.NameAndId_All_Xml().data;

return Retorno;
}

// Recibe los datos y los actualiza en la base de datos.
private static uHttp.Response ResponseSerialPortTable(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

    Retorno.Data =  TableSerialPort.AllXml().data;

return Retorno;
}

// Envia la tabla
private static uHttp.Response ResponseSMSOutViewTableFilter(Request request){
uHttp.Response Retorno = new uHttp.Response();
    Retorno.Header.Status = StatusCode.OK;
  Retorno.Header.ContentType = "text/xml";

string start = "2000-01-01";
string end = "2100-01-01";
int rows = 0;

if(request.Query.has_key("fstart")){
start = request.Query["fstart"];
}

if(request.Query.has_key("fend")){
end = request.Query["fend"];
}

if(request.Query.has_key("nrows")){
rows = int.parse(request.Query["nrows"]);
}

var Tablasmsout = new TableSMSOut();
Tablasmsout.GetParamCnx();

    Retorno.Data =  Tablasmsout.fun_view_smsout_table_filter_xml(start, end, rows).data;

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
print("Connect: http://localhost:%s\n", S.Config.Port.to_string());
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
