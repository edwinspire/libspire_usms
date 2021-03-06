/////////////////////////////////////////////////////////
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
using Sqlite;
using edwinspire.uSMS;
using edwinspire.Ports;
using edwinspire.pgSQL;
namespace edwinspire.uSMS {
	public const string FILE_CONF = "usmsd.sqlite";
	public struct TableRowPostgres {
		public pgSQL.ConnectionParameters Parameters;
		public string Note;
		public int64 Id;
		public bool Enable;
		public TableRowPostgres() {
			this.Parameters = ConnectionParameters();
			this.Note = "";
			this.Id = 0;
			this.Enable = false;
		}
	}
	public class SQLiteNotificationRow {
		public int id = 0;
		public string title = "";
		public string body = "";
		public int urgency = 0;
		public int timeout = 10;
		public string img = "";
		public string snd = "";
		public string note = "";
		public SQLiteNotificationRow() {
			/*this.id = 0;
this.title = "";
this.body = "";
this.urgency = 0;
this.timeout = 10;
this.img = "";
this.snd = "";
this.note = "";*/
		}
	}
	public class SQliteNotificationsDb:GLib.Object {
		private string File = "notifications.sqlite";
		public SQliteNotificationsDb() {
		}
		public string notifications_data_to_xml(SQLiteNotificationRow lastRow) {
			var Retorno = new StringBuilder("<usms>");
			Retorno.append_printf("%s", this.notifications_row_to_xml(lastRow));
			Retorno.append("</usms>");
			return Retorno.str;
		}
		public string notifications_row_to_xml(SQLiteNotificationRow lastRow) {
			var Retorno = new StringBuilder("<row>");
			Retorno.append_printf("<id>%i</id>", lastRow.id);
			Retorno.append_printf("<title>%s</title>", Base64.encode(lastRow.title.data));
			Retorno.append_printf("<body>%s</body>", Base64.encode(lastRow.body.data));
			Retorno.append_printf("<urgency>%i</urgency>", lastRow.urgency);
			Retorno.append_printf("<timeout>%i</timeout>", lastRow.timeout);
			Retorno.append_printf("<img>%s</img>", Base64.encode(lastRow.img.data));
			Retorno.append_printf("<snd>%s</snd>", Base64.encode(lastRow.snd.data));
			Retorno.append_printf("<note>%s</note>", Base64.encode(lastRow.note.data));
			Retorno.append("</row>");
			return Retorno.str;
		}
		public string notifications_next_xml(int last) {
			var Retorno = new StringBuilder("<notifications>");
			var Listr = this.notifications_next(last);
			foreach(var x in Listr) {
				Retorno.append(this.notifications_row_to_xml(x));
			}
			Retorno.append("</notifications>");
			return  Retorno.str;
		}
		public  ArrayList<SQLiteNotificationRow> notifications_next(int last) {
			var RetornoXXX = new ArrayList<SQLiteNotificationRow>();
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (File, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM notifications WHERE idnotify > ? AND datetime > datetime('now', '-2 Minute') ORDER BY idnotify", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, File, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				stmt.bind_int(1, last);
				//stmt.bind_int(2, last);
				cols = stmt.column_count();
				//print("colsssss %s\n", cols.to_string());
				do {
					//print("rc >> %s\n", rc.to_string());
					rc = stmt.step();
					switch (rc) {
						case Sqlite.DONE:
						            break;
						case Sqlite.ROW:
						SQLiteNotificationRow Retorno = new SQLiteNotificationRow();
						Retorno.id = stmt.column_int(0);
						Retorno.urgency = stmt.column_int(2);
						Retorno.timeout = stmt.column_int(3);
						Retorno.img =  stmt.column_text(4);
						Retorno.snd = stmt.column_text(5);
						Retorno.title = stmt.column_text(6);
						Retorno.body = stmt.column_text(7);
						Retorno.note = stmt.column_text(8);
						RetornoXXX.add(Retorno);
						break;
						default:
						            printerr ("Error: %d, %s\n", rc, db.errmsg ());
						break;
					}
				}
				while (rc == Sqlite.ROW);
			}
			return RetornoXXX;
		}
		public SQLiteNotificationRow notifications_last() {
			SQLiteNotificationRow Retorno = new SQLiteNotificationRow();
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (File, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM notifications ORDER BY idnotify DESC LIMIT 1", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, File, db.errmsg ());
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
					Retorno.id = stmt.column_int(0);
					Retorno.urgency = stmt.column_int(2);
					Retorno.timeout = stmt.column_int(3);
					Retorno.img =  stmt.column_text(4);
					Retorno.snd = stmt.column_text(5);
					Retorno.title = stmt.column_text(6);
					Retorno.body = stmt.column_text(7);
					Retorno.note = stmt.column_text(8);
					break;
					default:
					            printerr ("Error: %d, %s\n", rc, db.errmsg ());
					break;
				}
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
		public int64 notifications_insert_from_hashmap(HashMap<string, string> data) {
			SQLiteNotificationRow Data = new SQLiteNotificationRow();
			if(data.has_key("title")) {
				Data.title = data["title"];
			}
			if(data.has_key("body")) {
				Data.body = data["body"];
			}
			if(data.has_key("urgency")) {
				Data.urgency = int.parse(data["urgency"]);
			}
			if(data.has_key("timeout")) {
				Data.timeout = int.parse(data["timeout"]);
			}
			if(data.has_key("img")) {
				Data.img = data["img"];
			}
			if(data.has_key("snd")) {
				Data.snd = data["snd"];
			}
			if(data.has_key("note")) {
				Data.note = data["note"];
			}
			return notifications_insert(Data.title, Data.body, Data.urgency, Data.timeout, Data.img, Data.snd, Data.note);
		}
		public int64 notifications_insert(string title, string body = "", int urgency = 0, int timeout = 10, string img = "", string snd = "", string note = "") {
			int64 Retorno = 0;
			Database db;
			Statement stmt;
			int rc = 0;
			string query = "INSERT INTO notifications (title, body, urgency, timeout, img, snd, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
			//  int cols;
			if ((rc = Database.open (File, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, File, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				stmt.bind_text(1, title);
				stmt.bind_text(2, body);
				stmt.bind_int(3, urgency);
				stmt.bind_int(4, timeout);
				stmt.bind_text(5, img);
				stmt.bind_text(6, snd);
				stmt.bind_text(7, note);
				stmt.step();
				//  printerr ("SQL %s\n", db.errmsg ());
				db.exec("COMMIT");
				//printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
				if(db.changes ()>0) {
					Retorno = db.last_insert_rowid ();
				}
			}
			return Retorno;
		}
		public void build_table_notifications() {
			int64 Retorno = 0;
			Database db;
			Statement stmt;
			int rc = 0;
			string query = """CREATE TABLE IF NOT EXISTS "notifications" ("idnotify" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "datetime" DATETIME DEFAULT CURRENT_TIMESTAMP, "urgency" INTEGER NOT NULL  DEFAULT 0, "timeout" INTEGER NOT NULL  DEFAULT 5, "img" TEXT NOT NULL  check(typeof("img") = 'text')  DEFAULT 'default.png', "snd" TEXT NOT NULL  check(typeof("snd") = 'text')  DEFAULT 'default.wav', "title" TEXT NOT NULL  check(typeof("title") = 'text')  DEFAULT 'Notification', "body" TEXT NOT NULL  check(typeof("body") = 'text')  DEFAULT '-', "note" TEXT check(typeof("note") = 'text') )""";
			//  int cols;
			if ((rc = Database.open (File, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, File, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				/*
stmt.bind_int(1, (int)row.Enable);
stmt.bind_text(2, row.Parameters.Host);
stmt.bind_int(3, (int)row.Parameters.Port);
stmt.bind_text(4, row.Parameters.db);
stmt.bind_text(5, row.Parameters.User);
stmt.bind_text(6, row.Parameters.Pwd);
stmt.bind_int(7, (int)row.Parameters.SSL);
stmt.bind_int(8, (int)row.Parameters.TimeOut);
stmt.bind_text(9, row.Note);
*/
				//stmt.bind_int(10, row.Id);
				stmt.step();
				//  printerr ("SQL %s\n", db.errmsg ());
				db.exec("COMMIT");
				//printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
				if(db.changes ()>0) {
					Retorno = db.last_insert_rowid ();
				}
			}
			//return Retorno;
		}
	}
	public class TablePostgres:GLib.Object {
		public TablePostgres() {
		}
		public static int64 InsertRow(TableRowPostgres row) {
			int64 Retorno = 0;
			Database db;
			Statement stmt;
			int rc = 0;
			string query = "INSERT INTO postgres (enable, host, port, dbname, user, pwd, ssl, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
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
				if(db.changes ()>0) {
					Retorno = db.last_insert_rowid ();
				}
			}
			return Retorno;
		}
		public static int64 UpdateFromWeb(HashMap<string, string> Form) {
			int64 id = TablePostgres.LastRowEnabled().Id;
			TableRowPostgres datos = TableRowPostgres();
			datos.Id = id;
			datos.Enable = true;
			if(Form.size>0) {
				datos.Parameters.Host = Form["host"];
				datos.Parameters.Port = (uint)int.parse(Form["port"]);
				datos.Parameters.db =  Form["db"];
				datos.Parameters.User = Form["user"];
				datos.Parameters.Pwd = Form["pwd"];
				if(Form["ssl"] != null && Form["ssl"] == "true") {
					datos.Parameters.SSL = true;
				} else {
					datos.Parameters.SSL = false;
				}
				datos.Parameters.TimeOut = 0;
				datos.Note = Form["note"];
			} else {
				id = 0;
			}
			if(id>0) {
				id = TablePostgres.UpdateRow(datos);
			} else {
				id = TablePostgres.InsertRow(datos);
			}
			return id;
		}
		public static int64 UpdateRow(TableRowPostgres row) {
			int64 Retorno = row.Id;
			Database db;
			Statement stmt;
			int rc = 0;
			string query = "UPDATE postgres SET enable=?, host=?, port=?, dbname=?, user=?, pwd=?, ssl=?, note=?  WHERE id=?";
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
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
				if(db.changes ()>0) {
					//Retorno = db.last_insert_rowid ();
					Retorno = row.Id;
					//print(">>> %s >> %s\n", Retorno.to_string(), row.Id.to_string());
				} else {
					Retorno = 0;
				}
			}
			return Retorno;
		}
		// Obtiene los datos de conexion en formato Xml
		public static string LastRowEnabledXML() {
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
		public static TableRowPostgres LastRowEnabled() {
			TableRowPostgres Retorno = TableRowPostgres();
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM postgres WHERE enable = 1 ORDER BY id DESC LIMIT 1", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
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
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
	}
	public class ProcessControldb:GLib.Object {
		public int Id = 0;
		public string Date = "";
		public ProcessCtrl Ctrl = ProcessCtrl.None;
		public string Note = "";
		public ProcessControldb(int id = 0, ProcessCtrl ctrl = ProcessCtrl.None, string note = "", string date = "2000-01-01 00:00") {
			Id = id;
			Date = date;
			Ctrl = ctrl;
			Note = note;
		}
		public ProcessControldb.from_string(string? id, string? ctrl, string? note = "", string? date = "2000-01-01 00:00") {
			if(id!=null) {
				Id = int.parse(id);
			} else {
				Id = 0;
			}
			if(date != null) {
				Date = date;
			} else {
				Date = "2000-01-01";
			}
			if(ctrl != null) {
				Ctrl = (ProcessCtrl)int.parse(ctrl);
			} else {
				Ctrl = ProcessCtrl.None;
			}
			if(note != null) {
				Note = note;
			} else {
				Note = "";
			}
		}
	}
	public class TableProcessControl:GLib.Object {
		public TableProcessControl() {
		}
		public static int64 Insert(ProcessControldb row) {
			int64 Retorno = 0;
			Database db;
			Statement stmt;
			int rc = 0;
			string query = "INSERT INTO processcontrol (control, note) VALUES (?, ?)";
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 (query, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d %s\n[%s], %s\n", rc, query, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				//stmt.bind_int(1, row.Id);
				stmt.bind_int(1, (int)row.Ctrl);
				stmt.bind_text(2, row.Note);
				stmt.step();
				//  printerr ("SQL %s\n", db.errmsg ());
				db.exec("COMMIT");
				//printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
				if(db.changes ()>0) {
					Retorno = db.last_insert_rowid ();
				}
			}
			return Retorno;
		}
		//***********************************************
		// Obtiene todas las configuracion registradas en la base de datos
		[Description(nick = "Update row", blurb = "")]
		public static bool Update(ProcessControldb contrl) {
			bool Retorno = false;
			var Query = new StringBuilder();
			Database db;
			Statement stmt;
			int rc = 0;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//      return;
			}
			Query.append("UPDATE processcontrol SET note = ? WHERE id = ?");
			if ((rc = db.prepare_v2 (Query.str, -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
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
				if(db.changes ()>0) {
					Retorno = true;
				}
			}
			//    printerr ("SQL error: %d, %s\n", rc, db.errmsg ());
			//        printerr ("SQL changes: %d, %i\n", rc, db.changes ());
			return Retorno;
		}
		//***********************************************
		// 
		public static ProcessControldb RowById(int Id) {
			var Retorno = new ProcessControldb();
			//print("Cargando configuracion de UiWeb server\n");
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol WHERE id = "+Id.to_string(), -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
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
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
		//***********************************************
		// 
		public static ProcessControldb Last() {
			var Retorno = new ProcessControldb();
			//print("Cargando configuracion de UiWeb server\n");
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol ORDER BY id DESC LIMIT 1", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
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
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
		public static ArrayList<ProcessControldb> All() {
			var Retorno = new ArrayList<ProcessControldb>();
			//print("Cargando configuracion de UiWeb server\n");
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM processcontrol ORDER BY id DESC", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
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
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
	}
	//****************************************
	//****************************************
	public class TableSerialPort:GLib.Object {
		public TableSerialPort() {
		}
		public static string AllXml() {
			var Retorno = new StringBuilder("<table>");
			foreach(var Datos in All()) {
				Retorno.append_printf("<row><idport>%i</idport><port>%s</port><enable>%s</enable><baudrate>%i</baudrate><databits>%i</databits><stopbits>%i</stopbits><parity>%i</parity><handshake>%i</handshake><note>%s</note></row>", Datos.Id, Base64.encode(Datos.Port.data), Datos.Enable.to_string(), (int)Datos.BaudRate, (int)Datos.DataBits, (int)Datos.StopBitsp, (int)Datos.Parityp, (int)Datos.HandShake, Base64.encode(Datos.Note.data));
			}
			/*
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
return XmlDatas.XmlDocToString(XmlDatasTable);*/
			Retorno.append("</table>");
			return Retorno.str;
		}
		//***********************************************
		// Lista de puertos
		public static ArrayList<SerialPortConf> All() {
			var Retorno = new ArrayList<SerialPortConf>();
			Database db;
			Statement stmt;
			int rc = 0;
			int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("SELECT * FROM serialport", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
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
			}
			while (rc == Sqlite.ROW);
			return Retorno;
		}
		private static ArrayList<LogLevelFlags> StringToArrayListLogLevel(string logleveltext) {
			var Retorno = new ArrayList<LogLevelFlags>();
			var Niveles = logleveltext.split(",");
			LogLevelFlags temolog = LogLevelFlags.LEVEL_ERROR;
			foreach(var n in Niveles) {
				temolog = (LogLevelFlags)int.parse(n.strip());
				if(!(temolog in Retorno)) {
					Retorno.add(temolog);
				}
			}
			return Retorno;
		}
		// Lista de puertos habilitados
		public static ArrayList<SerialPortConf> Enables() {
			var Retorno = new ArrayList<SerialPortConf>();
			foreach(var Puerto in All()) {
				//print("Puert> %s\n", (Puerto.Enable).to_string());
				if(Puerto.Enable) {
					Retorno.add(Puerto);
				}
			}
			return Retorno;
		}
		public static int64 InsertUpdateFromWeb(HashMap<string, string> postData) {
			int64 Retorno = 0;
			SerialPortConf Puerto = new SerialPortConf();
			foreach(var D in postData.entries) {
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
			if(postData.has_key("idport")) {
				Puerto.Id = int.parse(postData["idport"]);
			}
			if(Puerto.Id >= 0) {
				// Si es > 0 es actualizacion o insercion
				if(postData.has_key("port")) {
					Puerto.Port = postData["port"];
				}
				if(postData.has_key("enable")) {
					Puerto.Enable = bool.parse(postData["enable"]);
				}
				if(postData.has_key("baudrate")) {
					Puerto.BaudRate = int.parse(postData["baudrate"]);
				}
				if(postData.has_key("databits")) {
					Puerto.DataBits = int.parse(postData["databits"]);
				}
				if(postData.has_key("parity")) {
					Puerto.Parityp = (Ports.Parity)int.parse(postData["parity"]);
				}
				if(postData.has_key("stopbits")) {
					Puerto.StopBitsp = (Ports.StopBits)int.parse(postData["stopbits"]);
				}
				if(postData.has_key("handshake")) {
					Puerto.HandShake = (Ports.HandShaking)int.parse(postData["handshake"]);
				}
				if(postData.has_key("note")) {
					Puerto.Note = postData["note"];
				}
				Retorno = InsertUpdate(Puerto);
			} else {
				var iddel = Puerto.Id.abs();
				// Es eliminacion de registro
				if(Delete(iddel)) {
					Retorno = iddel;
				} else {
					Retorno = 0;
				}
			}
			return Retorno;
		}
		public static int64 InsertUpdate(SerialPortConf row) {
			int64 Retorno = 0;
			if(row.Id>0) {
				if(Update(row)) {
					Retorno = row.Id;
				} else {
					Retorno = 0;
				}
			} else {
				Retorno = Insert(row);
			}
			return Retorno;
		}
		public static int64 Insert(SerialPortConf row) {
			int64 Retorno = 0;
			Database db;
			Statement stmt;
			int rc = 0;
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("INSERT INTO serialport (port, enable, baudrate, databits, parity, stopbits, handshake, note, loglevel) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", -1, out stmt, null)) == 1) {
				printerr ("Insert SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
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
				if(db.changes ()>0) {
					Retorno = db.last_insert_rowid ();
				}
			}
			return Retorno;
		}
		public static bool Update(SerialPortConf row) {
			bool Retorno = false;
			Database db;
			Statement stmt;
			int rc = 0;
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("UPDATE serialport SET port = ?, enable = ?, baudrate = ?, databits = ?, parity = ?, stopbits = ?, handshake = ?, note = ?, loglevel = ? WHERE idport = ?", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
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
				if(db.changes ()>0) {
					Retorno = true;
				}
			}
			return Retorno;
		}
		private static string ArrayLogLevelToString(ArrayList<LogLevelFlags> llevel) {
			var Retorno = new StringBuilder();
			foreach(var l in llevel) {
				Retorno.append_printf("%i,", (int)l);
			}
			Retorno.truncate(Retorno.len-1);
			return Retorno.str;
		}
		public static bool Delete(uint IdPort) {
			bool Retorno = false;
			Database db;
			Statement stmt;
			int rc = 0;
			//  int cols;
			if ((rc = Database.open (FILE_CONF, out db)) == 1) {
				printerr ("Can't open database: %s\n", db.errmsg ());
				//    return;
			}
			if ((rc = db.prepare_v2 ("DELETE FROM serialport WHERE idport = ?", -1, out stmt, null)) == 1) {
				printerr ("SQL error: %d [%s], %s\n", rc, FILE_CONF, db.errmsg ());
				//        return;
			}
			if(stmt != null) {
				stmt.bind_int(1, (int)IdPort);
				stmt.step();
				//  printerr ("SQL %s\n", stmt.sql());
				db.exec("COMMIT");
				//printerr ("SQL changes del: %d, %i\n", rc, db.changes ());
				if(db.changes ()>0) {
					Retorno = true;
				}
			}
			return Retorno;
		}
	}
}
