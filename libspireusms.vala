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
using edwinspire.pgSQL;
using Sqlite;

namespace edwinspire.uSMS{

public const string VERSION = "0.1.2013.06.22";

public enum SMSOutStatus{
unknown = 0,
UnSent = 1,
Sent = 2,
SentIncomplete = 3,
Locked = 4,
Disallowed = 5,
LifetimeExpired = 6,
StartSending = 7,
EndsSending = 8
}

public enum OnIncomingCall{
Ignore,
Answer,
Refuse
}

[Description(nick = "Proccess Control", blurb = "Control del proceso del servidor usmsd")]
public enum ProcessCtrl{
[Description(nick = "None", blurb = "")]
None,
[Description(nick = "Run", blurb = "")]
Run,
[Description(nick = "Running", blurb = "")]
Running,
[Description(nick = "Sleep", blurb = "")]
Sleep,
[Description(nick = "Sleeping", blurb = "")]
Sleeping,
[Description(nick = "Restart", blurb = "")]
Restart,
[Description(nick = "Restarting", blurb = "")]
Restarting,
[Description(nick = "Kill", blurb = "")]
Kill,
[Description(nick = "Killed", blurb = "")]
Killed
}

/*
public enum ProcessSMSOut{
None = 0,
Locked = 1,
Sent = 2,
Fail = 3,
Disallowed = 4,
WaitingToBeSentByNextPort = 5,
SentIncomplete = 6,
LifetimeExpired = 7,
AllAttemptsFailToDeliverAutoProvider = 8,
AllAttemptsFailDelivery = 9,
AwaitingDeliveryRetry = 10
}
*/

public class Device: ModemGSM {

private ProcessCtrl Control = ProcessCtrl.None;

public uint TimeWindowSleep = 2000;
private bool YaFueRun = false;
private ProcessCtrl ControlOld = ProcessCtrl.None;
private TableSIM DBaseSIM = new TableSIM();
private TableSMSIn DBaseSMSIn = new TableSMSIn();
private TableCallIn DBaseCallIn = new TableCallIn();
private TableOutgoing DBaseOutgoing = new TableOutgoing();


private string FileLogModem = "";
private StringBuilder TempLog = new StringBuilder(); 
//private bool LlamadaDetectadayAlmacenada = false;
private PostgresuSMS DBaseGeneral = new PostgresuSMS();
private SQliteNotificationsDb NotificationsDb = new SQliteNotificationsDb();
public int IdPort = 0;
public SIMRow SIM = SIMRow();

public void SetPort(SerialPortConf sp){

this.CallID.connect(DetectCallID);
this.IdPort = (int)sp.Id;
this.Port = sp.Port;
FileLogModem = logFile();

this.DataBits = sp.DataBits;
this.BaudRate = sp.BaudRate;
this.Parityp = sp.Parityp;
this.HandShake = sp.HandShake;
this.StopBitsp = sp.StopBitsp;
//this.LogModem = true;

TempLog.append_printf("Build: %s\n", this.Port);
TempLog.append_printf("DataBits: %s\n", this.DataBits.to_string());
TempLog.append_printf("BaudRate: %s\n", this.BaudRate.to_string());
TempLog.append_printf("Parityp: %s\n", this.Parityp.to_string());
TempLog.append_printf("HandShake: %s\n", this.HandShake.to_string());
TempLog.append_printf("StopBitsp: %s\n", this.StopBitsp.to_string());

this.log(LogLevelFlags.LEVEL_MESSAGE, TempLog.str);
TempLog.truncate();
this.Ctrl = ProcessCtrl.Run;
DBaseGeneral.GetParamCnx();
Run();
}

public void DetectCallID(string phone){
this.get_sim();
print("Callid = %s\n", phone);
DBaseCallIn.GetParamCnx();
if(DBaseCallIn.fun_incomingcalls_insert_online(this.IdPort, this.SIM.action, phone.replace("+", ""))>0){
//LlamadaDetectadayAlmacenada = true;
//print("Llamada entrante detectada y almacenda: %s\n", phone);
NotificationsDb.notifications_insert("Llamada entrante del número "+phone+", fue almacenada y será "+this.SIM.action.to_string(), "Llamada entrante del número "+phone+", fue almacenada y será "+this.SIM.action.to_string(), 0);
this.LastCall.Read = true;

}else{
//print("Llamada entrante detectada pero NO pudo ser almacenada: %s\n", phone);
NotificationsDb.notifications_insert("Llamada entrante del número "+phone+", fue almacenada y será "+this.SIM.action.to_string(), "Llamada entrante del número "+phone+", fue almacenada y será "+this.SIM.action.to_string(), 3);
}
}


private void ActionOnIncomingCall(){
// Accion a tomar si una llamada ha sido detectada y ya fue almacenada
if(this.LastCall.Read){

DBaseSIM.GetParamCnx();
this.SIM = DBaseSIM.byId(this.SIM.id);

switch(this.SIM.action){

	case OnIncomingCall.Answer:
this.AcceptCall();
// Configura el tono que va a durar el tono
this.VTD(this.SIM.dtmf_tone_time*10);
// Envia el tono DTMF
this.DTMF_Tone_Generation(this.SIM.dtmf_tone);
// Espera el tiempo que se ha programado para emitir el tono
Thread.usleep(1000*this.SIM.dtmf_tone_time*1000);
// Finaliza la llamada
this.TerminateCall();
break;
	case OnIncomingCall.Refuse:
this.TerminateCall();
break;
	default:
//  Ingnora la llamada, no hace nada
break;
}
this.LastCall.Read = false;
}else{
// TODO: Crear una funcion en postgres que permita almacenar llamadas con fecha.
}
}


private string logFile(){
return this.Port.replace("/", "_").replace(":", "_")+".sqlite";
}

public ProcessCtrl Ctrl{
get{
return Control;
}
set{
ControlOld = Control;
Control = value;
if(!IsRunOrRunning()){
this.Run();
}
}
}


public void get_sim(){
DBaseSIM.GetParamCnx();
// Seleccionamos el PhoneBook de la SIM
this.CPBS_Set(PhoneBookMemoryStorage.SM);
// Buscamos el primer contacto usms y el numero telefónico almacenados en los contactos de la SIM
foreach(var x in this.CPBF("usms")){
stdout.printf ("PB: Index: %i - Number: %s - Type: %i - Name: %s\n", x.Index, x.Number, x.Type, x.Name);
// Segun el numero telefonico buscamos en la base de datos el idsim, si no existe se lo crea.
this.SIM = DBaseSIM.byPhone(x.Number);
break;
}

if(SIM.id <= 0){
foreach(var x in this.CPBF("USMS")){
stdout.printf ("PB: Index: %i - Number: %s - Type: %i - Name: %s\n", x.Index, x.Number, x.Type, x.Name);
// Segun el numero telefonico buscamos en la base de datos el idsim, si no existe se lo crea.
this.SIM = DBaseSIM.byPhone(x.Number);
break;
}
}


if(SIM.id <= 0){
warning("IdSIM no se pudo obtener de los contactos de la tarjeta SIM");
}
}

public void Kill(){
this.Ctrl = ProcessCtrl.Kill;
}

// Inicia un hilo asincrono que corre el proceso
private void Run(){
print("Run()\n");
if(!YaFueRun){
try{
Thread.create<void>(this.Inicia, false);
this.log(LogLevelFlags.LEVEL_MESSAGE, "Running");
}
catch(ThreadError e){
print(e.message);
}
}
}


private bool IsRunOrRunning(){
var Retorno = false;
if(Control == ProcessCtrl.Run || Control == ProcessCtrl.Running){
Retorno = true;
}
return Retorno;
}

//***********************************************
// Obtiene todas las configuracion registradas en la base de datos
//[Description(nick = "Update row", blurb = "")]
private bool Createtablelog(){
bool Retorno = false;
//var Query = new StringBuilder();

    Database db;
    Statement stmt;
    int rc = 0;

    if ((rc = Database.open (FileLogModem, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
  //      return;
    }

//Query.append();

    if ((rc = db.prepare_v2 ("""CREATE TABLE portlog ("id" INTEGER PRIMARY KEY  NOT NULL ,"date" DATETIME DEFAULT CURRENT_TIMESTAMP ,"log" TEXT,"note" TEXT, "level" INTEGER NOT NULL  DEFAULT 0)""", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
//        return;
    }

if(stmt != null){
/*
stmt.bind_text(1, conf.Root);
stmt.bind_int(2, conf.Port);
stmt.bind_int(3, (int)conf.Enable);
*/
//stmt.bind_text(1, "portlog");
//stmt.bind_text(5, conf.HomePage);
//stmt.bind_int(2, contrl.Id);

stmt.step();

//print(stmt.sql());
  //      printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
      //  printerr ("SQL %s\n", stmt.sql());
db.exec("COMMIT");

//        printerr ("SQL changes: %d, %i\n", rc, db.changes ());

if(db.changes ()>0){
Retorno = true;
}
}
  //    printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
//        printerr ("SQL changes: %d, %i\n", rc, db.changes ());
return Retorno;
}

[Description(nick = "log", blurb = "Inserta un evento en la bitacora del proceso")]
public int64 log(LogLevelFlags level, string log){
int64 Retorno = 0;
    Database db;
    Statement stmt;
    int rc = 0;
string query = "INSERT INTO portlog (log, level) VALUES (?, ?)";
  //  int cols;

    if ((rc = Database.open (FileLogModem, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
//    return false;
    }

    if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FileLogModem, db.errmsg ());
  //      return false;

    }

if(stmt != null){
//stmt.bind_int(1, row.Id);
stmt.bind_text(1, log);
stmt.bind_int(2, level);

stmt.step();
//  printerr ("SQL %s\n", db.errmsg ());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = db.last_insert_rowid ();
}
}

if(Retorno<1){
Createtablelog();
}

return Retorno;
}

// Proceso principal
// Antes de ejecutar algun trabajo con el modem hay que asegurarse que el proceso sea run o running
private void Inicia(){

DBaseOutgoing.GetParamCnx();

this.log(LogLevelFlags.LEVEL_MESSAGE, "Test conection Postgres: "+(DBaseOutgoing.TestConnection()).to_string());
//DBase.fun_smsout_insert(int inidphone, string inphone, string inmessage "", int inidprovider = 0, int inidsmstype = 0, int inpriority = 5, bool inretryonfail = false, DateTime indatetosend = new DateTime.now_local(), string innote = "")

YaFueRun = true;
//print("Inicia\n");
//uint i = 0;
int round = 0;

if(this.BaudRate<100){
this.AutoBaudRate();
}

while(this.Ctrl!=ProcessCtrl.Kill){

print("[%s %s]\n", this.Port, this.Ctrl.to_string());
this.Open();

ActionOnIncomingCall();
this.log(LogLevelFlags.LEVEL_MESSAGE, "Openning Port");
if(this.IsOpen){
this.log(LogLevelFlags.LEVEL_MESSAGE, "Port is open");

if(round>20){
round = 0;
}

// Cada 20 vueltas obtiene las caracteristica del modem y demas datos
if(round == 0){
this.get_sim();
this.StringInit();
this.GetFeatures();
this.CLIP(true);

this.log(LogLevelFlags.LEVEL_MESSAGE, "Features:\n"+this.Features.ToString());
}

//DBaseGeneral.fun_currentportsproviders_insertupdate(this.IdPort, this.Port, this.Features.CIMI, this.Features.CGSN);
ModemPortDatasToServer();

if(this.IsRunOrRunning()){
Control = ProcessCtrl.Running;
print("CMS Error Set %s\n", this.CMEE_Set(ExpandedErrorMessage.Text).to_string());

//print("bateria nivel %i\n", this.BatteryCharge().Level);
print("señal rssi %i\n", this.SignalQuality().ReceivedSignalStrengthIndication);

var Registro = this.CREG();
print("Network REG %s => %s\n", Registro.UnsolicitedResultCode.to_string(),  Registro.Status.to_string());

this.MessageFormat_Set(Mode.TXT);

this.SendSMS();
this.ReadSMS();

//print("PhoneActivityStatus %s\n", this.PhoneActivityStatus().to_string());


}


// Este bloque realiza un reseteo del modem
if(Control==ProcessCtrl.Restart){
Control=ProcessCtrl.Restarting;
print("Modem (%s) Restarting\n", this.Port);
this.ATZ();
//TODO// Implementar mas funciones de reseto si es necesario
this.Close();
this.log(LogLevelFlags.LEVEL_MESSAGE, "Closed Port");
Thread.usleep(1000*3000);
//this.Open();
// Volvemos el valor al estado anterior al reset
Control = ControlOld;
}

}else{
this.log(LogLevelFlags.LEVEL_MESSAGE, "Port can not open");
Thread.usleep(1000*3000);
}
this.Close();
this.log(LogLevelFlags.LEVEL_MESSAGE, "Closed Port");
//ControlOld = Control;
// Pausa entre cada proceso o lectura del modem
if(TimeWindowSleep<1500){
// No aseguramos que el tiempo de sleep no sea menor de 1500ms para no sobrecargar el uso del cpu.
TimeWindowSleep = 1500;
}else if(TimeWindowSleep>30000){
// Limita el sleep a maximo 30 segundos.
TimeWindowSleep = 30000;
}

Thread.usleep(1000*TimeWindowSleep);
//conex.RequestCtrlProcessStatus();
round++;
}

print("Proceso del Modem del puerto %s ha sido eliminado\n", this.Port);
Control=ProcessCtrl.Killed;
YaFueRun = false;
}

private void ModemPortDatasToServer(){
DBaseGeneral.fun_portmodem_update(this.IdPort, this.Port, this.Features.CIMI, this.Features.CGSN, this.Features.CGMI, this.Features.CGMM, this.Features.CGMR);
}


private void ReadSMS(){
print("<<< uSMS ReadSMS >>>\n");
ActionOnIncomingCall();
if(this.Features.CMGF == Mode.PDU || this.Features.CMGF == Mode.BOTH){
this.CMGF_Set(Mode.PDU);
}
ActionOnIncomingCall();
// Lee todos los mensajes que hay en el telefono
var SMSsEntrantes = this.CMGL_only_index(SMS_Status.ALL);
if(SMSsEntrantes.size>0){
DBaseSMSIn.GetParamCnx();

print("<<< %s SMS Encontrados >>>\n", SMSsEntrantes.size.to_string());
foreach(var X in SMSsEntrantes){
ActionOnIncomingCall();

var Mensaje = this.CMGR(X);
//print("Index => %u => %s\n", X, Mensaje.Text);
NotificationsDb.notifications_insert(Mensaje.Text, Mensaje.Text, 0);
if(DBaseSMSIn.fun_smsin_insert(this.IdPort, Mensaje.Status, Mensaje.DateTime, Mensaje.Phone, Mensaje.Text) > 0){
this.CMGD(X);
}
}

}

}

private void SendSMS(){

ActionOnIncomingCall();
var SMS = DBaseOutgoing.ToSend(this.SIM.id);

//GLib.print("SMS.size.size => %s\n", SMS.size.to_string());

if(SMS.size>0){
//GLib.print("SMS[_idsmsout] => %i\n", SMS["_idsmsout"].as_int());
GLib.print("IdSIM => %i\n", this.SIM.id);
if(SMS["_idsmsout"].as_int()>0){

ActionOnIncomingCall();
//GLib.print("SMS[_phone] => %s\n", SMS["_phone"].Value);
DBaseOutgoing.log(SMS["_idsmsout"].as_int(), this.SIM.id, SMSOutStatus.StartSending, 0, 0);
var msgsEnviados = this.SMS_SEND_ON_SLICES(SMS["_phone"].Value, SMS["_message"].Value, SMS["_report"].as_bool(), SMS["_enablemessageclass"].as_bool(), (edwinspire.PDU.DCS_MESSAGE_CLASS)SMS["_messageclass"].as_int(), SMS["_maxparts"].as_int());

int i = 1;
int partes = msgsEnviados.size;

foreach(var id in msgsEnviados){
GLib.print("CMGS => %i\n", id);
ActionOnIncomingCall();
if(id>0){
DBaseOutgoing.log(SMS["_idsmsout"].as_int(), this.SIM.id, SMSOutStatus.Sent, partes, i);
NotificationsDb.notifications_insert("El mensaje ENVIADO", "El mensaje enviado "+SMS["_message"].Value, 0);
}else{
DBaseOutgoing.log(SMS["_idsmsout"].as_int(), this.SIM.id, SMSOutStatus.UnSent, partes, i);
NotificationsDb.notifications_insert("El mensaje no pudo ser enviado", "El mensaje no pudo ser enviado "+SMS["_message"].Value, 3);
}
i++;
}

DBaseOutgoing.log(SMS["_idsmsout"].as_int(), this.SIM.id, SMSOutStatus.EndsSending, 0, 0);

}
}

}

/*
private void SendSMS(){
ActionOnIncomingCall();
GLib.print("Buscando SMS para enviar\n");
TableSMSOut tsmsSend = new TableSMSOut();
tsmsSend.GetParamCnx();
var Mensage = tsmsSend.ToSend(this.IdPort);

if(Mensage.Index>0){

ActionOnIncomingCall();
//string phone, string Message = "", bool statusreport = false, bool enableMessageClass = false, edwinspire.PDU.DCS_MESSAGE_CLASS msgclass =  edwinspire.PDU.DCS_MESSAGE_CLASS.TE_SPECIFIC, int maxPortions = 2
var msgsEnviados = this.SMS_SEND_ON_SLICES(Mensage.Phone, Mensage.Text, Mensage.StatusReport, Mensage.enableMessageClass, Mensage.MessageClass, Mensage.MaxSlices);

ActionOnIncomingCall();

int RealmenteEnviados = 0;

foreach(var msg in msgsEnviados){
GLib.print("Mensaje indexdb [%s] => indexsms %s\n", Mensage.Index.to_string(), msg.to_string());
if(msg>0){
RealmenteEnviados++;
}
}

GLib.print("Numero de partes de mensaje = %s de las cuales se enviaron %s\n", msgsEnviados.size.to_string(), RealmenteEnviados.to_string());

if((msgsEnviados.size == RealmenteEnviados) && RealmenteEnviados>0){
tsmsSend.fun_smsout_updatestatus((int)Mensage.Index, ProcessSMSOut.Sent, this.IdPort, msgsEnviados.size, RealmenteEnviados);
}else if((msgsEnviados.size > RealmenteEnviados) && RealmenteEnviados>0){
// Mensaje eniado incompleto
tsmsSend.fun_smsout_updatestatus((int)Mensage.Index, ProcessSMSOut.SentIncomplete, this.IdPort, msgsEnviados.size, RealmenteEnviados);
}else{
tsmsSend.fun_smsout_updatestatus((int)Mensage.Index, ProcessSMSOut.Fail, this.IdPort, msgsEnviados.size, RealmenteEnviados);
}



}

}
*/


}



}
