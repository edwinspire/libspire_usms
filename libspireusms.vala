
using GLib;
using Gee;
using edwinspire.Ports;
using edwinspire.GSM.MODEM;
using edwinspire.pgSQL;
using Sqlite;

namespace edwinspire.uSMS{

public const string VERSION = "0.1.2012.10.22";


public enum CallAction{
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

public class Device: ModemGSM {

private ProcessCtrl Control = ProcessCtrl.None;

public uint TimeWindowSleep = 2000;
private bool YaFueRun = false;
private ProcessCtrl ControlOld = ProcessCtrl.None;
private TableSMSOut DBaseSMSOut = new TableSMSOut();
private TableSMSIn DBaseSMSIn = new TableSMSIn();
private TableCallIn DBaseCallIn = new TableCallIn();

private string FileLogModem = "";
private StringBuilder TempLog = new StringBuilder(); 
private bool LlamadaDetectadayAlmacenada = false;
private PostgresuSMS DBaseGeneral = new PostgresuSMS();
public int IdPort = 0;

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
print("Callid = %s\n", phone);
DBaseCallIn.GetParamCnx();
//var RegCall = DBaseCallIn.fun_incomingcalls_insert_online(this.IdPort, CallAction.Ignore, phone.replace("+", ""));
//print("Registro de llamada: %s\n", RegCall.to_string());
if(DBaseCallIn.fun_incomingcalls_insert_online(this.IdPort, CallAction.Ignore, phone.replace("+", ""))>0){
LlamadaDetectadayAlmacenada = true;
print("Llamada entrante detectada y almacenda: %s\n", phone);
}else{
print("Llamada entrante detectada pero NO pudo ser almacenada: %s\n", phone);
}

}

private void ActionOnIncomingCall(){
// Accion a tomar si una llamada ha sido detectada y ya fue almacenada
if(LlamadaDetectadayAlmacenada){
this.TerminateCall();
LlamadaDetectadayAlmacenada = false;
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

DBaseSMSOut.GetParamCnx();

this.log(LogLevelFlags.LEVEL_MESSAGE, "Test conection Postgres: "+(DBaseSMSOut.TestConnection()).to_string());
//DBase.fun_smsout_insert(int inidphone, string inphone, string inmessage "", int inidprovider = 0, int inidsmstype = 0, int inpriority = 5, bool inretryonfail = false, DateTime indatetosend = new DateTime.now_local(), string innote = "")
/*
DBaseSMSOut.fun_smsout_insert(0, "082786003", "mensaje de texto de prueba", 5);
DBaseSMSOut.fun_smsout_insert(0, "09824548598", " OTRO mensaje de texto de prueba desde usmsd", 5);
DBaseSMSOut.fun_smsout_insert(3, "09144553099", " OTRO mensaje de texto de prueba", 8);
DBaseSMSOut.fun_smsout_insert(0, "09824458598", " Auto mensaje de texto de prueba", 5);
DBaseSMSOut.fun_smsout_insert(0, "0988888", " Mas Auto mensaje de texto de prueba", 0);
*/

//DBase.fun_smsout_insert(0, 0, 3, 9, "", new DateTime.now_local(), """Mensaje de texto tiee caracteres mamá papá ñaño, 'select' viasta \ddd ok ss""", "Nota de mensaje");


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

if(DBaseSMSIn.fun_smsin_insert(this.IdPort, Mensaje.Status, Mensaje.DateTime, Mensaje.Phone, Mensaje.Text) > 0){
this.CMGD(X);
}
}

}

}


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


}



}
