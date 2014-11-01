////////////////////////////////////////////////////
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
//  
using GLib;
using Gee;
using edwinspire.Ports;
using edwinspire.GSM.MODEM;
using edwinspire.PDU;
using edwinspire.uHttp;
//
namespace edwinspire.uSMS {
	public class uSMSServer:uHttpServer {
		private ArrayList<Device> Dispositivos = new ArrayList<Device>();
		private  HashSet<string> PuertosUnicos = new HashSet<string>();
		public virtual bool connection_handler_virtual_usms(Request request, DataOutputStream dos) {
			edwinspire.uHttp.Response response = new edwinspire.uHttp.Response();
			response.Status = StatusCode.NOT_FOUND;
			response.Data = edwinspire.uHttp.Response.HttpError("uHTTP WebServer", "404 - Página no encontrada").data;
			response.Header["Content-Type"] = "text/html";
			this.serve_response( response, dos );
			return false;
		}
		public override bool connection_handler_virtual(Request request, DataOutputStream dos) {
			uHttp.Response response = new uHttp.Response();
			response.Status = StatusCode.OK;
			response.Data =  "".data;
			switch(request.Path) {
				case  "/getpostgresql.usms":
				response = response_getpostgresql(request);
				this.serve_response( response, dos );
				break;
				case "/savepostgresql.usms":
				response = ResponseUpdatePostgresConf(request);
				this.serve_response( response, dos );
				break;
				case "/view_sms_outgoing_datefilter.usms":
				response = response_fun_view_outgoing_view_filter_xml(request);
				this.serve_response( response, dos );
				break;
				case "/gettableserialport.usms":
				response = ResponseSerialPortTable(request);
				this.serve_response( response, dos );
				break;
				case "/serialportedit.usms":
				response = ResponseUpdateTableSerialPort(request);
				this.serve_response( response, dos );
				break;
				case "/getcontactslistidcontactname_xml.usms":
				response = ResponseContactsListNameAndId(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_contacts_to_list_search_xml.usms":
				response = response_fun_view_contacts_to_list_search_xml(request);
				this.serve_response( response, dos );
				break;
				case "/getcontactbyid_xml.usms":
				response = ResponseContactById(request);
				this.serve_response( response, dos );
				break;
				case "/contacts_table_edit.usms":
				response = ResponseFunctionContactEditTable(request);
				this.serve_response( response, dos );
				break;
				case "/simplifiedviewofphonesbyidcontact_xml.usms":
				response = ResponseSimplifiedViewOfPhonesByIdContact(request);
				this.serve_response( response, dos );
				break;
				case "/getphonebyid_xml.usms":
				response = ResponsePhoneById(request);
				this.serve_response( response, dos );
				break;
				case "/phonetable_xml.usms":
				response = ResponsePhoneTable(request);
				this.serve_response( response, dos );
				break;
				case "/provider_listidname_xml.usms":
				response = ResponseProviderListIdNameXml(request);
				this.serve_response( response, dos );
				break;
				case "/view_incomingcalls_xml.usms":
				response = ResponseGridIncomingCallsXml(request);
				this.serve_response( response, dos );
				break;
				case "/viewprovidertable_xml.usms":
				response = ResponseViewProviderTableXml(request);
				this.serve_response( response, dos );
				break;
				case "/view_smsin_datefilter.usms":
				response = ResponseSMSInViewTableFilter(request);
				this.serve_response( response, dos );
				break;
				case "/providereditxml.usms":
				response = ResponseProviderEditXml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_address_byid_xml.usms":
				response = response_fun_view_address_byid_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_address_edit_xml.usms":
				response = response_fun_address_edit_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_contact_address_edit_xml.usms":
				response = response_fun_contact_address_edit_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_phones_address_edit_xml.usms":
				response = response_fun_phones_address_edit_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_location_level_xml.usms":
				response = response_fun_view_location_level_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_level_edit_xml_from_hashmap.usms":
				response = response_fun_location_level_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_level_remove_selected_xml.usms":
				response = response_fun_location_level_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_state_by_level1_xml.usms":
				response = response_fun_view_state_by_idl1_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_state_edit_xml_from_hashmap.usms":
				response = response_fun_location_state_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_state_remove_selected_xml.usms":
				response = response_fun_location_state_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				//------------------
				case "/fun_view_city_by_idstate_xml.usms":
				response = response_fun_view_city_by_idstate_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_city_edit_xml_from_hashmap.usms":
				response = response_fun_location_city_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_city_remove_selected_xml.usms":
				response = response_fun_location_city_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				//------------------
				case "/fun_view_sector_by_idcity_xml.usms":
				response = response_fun_view_sector_by_idcity_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_sector_edit_xml_from_hashmap.usms":
				response = response_fun_location_sector_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_sector_remove_selected_xml.usms":
				response = response_fun_location_sector_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				//------------------
				case "/fun_view_subsector_by_idsector_xml.usms":
				response = response_fun_view_subsector_by_idsector_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_subsector_edit_xml_from_hashmap.usms":
				response = response_fun_location_subsector_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_location_subsector_remove_selected_xml.usms":
				response = response_fun_location_subsector_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_locations_ids_from_idlocation_xml.usms":
				response = response_fun_view_locations_ids_from_idlocation_xml(request);
				this.serve_response( response, dos );
				break;
				case "/tableserialport_delete.usms":
				response = response_tableserialport_delete(request);
				this.serve_response( response, dos );
				break;
				case "/test_conexion_pg.usms":
				response = response_test_conexion_pg(request);
				this.serve_response( response, dos );
				break;
				case "/usms_map.usms":
				response = response_usms_geo_map(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_sim_xml.usms":
				response = response_fun_view_sim_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_sim_table_edit_xml.usms":
				response = response_fun_sim_table_edit_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_outgoing_new_xml.usms":
				response = response_fun_outgoing_new_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_sim_idname_xml.usms":
				response = response_fun_view_sim_idname_xml(request);
				this.serve_response( response, dos );
				break;
				case "/enum_DCS_MESSAGE_CLASS_xml.usms":
				response = response_enum_DCS_MESSAGE_CLASS_xml(request);
				this.serve_response( response, dos );
				break;
				case "/enum_SMSType_xml.usms":
				response = response_enum_SMSType_xml(request);
				this.serve_response( response, dos );
				break;
				case "/enum_OnIncomingCall_xml.usms":
				response = response_enum_OnIncomingCall_xml(request);
				this.serve_response( response, dos );
				break;
				case "/enum_SMSOutStatus_xml.usms.usms":
				response = response_enum_SMSOutStatus_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_contacts_phones_with_search_xml.usms":
				response = response_fun_view_contacts_phones_with_search_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_provider_delete_selection_xml.usms":
				response = response_fun_provider_delete_selection_xml(request);
				this.serve_response( response, dos );
				break;
				case "/enum_DTMF_xml.usms":
				response = response_enum_DTMF_xml(request);
				this.serve_response( response, dos );
				break;
				case "/notification_system.usms":
				response = response_notification_system(request);
				this.serve_response( response, dos );
				break;
				case "/notification_lastid.usms":
				response_notification_lastid(request, dos);
				break;
				case "/event_table_changed.usms":
				response_event_table_changed(request, dos);
				break;
				case "/event_table_changed_browser_does_not_support_server_sent.usms":
				response = response_event_table_changed_browser_does_not_support_server_sent(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_groups_xml.usms":
				response = response_fun_view_groups_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_contacts_groups_xml.usms":
				response = response_fun_view_contacts_groups_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_groups_edit_xml_from_hashmap.usms":
				response = response_fun_groups_edit_xml_from_hashmap(request);
				this.serve_response( response, dos );
				break;
				case "/fun_groups_remove_selected_xml.usms":
				response = response_fun_groups_remove_selected_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_view_idgroup_name_xml.usms":
				response = response_fun_view_idgroup_name_xml(request);
				this.serve_response( response, dos );
				break;
				case "/fun_contact_change_groups_xml.usms":
				response = response_fun_contact_change_groups_xml(request);
				this.serve_response( response, dos );
				break;
				/*
case "/xxxxxxxxxxxxxxxxxxxxxx.usms":
response = xxxxxxxxxxxxxxxxxxxxxxx(request);
this.serve_response( response, dos ); break;
*/
				default:
				this.connection_handler_virtual_usms(request, dos);
				break;
			}
			return false;
		}
		/*
		public int[] attach_files(ArrayList<MultiPartFormDataPart> Parts,  bool replace = false, string parameter_file_name  = "filename") {
			int[] R = {
			}
			;
			int tempoint = 0;
			AttachmentsTable Tabla = new AttachmentsTable();
			Tabla.GetParamCnx();
			foreach(var p in Parts) {
				string fn = p.get_content_disposition_param(parameter_file_name);
				if(fn.length>0 && p.get_content_disposition_param("name") == "attach_usms") {
					if(save_file_on_uploads_folder(fn, p.data, p.compute_md5_for_data(), replace)) {
						// stderr.printf ("ADJUNTO GUARDADO\n%s\n", p.get_content_disposition_param("filename"));
						tempoint = Tabla.insert(fn, p.compute_md5_for_data()+"."+uHttpServer.get_extension_file(fn));
						if(tempoint>0) {
							R+=tempoint;
						}
					}
				}
			}
			return R;
		}*/
		/*
		public bool save_file_on_uploads_folder(string file_name, uint8[] data, string md5, bool replace = false) {
			return this.upload_file(Path.build_path (Path.DIR_SEPARATOR_S, "uploads", md5+"."+this.get_extension_file(file_name)), data, replace);
		}*/
		private uHttp.Response response_fun_contact_change_groups_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			int idcontact = 0;
			int idgroup = 0;
			bool belong = false;
			if(request.Form.post_request.has_key("idcontact")) {
				idcontact = int.parse(request.Form.post_request.get_value("idcontact"));
			}
			if(request.Form.post_request.has_key("idgroup")) {
				idgroup = int.parse(request.Form.post_request.get_value("idgroup"));
			}
			if(request.Form.post_request.has_key("belong")) {
				belong = bool.parse(request.Form.post_request.get_value("belong"));
			}
			Retorno.Data = Tabla.fun_contact_change_groups_xml(idcontact, idgroup, belong).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_contacts_groups_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			int idcontact = 0;
			if(request.Form.post_request.has_key("idcontact")) {
				idcontact = int.parse(request.Form.post_request.get_value("idcontact"));
			}
			Retorno.Data = Tabla.fun_view_contacts_groups_xml(idcontact).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_idgroup_name_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			GroupsTable Tabla = new GroupsTable();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_view_idgroup_name_xml(true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_groups_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			GroupsTable Tabla = new GroupsTable();
			Tabla.GetParamCnx();
			string idgroups = "0";
			if(request.Form.post_request.has_key("idgroups")) {
				idgroups = request.Form.post_request.get_value("idgroups");
			}
			Retorno.Data = Tabla.fun_groups_remove_selected_xml(idgroups).data;
			return Retorno;
		}
		private uHttp.Response response_fun_groups_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			GroupsTable Tabla = new GroupsTable();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_groups_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_groups_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			GroupsTable Tabla = new GroupsTable();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_view_groups_xml().data;
			return Retorno;
		}
		private uHttp.Response response_event_table_changed_browser_does_not_support_server_sent(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/plain";
			Retorno.Status = StatusCode.OK;
			var data = new StringBuilder();
			TableChangedTable Tabla = new TableChangedTable();
			Tabla.old_ts = request.Form.post_request.internal_hashmap;
			Tabla.GetParamCnx();
			data.append("{ ");
			// Espera 22.5 segundos antes de salir
			int i = 0;
			while(i<15) {
				if(Tabla.is_changed()) {
					// Convertimos los datos a jSON para trabajar con ellos en el lado cliente
					foreach(var reg in Tabla.old_ts.entries) {
						data.append_printf(""""%s":"%s",""", reg.key, reg.value.to_string());
					}
					break;
				}
				Thread.usleep(1000*1500);
				i++;
			}
			data.truncate(data.len-1);
			data.append("}");
			Retorno.Data = data.str.data;
			return Retorno;
		}
		private void response_event_table_changed(Request request, DataOutputStream dos) {
			this.sendEventHeader(dos);
			this.sendEvent("""{"Conexion": "start"}""", dos);
			var data = new StringBuilder();
			//print("libspire_usms: response_event_table_changed\n");
			TableChangedTable Tabla = new TableChangedTable();
			Tabla.GetParamCnx();
			int i = 0;
			while(i<200) {
				data.truncate();
				if(Tabla.is_changed()) {
					// Convertimos los datos a jSON para trabajar con ellos en el lado cliente
					data.append("{");
					foreach(var reg in Tabla.status.entries) {
						data.append_printf(""""%s":"%s",""", reg.key, reg.value.to_string());
					}
					data.truncate(data.len-1);
					data.append("}");
					//print("libspire_usms: response_event_table_changed\n%s\n", data.str);
					this.sendEvent(data.str, dos);
				}
				//stderr.printf("**>> %i\n", i);
				Thread.usleep(1000*1500);
				i++;
			}
		}
		private void response_notification_lastid(Request request, DataOutputStream dos) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/event-stream";
			Retorno.Header["Cache-Control"] = "no-cache";
			Retorno.Status = StatusCode.OK;
			this.serve_response( Retorno, dos );
			SQliteNotificationsDb dB = new SQliteNotificationsDb();
			int newid = dB.notifications_last().id;
			int lastid = 0;
			int i = 0;
			while(i<150) {
				if(lastid < newid) {
					this.writeData(("data: "+newid.to_string()+"\n\n").data, dos);
					lastid = newid;
				} else {
					newid = dB.notifications_last().id;
				}
				Thread.usleep(1000*1500);
				i++;
			}
		}
		private uHttp.Response response_notification_system(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			int lastid = 0;
			if(request.Form.post_request.has_key("lastidnotify")) {
				lastid = int.parse(request.Form.post_request.get_value("lastidnotify"));
			}
			NotificationsTable dB = new NotificationsTable();
			dB.GetParamCnx();
			Retorno.Data = dB.fun_view_notifications_xml(lastid, true).data;
			return Retorno;
		}
		private uHttp.Response response_enum_DTMF_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			Retorno.Data = uHttpServer.EnumToXml(typeof(Ports.DTMF), true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_provider_delete_selection_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableProvider Tabla = new TableProvider();
			Tabla.GetParamCnx();
			string delete_idproviders = "";
			if(request.Form.post_request.has_key("idproviders")) {
				delete_idproviders = request.Form.post_request.get_value("idproviders");
			}
			Retorno.Data =  Tabla.fun_provider_delete_selection_xml(delete_idproviders, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_contacts_phones_with_search_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			PhoneTable Tabla = new PhoneTable();
			Tabla.GetParamCnx();
			string exclude_idphones = "";
			string contact_phone_search = "";
			if(request.Form.post_request.has_key("exclude_idphones")) {
				exclude_idphones = request.Form.post_request.get_value("exclude_idphones");
			}
			if(request.Form.post_request.has_key("contact_phone_search")) {
				contact_phone_search = request.Form.post_request.get_value("contact_phone_search");
			}
			Retorno.Data =  Tabla.fun_view_contacts_phones_with_search_xml(contact_phone_search, exclude_idphones, true).data;
			return Retorno;
		}
		private uHttp.Response response_enum_SMSOutStatus_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			Retorno.Data = uHttpServer.EnumToXml(typeof(SMSOutStatus), true).data;
			return Retorno;
		}
		private uHttp.Response response_enum_OnIncomingCall_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			Retorno.Data = uHttpServer.EnumToXml(typeof(OnIncomingCall), true).data;
			return Retorno;
		}
		private uHttp.Response response_enum_SMSType_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			Retorno.Data = uHttpServer.EnumToXml(typeof(SMSType), true).data;
			return Retorno;
		}
		private uHttp.Response response_enum_DCS_MESSAGE_CLASS_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			Retorno.Data = uHttpServer.EnumToXml(typeof(PDU.DCS_MESSAGE_CLASS), true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_outgoing_new_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableOutgoing Tabla = new TableOutgoing();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_outgoing_new_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_sim_table_edit_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSIM Tabla = new TableSIM();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_sim_table_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_sim_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSIM Tabla = new TableSIM();
			Tabla.GetParamCnx();
			Retorno.Data = Tabla.fun_view_sim_xml().data;
			return Retorno;
		}
		private uHttp.Response response_usms_geo_map(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/html";
			Retorno.Status = StatusCode.OK;
			int idaccount = 0;
			if(request.Form.get_request.has_key("idaddress")) {
				idaccount = int.parse(request.Form.get_request.get_value("idaddress"));
			}
			var retornoHtml = uHttpServer.ReadFile(this.PathLocalFile("usms_map.html")).replace("data-usms-idaddress=\"0\"", "data-usms-idaddress=\""+idaccount.to_string()+"\"");
			Retorno.Data = retornoHtml.data;
			return Retorno;
		}
		//------------------------------------
		private uHttp.Response response_fun_view_locations_ids_from_idlocation_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			LocationLevel Tabla = new LocationLevel();
			Tabla.GetParamCnx();
			int id = 0;
			if(request.Form.get_request.has_key("idlocation")) {
				id = int.parse(request.Form.get_request.get_value("idlocation"));
			}
			Retorno.Data =  Tabla.fun_view_locations_ids_from_idlocation_xml(id).data;
			return Retorno;
		}
		//----------------------------------------------------------------------------------------------
		private uHttp.Response response_fun_location_subsector_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSubSector Tabla = new TableSubSector();
			Tabla.GetParamCnx();
			string ids = "";
			if(request.Form.post_request.has_key("ids")) {
				ids = request.Form.post_request.get_value("ids");
			}
			Retorno.Data =  Tabla.fun_location_subsector_remove_selected_xml(ids, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_location_subsector_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSubSector Tabla = new TableSubSector();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_location_subsector_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_subsector_by_idsector_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSubSector Tabla = new TableSubSector();
			Tabla.GetParamCnx();
			int id = 0;
			if(request.Form.get_request.has_key("idsector")) {
				id = int.parse(request.Form.get_request.get_value("idsector"));
			}
			Retorno.Data =  Tabla.fun_view_subsector_by_idsector_xml(id, true).data;
			return Retorno;
		}
		//----------------------------------------------------------------------------------------------
		private uHttp.Response response_fun_location_sector_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSector Tabla = new TableSector();
			Tabla.GetParamCnx();
			string ids = "";
			if(request.Form.post_request.has_key("ids")) {
				ids = request.Form.post_request.get_value("ids");
			}
			Retorno.Data =  Tabla.fun_location_sector_remove_selected_xml(ids, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_location_sector_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSector Tabla = new TableSector();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_location_sector_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_sector_by_idcity_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSector Tabla = new TableSector();
			Tabla.GetParamCnx();
			int id = 0;
			if(request.Form.get_request.has_key("idcity")) {
				id = int.parse(request.Form.get_request.get_value("idcity"));
			}
			Retorno.Data =  Tabla.fun_view_sector_by_idcity_xml(id, true).data;
			return Retorno;
		}
		//---------------------------------------------------------
		private uHttp.Response response_fun_location_city_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableCity Tabla = new TableCity();
			Tabla.GetParamCnx();
			string ids = "";
			if(request.Form.post_request.has_key("ids")) {
				ids = request.Form.post_request.get_value("ids");
			}
			Retorno.Data =  Tabla.fun_location_city_remove_selected_xml(ids, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_location_city_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableCity Tabla = new TableCity();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_location_city_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_city_by_idstate_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableCity Tabla = new TableCity();
			Tabla.GetParamCnx();
			int idstate = 0;
			if(request.Form.get_request.has_key("idstate")) {
				idstate = int.parse(request.Form.get_request.get_value("idstate"));
			}
			Retorno.Data =  Tabla.fun_view_city_by_idstate_xml(idstate, true).data;
			return Retorno;
		}
		//-------------------------
		private uHttp.Response response_fun_location_state_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableState Tabla = new TableState();
			Tabla.GetParamCnx();
			string ids = "";
			if(request.Form.post_request.has_key("ids")) {
				ids = request.Form.post_request.get_value("ids");
			}
			Retorno.Data =  Tabla.fun_location_state_remove_selected_xml(ids, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_location_state_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableState Tabla = new TableState();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_location_state_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_state_by_idl1_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableState Tabla = new TableState();
			Tabla.GetParamCnx();
			int idl1 = 0;
			if(request.Form.get_request.has_key("idl1")) {
				idl1 = int.parse(request.Form.get_request.get_value("idl1"));
			}
			Retorno.Data =  Tabla.fun_view_state_by_idcountry_xml(idl1, true).data;
			return Retorno;
		}
		//------------------------------------
		private uHttp.Response response_fun_location_level_remove_selected_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			LocationLevel Tabla = new LocationLevel();
			Tabla.GetParamCnx();
			string ids = "";
			int level = 0;
			if(request.Form.post_request.has_key("ids")) {
				ids = request.Form.post_request.get_value("ids");
			}
			if(request.Form.post_request.has_key("level")) {
				level = int.parse(request.Form.post_request.get_value("level"));
			}
			Retorno.Data =  Tabla.fun_location_level_remove_selected_xml(level, ids, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_location_level_edit_xml_from_hashmap(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			LocationLevel Tabla = new LocationLevel();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_location_level_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_location_level_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			LocationLevel Tabla = new LocationLevel();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_view_location_level_xml(request.Form.get_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_contact_address_edit_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_contact_address_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_phones_address_edit_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			PhoneTable Tabla = new PhoneTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_phones_address_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_address_edit_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			AddressTable Tabla = new AddressTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_address_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_address_byid_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			AddressTable Tabla = new AddressTable();
			Tabla.GetParamCnx();
			int idaddress = 0;
			if(request.Form.get_request.has_key("idaddress")) {
				idaddress = int.parse(request.Form.get_request.get_value("idaddress"));
			}
			Retorno.Data =  Tabla.fun_view_address_byid_xml(idaddress, true).data;
			return Retorno;
		}
		private uHttp.Response ResponseProviderEditXml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			ProviderTable Tabla = new ProviderTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_provider_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response ResponseSMSInViewTableFilter(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Status = StatusCode.OK;
			Retorno.Header["Content-Type"] = "text/xml";
			string start = "2000-01-01";
			string end = "2500-01-01";
			int rows = 25;
			if(request.Form.get_request.has_key("fstart")) {
				start = request.Form.get_request.get_value("fstart");
			}
			if(request.Form.get_request.has_key("fend")) {
				end = request.Form.get_request.get_value("fend");
			}
			if(request.Form.get_request.has_key("nrows")) {
				rows = int.parse(request.Form.get_request.get_value("nrows"));
			}
			var Tabla = new TableSMSIn();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_view_smsin_table_filter_xml(start, end, rows).data;
			return Retorno;
		}
		/*
public void RequestVirtualPageHandler(uHttpServer server, Request request, DataOutputStream dos){
    server.serve_response( ResponseToVirtualRequest(request), dos );
}
*/
		private uHttp.Response ResponseViewProviderTableXml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			ProviderTable Tabla = new ProviderTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_view_provider_table_xml(true).data;
			return Retorno;
		}
		private uHttp.Response ResponseGridIncomingCallsXml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			string start = "1990-01-01";
			string end = "1990-01-01";
			if(request.Form.get_request.has_key("datestart")) {
				start = request.Form.get_request.get_value("datestart");
			}
			if(request.Form.get_request.has_key("dateend")) {
				end = request.Form.get_request.get_value("dateend");
			}
			TableIncomingCalls Tabla = new TableIncomingCalls();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_view_incomingcalls_xml(start, end, true).data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_sim_idname_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableSIM Tabla = new TableSIM();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_view_sim_idname_xml(true).data;
			return Retorno;
		}
		private uHttp.Response ResponseProviderListIdNameXml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			ProviderTable Tabla = new ProviderTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.idname_Xml(true).data;
			return Retorno;
		}
		private uHttp.Response ResponsePhoneTable(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			PhoneTable Tabla = new PhoneTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_phones_table_xml_from_hashmap(request.Form.post_request.internal_hashmap, true).data;
			return Retorno;
		}
		private uHttp.Response ResponsePhoneById(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			int id = 0;
			if(request.Form.get_request.has_key("idphone")) {
				id = int.parse(request.Form.get_request.get_value("idphone"));
			}
			PhoneTable Tabla = new PhoneTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.byId_Xml(id, true).data;
			return Retorno;
		}
		private uHttp.Response ResponseSimplifiedViewOfPhonesByIdContact(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			int id = 0;
			if(request.Form.get_request.has_key("idcontact")) {
				id = int.parse(request.Form.get_request.get_value("idcontact"));
			}
			PhoneTable Tabla = new PhoneTable();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.byIdContact_Xml(id).data;
			return Retorno;
		}
		private uHttp.Response ResponseFunctionContactEditTable(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.fun_contacts_edit_xml_from_hashmap(request.Form.post_request.internal_hashmap).data;
			return Retorno;
		}
		private uHttp.Response ResponseContactById(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			int id = 0;
			if(request.Form.get_request.has_key("idcontact")) {
				id = int.parse(request.Form.get_request.get_value("idcontact"));
			}
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.byId_Xml(id, true).data;
			return Retorno;
		}
		//TestConnection
		// Recibe los datos y los actualiza en la base de datos.
		private uHttp.Response response_test_conexion_pg(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			var XmlRetorno = new StringBuilder("<table>");
			var pg = new PostgresuSMS();
			pg.GetParamCnx();
			if(pg.TestConnection()) {
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("Conexión exitosa con la base de datos.".data), "true");
			} else {
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("No se pudo hacer la conexión con la base de datos con los parámetros especificados.".data), "false");
			}
			XmlRetorno.append("</table>");
			Retorno.Data =  XmlRetorno.str.data;
			return Retorno;
		}
		// Recibe los datos y los actualiza en la base de datos.
		private uHttp.Response ResponseUpdateTableSerialPort(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			var XmlRetorno = new StringBuilder("<table>");
			if(request.Form.post_request.has_key("port")) {
				if(request.Form.post_request.get_value("port").length > 2) {
					if(TableSerialPort.InsertUpdateFromWeb(request.Form.post_request.internal_hashmap)>0) {
						XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("Los cambios han sido aplicados".data), "true");
					} else {
						XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("El registro no pudo ser guardado".data), "false");
					}
				} else {
					XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("El campo port no puede estar vacio".data), "false");
				}
			} else {
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("No existe el campo port".data), "false");
			}
			XmlRetorno.append("</table>");
			Retorno.Data =  XmlRetorno.str.data;
			return Retorno;
		}
		private uHttp.Response response_tableserialport_delete(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			var XmlRetorno = new StringBuilder("<table>");
			//TODO: Se tiene que buscar la forma de mejorar esta funcion para que el delete se haga en una sola funcion y no se tenga que hacer una solicitud por cada idport
			if(request.Form.post_request.has_key("idports")) {
				var idports = request.Form.post_request.get_value("idports").split(",");
				int del = 0;
				foreach(var id in idports) {
					int idp = int.parse(id).abs();
					if(idp > 0 && TableSerialPort.Delete(idp)) {
						del++;
					}
				}
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode(("Se han eliminado "+del.to_string()+" registros.").data), "true");
			} else {
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("No se ha recibido el campo idports con la lista de idport para eliminarlos".data), "false");
			}
			XmlRetorno.append("</table>");
			Retorno.Data =  XmlRetorno.str.data;
			return Retorno;
		}
		private uHttp.Response ResponseContactsListNameAndId(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			Retorno.Data =  Tabla.NameAndId_All_Xml().data;
			return Retorno;
		}
		private uHttp.Response response_fun_view_contacts_to_list_search_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Status = StatusCode.OK;
			TableContacts Tabla = new TableContacts();
			Tabla.GetParamCnx();
			string text = "";
			if(request.Form.get_request.has_key("text")) {
				text = request.Form.get_request.get_value("text");
			}
			Retorno.Data =  Tabla.NameAndId_Search_Xml(text, true).data;
			return Retorno;
		}
		// Recibe los datos y los actualiza en la base de datos.
		private uHttp.Response ResponseSerialPortTable(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Status = StatusCode.OK;
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Data =  TableSerialPort.AllXml().data;
			return Retorno;
		}
		// Envia la tabla
		private uHttp.Response response_fun_view_outgoing_view_filter_xml(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Status = StatusCode.OK;
			Retorno.Header["Content-Type"] = "text/xml";
			string start = "2000-01-01";
			string end = "2100-01-01";
			int rows = 0;
			if(request.Form.get_request.has_key("fstart")) {
				start = request.Form.get_request.get_value("fstart");
			}
			if(request.Form.get_request.has_key("fend")) {
				end = request.Form.get_request.get_value("fend");
			}
			if(request.Form.get_request.has_key("nrows")) {
				rows = int.parse(request.Form.get_request.get_value("nrows"));
			}
			var Tablasmsout = new TableOutgoing();
			Tablasmsout.GetParamCnx();
			Retorno.Data =  Tablasmsout.fun_view_outgoing_view_filter_xml(start, end, rows).data;
			return Retorno;
		}
		// Recibe los datos y los actualiza en la base de datos.
		private uHttp.Response ResponseUpdatePostgresConf(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Status = StatusCode.OK;
			Retorno.Header["Content-Type"] = "text/xml";
			var XmlRetorno = new StringBuilder("<table>");
			if(request.Form.post_request.has_key("host")) {
				if(request.Form.post_request.get_value("host").length >= 5) {
					int64 id = TablePostgres.UpdateFromWeb(request.Form.post_request.internal_hashmap);
					if(id>0) {
						XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode(("Los cambios han sido aplicados (id: "+id.to_string()+")").data), "true");
					} else {
						XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("El registro no pudo ser guardado".data), "false");
					}
				} else {
					XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("El campo Host no puede estar vacio o ser menor que 5 caracteres. Ingrese la IP o dirección donde se encuentra el servidor PostgreSQL.".data), "false");
				}
			} else {
				XmlRetorno.append_printf("<row><message>%s</message><response>%s</response></row>", Base64.encode("No existe el campo Host".data), "false");
			}
			XmlRetorno.append("</table>");
			Retorno.Data =  XmlRetorno.str.data;
			return Retorno;
		}
		// Solicita los datos de conexion a postgres
		private uHttp.Response response_getpostgresql(Request request) {
			uHttp.Response Retorno = new uHttp.Response();
			Retorno.Status = StatusCode.OK;
			Retorno.Header["Content-Type"] = "text/xml";
			Retorno.Data =  TablePostgres.LastRowEnabledXML().data;
			return Retorno;
		}
		// Usar unicamente cuando se inicia el servidor o cuando se lo reinicia.
		private void ResetAndLoadDevices() {
			print("Loading devices...\n");
			foreach(var u in TableSerialPort.Enables()) {
				if(!PuertosUnicos.contains(u.Port)) {
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
		//connect_pagehandler para que en uSAGA no se haga automaticamente la conexion ya que de otra forma no se podia acceder a todas las paginas virtuales de uSAGA pero si de uSMS.
		public void runuSMS() {
			ResetAndLoadDevices();
			base.run();
		}
	}
}
