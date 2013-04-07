using GLib;
using Gee;
using Sqlite;
using edwinspire.uSMS;
using edwinspire.Ports;
using edwinspire.pgSQL;



namespace edwinspire.uSMS{

public const string FILECONF = "usmsd.sqlite";

public struct TableRowPostgres{

public pgSQL.ConnectionParameters Parameters;
public string Note;
public int64 Id;
public bool Enable;

public TableRowPostgres(){
this.Parameters = ConnectionParameters();
this.Note = "";
this.Id = 0;
this.Enable = false;
}

}




public class TablePostgres:GLib.Object{

public TablePostgres(){

}

public static int64 InsertRow(TableRowPostgres row){

int64 Retorno = 0;
    Database db;
    Statement stmt;
    int rc = 0;
string query = "INSERT INTO postgres (enable, host, port, dbname, user, pwd, ssl, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){

stmt.bind_int(1, (int)row.Enable);
stmt.bind_text(2, row.Parameters.Host);
stmt.bind_int(3, (int)row.Parameters.Port);
stmt.bind_text(4, row.Parameters.db);
stmt.bind_text(5, row.Parameters.User);
stmt.bind_text(6, row.Parameters.Pwd);
stmt.bind_int(7, (int)row.Parameters.SSL);
stmt.bind_int(8, (int)row.Parameters.TimeOut);
stmt.bind_text(9, row.Note);
//stmt.bind_int(10, row.Id);

stmt.step();
//  printerr ("SQL %s\n", db.errmsg ());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = db.last_insert_rowid ();
}
}
return Retorno;
}

public static int64 UpdateFromWeb(HashMap<string, string> Form){

int64 id = TablePostgres.LastRowEnabled().Id;

TableRowPostgres datos = TableRowPostgres();
datos.Id = id;
datos.Enable = true;

if(Form.size>0){
datos.Parameters.Host = Form["host"];
datos.Parameters.Port = (uint)int.parse(Form["port"]);
datos.Parameters.db =  Form["db"];
datos.Parameters.User = Form["user"];
datos.Parameters.Pwd = Form["pwd"];

//print(">>>>>>>>>>>>>>>>>>>>> FormpgSSL %s\n", Form["pgSSL"]);

if(Form["ssl"] != null && Form["ssl"] == "true"){
datos.Parameters.SSL = true;
}else{
datos.Parameters.SSL = false;
}

datos.Parameters.TimeOut = 0;
datos.Note = Form["note"];

}else{
id = 0;
}

if(id>0){
id = TablePostgres.UpdateRow(datos);
}else{
id = TablePostgres.InsertRow(datos);
}


return id;
}


public static int64 UpdateRow(TableRowPostgres row){

int64 Retorno = 0;
    Database db;
    Statement stmt;
    int rc = 0;
string query = "UPDATE postgres SET enable=?, host=?, port=?, dbname=?, user=?, pwd=?, ssl=?, note=?  WHERE id=?";
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){

stmt.bind_int(1, (int)row.Enable);
stmt.bind_text(2, row.Parameters.Host);
stmt.bind_int(3, (int)row.Parameters.Port);
stmt.bind_text(4, row.Parameters.db);
stmt.bind_text(5, row.Parameters.User);
stmt.bind_text(6, row.Parameters.Pwd);
stmt.bind_int(7, (int)row.Parameters.SSL);
stmt.bind_text(8, row.Note);
stmt.bind_int64(9, row.Id);

stmt.step();
//  printerr ("SQL %s\n", db.errmsg ());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = db.last_insert_rowid ();
}
}
return Retorno;
}

// Obtiene los datos de conexion en formato Xml
public static string LastRowEnabledXML(){
var Datos = LastRowEnabled();

var Retorno = new StringBuilder("<usmsdata><postgres>");
Retorno.append_printf("<host>%s</host>", Base64.encode(Datos.Parameters.Host.data));
Retorno.append_printf("<port>%s</port>", Datos.Parameters.Port.to_string());
Retorno.append_printf("<timeout>%s</timeout>", Datos.Parameters.TimeOut.to_string());
Retorno.append_printf("<db>%s</db>", Base64.encode(Datos.Parameters.db.data));
Retorno.append_printf("<pwd>%s</pwd>", Base64.encode(Datos.Parameters.Pwd.data));
Retorno.append_printf("<ssl>%s</ssl>", Datos.Parameters.SSL.to_string());
Retorno.append_printf("<id>%s</id>", Datos.Id.to_string());
Retorno.append_printf("<user>%s</user>", Base64.encode(Datos.Parameters.User.data));
Retorno.append_printf("<note>%s</note>", Base64.encode(Datos.Note.data));
Retorno.append("</postgres></usmsdata>");
return Retorno.str;
}

public static TableRowPostgres LastRowEnabled(){

TableRowPostgres Retorno = TableRowPostgres();

    Database db;
    Statement stmt;
    int rc = 0;
    int cols;
    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }
    if ((rc = db.prepare_v2 ("SELECT * FROM postgres WHERE enable = 1 ORDER BY id DESC LIMIT 1", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }
    cols = stmt.column_count();
//print("colsssss %s\n", cols.to_string());
    do {
//print("rc >> %s\n", rc.to_string());
        rc = stmt.step();
        switch (rc) {
        case Sqlite.DONE:
            break;
        case Sqlite.ROW:
Retorno.Id = stmt.column_int(0);
Retorno.Parameters.Host = stmt.column_text(2);
Retorno.Parameters.Port = (uint)stmt.column_int(3);
Retorno.Parameters.db =  stmt.column_text(4);
Retorno.Parameters.User = stmt.column_text(5);
Retorno.Parameters.Pwd = stmt.column_text(6);
Retorno.Parameters.SSL = (bool)stmt.column_int(7);
Retorno.Parameters.TimeOut = stmt.column_int(8);
Retorno.Note = stmt.column_text(9);

            break;
        default:
            printerr ("Error: %d, %s\n", rc, db.errmsg ());
            break;
        }
    } while (rc == Sqlite.ROW);
return Retorno;
}

}




public class ProcessControldb:GLib.Object{

public int Id = 0;
public string Date = "";
public ProcessCtrl Ctrl = ProcessCtrl.None;
public string Note = "";

public ProcessControldb(int id = 0, ProcessCtrl ctrl = ProcessCtrl.None, string note = "", string date = "2000-01-01 00:00"){
Id = id;
Date = date;
Ctrl = ctrl;
Note = note;
}

public ProcessControldb.from_string(string? id, string? ctrl, string? note = "", string? date = "2000-01-01 00:00"){

if(id!=null){
Id = int.parse(id);
}else{
Id = 0;
}

if(date != null){
Date = date;
}else{
Date = "2000-01-01";
}

if(ctrl != null){
Ctrl = (ProcessCtrl)int.parse(ctrl);
}else{
Ctrl = ProcessCtrl.None;
}

if(note != null){
Note = note;
}else{
Note = "";
}

}

}

public class TableProcessControl:GLib.Object{

public TableProcessControl(){


}

public static int64 Insert(ProcessControldb row){

int64 Retorno = 0;
    Database db;
    Statement stmt;
    int rc = 0;
string query = "INSERT INTO processcontrol (control, note) VALUES (?, ?)";
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){
//stmt.bind_int(1, row.Id);
stmt.bind_int(1, (int)row.Ctrl);
stmt.bind_text(2, row.Note);

stmt.step();
//  printerr ("SQL %s\n", db.errmsg ());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = db.last_insert_rowid ();
}
}
return Retorno;
}



//***********************************************
// Obtiene todas las configuracion registradas en la base de datos
[Description(nick = "Update row", blurb = "")]
public static bool Update(ProcessControldb contrl){
bool Retorno = false;
var Query = new StringBuilder();

    Database db;
    Statement stmt;
    int rc = 0;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
  //      return;
    }

Query.append("UPDATE processcontrol SET note = ? WHERE id = ?");

    if ((rc = db.prepare_v2 (Query.str, -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
//        return;
    }

if(stmt != null){
/*
stmt.bind_text(1, conf.Root);
stmt.bind_int(2, conf.Port);
stmt.bind_int(3, (int)conf.Enable);
*/
stmt.bind_text(1, contrl.Note);
//stmt.bind_text(5, conf.HomePage);
stmt.bind_int(2, contrl.Id);

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



//***********************************************
// 
public static ProcessControldb RowById(int Id){

var Retorno = new ProcessControldb();
//print("Cargando configuracion de UiWeb server\n");
    Database db;
    Statement stmt;
    int rc = 0;
    int cols;
    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }
    if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol WHERE id = "+Id.to_string(), -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }
    cols = stmt.column_count();
    do {
        rc = stmt.step();
        switch (rc) {
        case Sqlite.DONE:
            break;
        case Sqlite.ROW:
//print("Puert %s\n", ((bool)stmt.column_int(2)).to_string());

Retorno.Id = stmt.column_int(0);
Retorno.Date = stmt.column_text(1);
Retorno.Ctrl =  (ProcessCtrl)stmt.column_int(2);
Retorno.Note = stmt.column_text(3);

//Retorno.add(Puerto);

            break;
        default:
            printerr ("Error: %d, %s\n", rc, db.errmsg ());
            break;
        }
    } while (rc == Sqlite.ROW);

return Retorno;
}

//***********************************************
// 
public static ProcessControldb Last(){

var Retorno = new ProcessControldb();
//print("Cargando configuracion de UiWeb server\n");
    Database db;
    Statement stmt;
    int rc = 0;
    int cols;
    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }
    if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol ORDER BY id DESC LIMIT 1", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }
    cols = stmt.column_count();
    do {
        rc = stmt.step();
        switch (rc) {
        case Sqlite.DONE:
            break;
        case Sqlite.ROW:
Retorno.Id = stmt.column_int(0);
Retorno.Date = stmt.column_text(1);
Retorno.Ctrl =  (ProcessCtrl)stmt.column_int(2);
Retorno.Note = stmt.column_text(3);

//Retorno.add(Puerto);

            break;
        default:
            printerr ("Error: %d, %s\n", rc, db.errmsg ());
            break;
        }
    } while (rc == Sqlite.ROW);

return Retorno;
}

public static ArrayList<ProcessControldb> All(){

var Retorno = new ArrayList<ProcessControldb>();
//print("Cargando configuracion de UiWeb server\n");
    Database db;
    Statement stmt;
    int rc = 0;
    int cols;
    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }
    if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol ORDER BY id DESC", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }
    cols = stmt.column_count();
    do {
        rc = stmt.step();
        switch (rc) {
        case Sqlite.DONE:
            break;
        case Sqlite.ROW:
//print("Puert %s\n", ((bool)stmt.column_int(2)).to_string());
ProcessControldb PC = new ProcessControldb();
PC.Id = stmt.column_int(0);
PC.Date = stmt.column_text(1);
PC.Ctrl =  (ProcessCtrl)stmt.column_int(2);
PC.Note = stmt.column_text(3);

Retorno.add(PC);

            break;
        default:
            printerr ("Error: %d, %s\n", rc, db.errmsg ());
            break;
        }
    } while (rc == Sqlite.ROW);

return Retorno;
}



}

//****************************************
//****************************************
public class TableSerialPort:GLib.Object{

public TableSerialPort(){

}


public static string AllXml(){

var XmlDatasTable = XmlDatas.Node("serialport");
//SMSData.Name = "smsout";

foreach(var Datos in All()){

XmlRow Fila = new XmlRow();
Fila.Name = "row";
Fila.addFieldUint("idport", Datos.Id);
Fila.addFieldString("port", Datos.Port, true);
Fila.addFieldBool("enable", Datos.Enable);
Fila.addFieldInt("baudrate", (int)Datos.BaudRate);
Fila.addFieldInt("databits", (int)Datos.DataBits);
Fila.addFieldInt("stopbits", (int)Datos.StopBitsp);
Fila.addFieldInt("parity", Datos.Parityp);
Fila.addFieldInt("handshake", (int)Datos.HandShake);
Fila.addFieldString("note", Datos.Note, true);

XmlDatasTable->add_child(Fila.Row());
}

return XmlDatas.XmlDocToString(XmlDatasTable);
}

//***********************************************
// Lista de puertos
public static ArrayList<SerialPortConf> All(){

var Retorno = new ArrayList<SerialPortConf>();

    Database db;
    Statement stmt;
    int rc = 0;
    int cols;
    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }
    if ((rc = db.prepare_v2 ("SELECT * FROM serialport", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }
    cols = stmt.column_count();
    do {
        rc = stmt.step();
        switch (rc) {
        case Sqlite.DONE:
            break;
        case Sqlite.ROW:
//print("Puert %s\n", ((bool)stmt.column_int(2)).to_string());
SerialPortConf Puerto = new SerialPortConf();
Puerto.Id = stmt.column_int(0);
Puerto.Port =  stmt.column_text(1);
Puerto.Enable = (bool)stmt.column_int(2);
Puerto.BaudRate = stmt.column_int(3);
Puerto.DataBits = stmt.column_int(4);
Puerto.Parityp = (Ports.Parity)stmt.column_int(5);
Puerto.StopBitsp = (Ports.StopBits)stmt.column_int(6);
Puerto.HandShake = (Ports.HandShaking)stmt.column_int(7);
Puerto.Note = stmt.column_text(8);
Puerto.LogLevel = StringToArrayListLogLevel(stmt.column_text(9));


Retorno.add(Puerto);

            break;
        default:
            printerr ("Error: %d, %s\n", rc, db.errmsg ());
            break;
        }
    } while (rc == Sqlite.ROW);

return Retorno;
}

private static ArrayList<LogLevelFlags> StringToArrayListLogLevel(string logleveltext){
var Retorno = new ArrayList<LogLevelFlags>();
var Niveles = logleveltext.split(",");

LogLevelFlags temolog = LogLevelFlags.LEVEL_ERROR;

foreach(var n in Niveles){
temolog = (LogLevelFlags)int.parse(n.strip());
if(!(temolog in Retorno)){
Retorno.add(temolog);
}
}

return Retorno;
}

// Lista de puertos habilitados
public static ArrayList<SerialPortConf> Enables(){

var Retorno = new ArrayList<SerialPortConf>();
foreach(var Puerto in All()){
//print("Puert> %s\n", (Puerto.Enable).to_string());
if(Puerto.Enable){
Retorno.add(Puerto);
}
}
return Retorno;
}

public static int64 InsertUpdateFromWeb(HashMap<string, string> postData){

int64 Retorno = 0;
SerialPortConf Puerto = new SerialPortConf();

foreach(var D in postData.entries){
print("[%s] => %s\n", D.key, D.value);
}
/*
[fieldport] => /dev/ttyUSB3
[fielddb] => 8
[fieldid] => 1
[fieldparity] => 0
[fieldbr] => 0
[fieldhsk] => 0
[fieldnote] => nada de comentario
[fieldstb] => 1
*/


if(postData.has_key("fieldid")){
Puerto.Id = int.parse(postData["fieldid"]);
}


if(Puerto.Id >= 0){
// Si es > 0 es actualizacion o insercion
if(postData.has_key("fieldport")){
Puerto.Port = postData["fieldport"];
}

if(postData.has_key("fieldenable")){
Puerto.Enable = true;
}else{
Puerto.Enable = false;
}

if(postData.has_key("fieldbr")){
Puerto.BaudRate = int.parse(postData["fieldbr"]);
}

if(postData.has_key("fielddb")){
Puerto.DataBits = int.parse(postData["fielddb"]);
}

if(postData.has_key("fieldparity")){
Puerto.Parityp = (Ports.Parity)int.parse(postData["fieldparity"]);
}
if(postData.has_key("fieldstb")){
Puerto.StopBitsp = (Ports.StopBits)int.parse(postData["fieldstb"]);
}



if(postData.has_key("fieldhsk")){
Puerto.HandShake = (Ports.HandShaking)int.parse(postData["fieldhsk"]);
}

if(postData.has_key("fieldnote")){
Puerto.Note = postData["fieldnote"];
}

Retorno = InsertUpdate(Puerto);

}else{
var iddel = Puerto.Id.abs();
// Es eliminacion de registro
if(Delete(iddel)){
Retorno = iddel;
}else{
Retorno = 0;
}
}

/*
Puerto.Id = stmt.column_int(0);
Puerto.Port =  stmt.column_text(1);
Puerto.Enable = (bool)stmt.column_int(2);
Puerto.BaudRate = stmt.column_int(3);
Puerto.DataBits = stmt.column_int(4);
Puerto.Parityp = (Ports.Parity)stmt.column_int(5);
Puerto.StopBitsp = (Ports.StopBits)stmt.column_int(6);
Puerto.HandShake = (Ports.HandShaking)stmt.column_int(7);
Puerto.Note = stmt.column_text(8);
Puerto.LogLevel = StringToArrayListLogLevel(stmt.column_text(9));
*/

return Retorno;
}


public static int64 InsertUpdate(SerialPortConf row){
int64 Retorno = 0;
if(row.Id>0){
if(Update(row)){
Retorno = row.Id;
}else{
Retorno = 0;
}
}else{
Retorno = Insert(row);
}
return Retorno;
}

public static int64 Insert(SerialPortConf row){

int64 Retorno = 0;

    Database db;
    Statement stmt;
    int rc = 0;
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 ("INSERT INTO serialport (port, enable, baudrate, databits, parity, stopbits, handshake, note, loglevel) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", -1, out stmt, null)) == 1) {
        printerr ("Insert SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){
//stmt.bind_int(1, (int)row.Id);
stmt.bind_text(1, row.Port);
stmt.bind_int(2, (int)row.Enable);
stmt.bind_int(3, (int)row.BaudRate);
stmt.bind_int(4, (int)row.DataBits);
stmt.bind_int(5, (int)row.Parityp);
stmt.bind_int(6, (int)row.StopBitsp);
stmt.bind_int(7, (int)row.HandShake);
stmt.bind_text(8, row.Note);
stmt.bind_text(9, "");

stmt.step();
      //  printerr ("SQL %s\n", stmt.sql());
db.exec("COMMIT");
       // printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = db.last_insert_rowid ();
}
}
return Retorno;
}



public static bool Update(SerialPortConf row){
bool Retorno = false;
    Database db;
    Statement stmt;
    int rc = 0;
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 ("UPDATE serialport SET port = ?, enable = ?, baudrate = ?, databits = ?, parity = ?, stopbits = ?, handshake = ?, note = ?, loglevel = ? WHERE idport = ?", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){

stmt.bind_text(1, row.Port);
stmt.bind_int(2, (int)row.Enable);
stmt.bind_int(3, (int)row.BaudRate);
stmt.bind_int(4, (int)row.DataBits);
stmt.bind_int(5, (int)row.Parityp);
stmt.bind_int(6, (int)row.StopBitsp);
stmt.bind_int(7, (int)row.HandShake);
//stmt.bind_int(8, (int)row.TimeOut);
stmt.bind_text(8, row.Note);
stmt.bind_text(9, ArrayLogLevelToString(row.LogLevel));
stmt.bind_int(10, (int)row.Id);


stmt.step();
      //  printerr ("SQL %s\n", stmt.sql());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = true;
}
}
return Retorno;
}

private static string ArrayLogLevelToString(ArrayList<LogLevelFlags> llevel){
var Retorno = new StringBuilder();

foreach(var l in llevel){
Retorno.append_printf("%i,", (int)l);
}
Retorno.truncate(Retorno.len-1);
return Retorno.str;
}

public static bool Delete(uint IdPort){
bool Retorno = false;
    Database db;
    Statement stmt;
    int rc = 0;
  //  int cols;

    if ((rc = Database.open (FILECONF, out db)) == 1) {
        printerr ("Can't open database: %s\n", db.errmsg ());
    //    return;
    }

    if ((rc = db.prepare_v2 ("DELETE FROM serialport WHERE idport = ?", -1, out stmt, null)) == 1) {
        printerr ("SQL error: %d [%s], %s\n", rc, FILECONF, db.errmsg ());
//        return;
    }

if(stmt != null){

stmt.bind_int(1, (int)IdPort);

stmt.step();
      //  printerr ("SQL %s\n", stmt.sql());
db.exec("COMMIT");
        //printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
if(db.changes ()>0){
Retorno = true;
}
}
return Retorno;
}



}






}












